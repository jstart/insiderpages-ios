//
//  CDIListsViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "IPILeftPagesViewController.h"
#import "IPIPageTableViewCell.h"
//#import "CDIListViewController.h"
//#import "CDICreateListViewController.h"
//#import "CDISettingsViewController.h"
#import "IPISplitViewController.h"
#import "UIColor+CheddariOSAdditions.h"
//#import "CDIUpgradeViewController.h"
//#import "CDINoListsView.h"
//#import "CDIAddListTableViewCell.h"
#import "SSFilterableFetchedResultsController.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>

#define CHEDDAR_USE_PASSWORD_FLOW 1

#ifdef CHEDDAR_USE_PASSWORD_FLOW
	#import "CDISignUpViewController.h"
#else
	#import "CDIWebSignInViewController.h"
#endif

@interface IPILeftPagesViewController ()
- (void)_currentUserDidChange:(NSNotification *)notification;
- (void)_checkUser;
@end

@implementation IPILeftPagesViewController 

#pragma mark - NSObject

- (void)dealloc {

}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];

    //	self.noContentView = [[CDINoListsView alloc] initWithFrame:CGRectZero];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_listUpdated:) name:kIPKListDidUpdateNotificationName object:nil];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kIPKCurrentUserChangedNotificationName object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		[self _checkUser];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[self _checkUser];
	}
	
	[SSRateLimit executeBlock:^{
		[self refresh:nil];
	} name:@"refresh-lists" limit:30.0];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	if (editing) {
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEditMode:)];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings:)];
	} else {
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEditMode:)];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(createList:)];
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKPage class];
}


- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"name != %@", @""];
}

-(NSArray *)sortDescriptors{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"section_header" ascending:NO],
            [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO],
            [NSSortDescriptor sortDescriptorWithKey:@"remoteID" ascending:NO],
            nil];
}

- (NSString *)sectionNameKeyPath {
	return @"section_header";
}

#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//	CDKList *list = [self objectForViewIndexPath:indexPath];
//	[(CDIListTableViewCell *)cell setList:list];
}


- (NSIndexPath *)viewIndexPathForFetchedIndexPath:(NSIndexPath *)fetchedIndexPath {

	return fetchedIndexPath;
}


- (NSIndexPath *)fetchedIndexPathForViewIndexPath:(NSIndexPath *)viewIndexPath {

	return viewIndexPath;
}


#pragma mark - CDIManagedTableViewController

- (void)coverViewTapped:(id)sender {
 
}


#pragma mark - Actions

- (void)refresh:(id)sender {
	if (self.loading || ![IPKUser currentUser]) {
		return;
	}
	
	self.loading = YES;
    NSString * myUserId = [NSString stringWithFormat:@"%@", [IPKUser currentUser].id];
	[[IPKHTTPClient sharedClient] getPagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.loading = NO;
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[SSRateLimit resetLimitForName:@"refresh-mine-pages"];
			self.loading = NO;
		});
	}];
    
    [[IPKHTTPClient sharedClient] getFavoritePagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.loading = NO;
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[SSRateLimit resetLimitForName:@"refresh-mine-pages"];
			self.loading = NO;
		});
	}];
    
    [[IPKHTTPClient sharedClient] getFollowingPagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.loading = NO;
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[SSRateLimit resetLimitForName:@"refresh-mine-pages"];
			self.loading = NO;
		});
	}];
}

#pragma mark - Private

- (void)_currentUserDidChange:(NSNotification *)notification {
	self.fetchedResultsController = nil;
	[self.tableView reloadData];
}

- (void)_checkUser {
	if (![IPKUser currentUser]) {
#ifdef CHEDDAR_USE_PASSWORD_FLOW
		UIViewController *viewController = [[CDISignUpViewController alloc] init];
#else
		UIViewController *viewController = [[CDIWebSignInViewController alloc] init];
#endif
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
		navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			[self.splitViewController presentModalViewController:navigationController animated:YES];
		} else {
			[self.navigationController presentModalViewController:navigationController animated:NO];
		}
		return;
	}
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
	
	return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";

	IPIPageTableViewCell *cell = (IPIPageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPIPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	cell.page = [self objectForViewIndexPath:indexPath];
	
	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	if (sourceIndexPath.row == destinationIndexPath.row) {
		return;
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Archive";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle != UITableViewCellEditingStyleDelete) {
		return;
	}
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
	
}

@end
