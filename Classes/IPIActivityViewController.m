//
//  CDIListsViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "IPIActivityViewController.h"
#import "IPISplitViewController.h"
#import "IPIPageViewController.h"
#import "IPIActivityTableViewCell.h"
#import "IPIActivityPageTableViewHeader.h"
#import "IPIActivityPageTableViewFooter.h"
#import "CDINoListsView.h"
#import "UIColor+CheddariOSAdditions.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>

#define CHEDDAR_USE_PASSWORD_FLOW 1

#ifdef CHEDDAR_USE_PASSWORD_FLOW
	#import "CDISignUpViewController.h"
#else
	#import "CDIWebSignInViewController.h"
#endif

@interface IPIActivityViewController ()
- (void)_listUpdated:(NSNotification *)notification;
- (void)_currentUserDidChange:(NSNotification *)notification;
- (void)_checkUser;
@end

@implementation IPIActivityViewController {
	BOOL _adding;
}

#pragma mark - NSObject

- (void)dealloc {

}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
//	UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-title.png"]];
//	title.frame = CGRectMake(0.0f, 0.0f, 116.0f, 21.0f);	
//	self.navigationItem.titleView = title;
    self.title = @"InsiderPages";
	[self setEditing:NO animated:NO];
    
    _adding = NO;
//	self.noContentView = [[CDINoListsView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundView.backgroundColor = [UIColor grayColor];
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
	} name:@"refresh-activity" limit:30.0];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKActivity class];
}


- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"user_id = %@", [IPKUser currentUser].id];
}

-(NSArray *)sortDescriptors{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"page.name" ascending:NO],
            [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO],
            [NSSortDescriptor sortDescriptorWithKey:@"remoteID" ascending:NO],
            nil];
}

- (NSString *)sectionNameKeyPath {
	return @"page.name";
}

#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	IPKActivity *activity = [self objectForViewIndexPath:indexPath];
	[(IPIActivityTableViewCell *)cell setActivity:activity];
}


- (NSIndexPath *)viewIndexPathForFetchedIndexPath:(NSIndexPath *)fetchedIndexPath {
	if (_adding) {
		return [NSIndexPath indexPathForRow:fetchedIndexPath.row + 1 inSection:fetchedIndexPath.section];
	}

	return fetchedIndexPath;
}


- (NSIndexPath *)fetchedIndexPathForViewIndexPath:(NSIndexPath *)viewIndexPath {
	if (_adding) {
		return [NSIndexPath indexPathForRow:viewIndexPath.row - 1 inSection:viewIndexPath.section];
	}

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

	[[IPKHTTPClient sharedClient] getMyActivititesOfType:IPKTrackableTypeAll currentPage:@1 perPage:@10 success:^(AFJSONRequestOperation *operation, id responseObject) {
        self.fetchedResultsController = nil;
		dispatch_async(dispatch_get_main_queue(), ^{
			self.loading = NO;
            [[self tableView] reloadData];
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[SSRateLimit resetLimitForName:@"refresh-activity"];
			self.loading = NO;
		});
	}];
}

#pragma mark - Private

- (void)_listUpdated:(NSNotification *)notification {
//	if ([notification.object isEqual:_selectedList.remoteID] == NO) {
//		return;
//	}
//
//	if (_selectedList.archivedAt != nil) {
//		[IPISplitViewController sharedSplitViewController].listViewController.managedObject = nil;
//		_selectedList = nil;
//	}
}


- (void)_currentUserDidChange:(NSNotification *)notification {
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

	if (_adding) {
		return rows + 1;
	}
	
	return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";

	IPIActivityTableViewCell *cell = (IPIActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPIActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	cell.activity = [self objectForViewIndexPath:indexPath];
	
	return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    // necessary, disables uitableviewindex http://stackoverflow.com/questions/3189345/remove-gray-uitableview-index-bar
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IPKActivity * activity = ((IPKActivity*)[self objectForViewIndexPath:indexPath]);
    if (activity.page.id == @0) {
        if (self.loading || ![IPKUser currentUser]) {
            return;
        }
        
        self.loading = YES;
        NSString * userIDString = [NSString stringWithFormat:@"%@", activity.user_id];
        [[IPKHTTPClient sharedClient] getPagesForUserWithId:userIDString success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:@"refresh-activity"];
                self.loading = NO;
            });
        }];
    }
    
    switch (activity.trackableType) {
        case IPKTrackableTypeProvider:{
            // Display BPP with approriate action
            IPIPageViewController * pageVC = [[IPIPageViewController alloc] init];
            pageVC.managedObject = activity.page;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
        case IPKTrackableTypeReview:{
            //Display Review with approriate action
            IPIPageViewController * pageVC = [[IPIPageViewController alloc] init];
            pageVC.managedObject = activity.page;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
        case IPKTrackableTypeUser:{
            //UPP
            IPIPageViewController * pageVC = [[IPIPageViewController alloc] init];
            pageVC.managedObject = activity.page;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
        case IPKTrackableTypeAll:{
            //Generic Activity
            IPIPageViewController * pageVC = [[IPIPageViewController alloc] init];
            pageVC.managedObject = activity.page;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 92.5 + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSIndexPath * sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    IPKPage * page = ((IPKActivity *)[self objectForViewIndexPath:sectionIndexPath]).page;
    IPIActivityPageTableViewHeader * headerView = [[IPIActivityPageTableViewHeader alloc] initWithFrame:CGRectMake(10, 0, 300, 92.5)];
    [headerView setPage:page];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSIndexPath * sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    IPKPage * page = ((IPKActivity *)[self objectForViewIndexPath:sectionIndexPath]).page;
    IPIActivityPageTableViewFooter * footerView = [[IPIActivityPageTableViewFooter alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    [footerView setPage:page];
    
    return footerView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (_adding) {
	}
}

#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
	
}

@end
