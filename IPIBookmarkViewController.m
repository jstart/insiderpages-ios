//
//  IPBookmarkViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkViewController.h"
#import "IPIBookmarkContainerViewController.h"
#import "IPIPageTableViewCell.h"
#import "IPIAppDelegate.h"
#import "IIViewDeckController.h"
#import "IPIPageViewController.h"

@interface IPIBookmarkViewController ()

@end

@implementation IPIBookmarkViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.tableView setFrame:CGRectMake(0, 0, 320, 200)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.parentViewController.parentViewController.title = @"My Pages";
    
    CGRect frame = self.headerViewController.view.frame;
    frame.origin.y =  self.parentViewController.view.frame.size.height - frame.size.height;
    [self.headerViewController.view setFrame:frame];
    [[self view] addSubview:self.headerViewController.view];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.parentViewController.view.frame.size.height - frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.contentMode = UIViewContentModeScaleToFill;
//    self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"One", @"Two", nil];
    self.searchBar.showsScopeBar = YES;
    [self.tableView setTableHeaderView:self.searchBar];

    self.headerViewController = [[IPIBookmarkHeaderViewController alloc] initWithNibName:@"IPIBookmarkHeaderViewController" bundle:[NSBundle mainBundle]];
    
    if ([IPKUser currentUser]) {
        self.headerViewController.usernameLabel.text = [[IPKUser currentUser] name];
        [self.headerViewController.profileImageView setPathToNetworkImage:[[IPKUser currentUser] imageProfilePathForSize:IPKUserProfileImageSizeMedium]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kIPKCurrentUserChangedNotificationName object:nil];
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-my-pages" limit:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void(^)(void))refresh {
    return ^(void){
        if (self.loading || ![IPKUser currentUser]) {
            return;
        }
        
        self.loading = YES;
        NSString * myUserId = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"IPKUserID"]];
        [[IPKHTTPClient sharedClient] getPagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [self.fetchedResultsController performFetch:nil];
                [self.tableView reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:@"refresh-mine-pages"];
                self.loading = NO;
            });
        }];
    };
}

- (void(^)(void))nextPage {
    return ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loading = NO;
        });
    };
}

#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKPage class];
}

- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"user_id == %@", [IPKUser currentUser].id];
}

-(NSString *)sortDescriptors{
    return @"updatedAt,remoteID";
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IPKPage * page = ((IPKPage*)[self objectForViewIndexPath:indexPath]);
    IPIPageViewController * pageVC = [[IPIPageViewController alloc] init];
    pageVC.page = page;
    NSLog(@"%@", ((IIViewDeckController*)[IPIAppDelegate sharedAppDelegate].window.rootViewController));
    NSLog(@"%@", ((IIViewDeckController*)[IPIAppDelegate sharedAppDelegate].window.rootViewController));
    UINavigationController * wrapperNavigationController = (UINavigationController*)((IIViewDeckController*)[IPIAppDelegate sharedAppDelegate].window.rootViewController);
    UINavigationController * centerNavigationController = [((IIViewDeckController*)[wrapperNavigationController topViewController]) centerController];
    [centerNavigationController pushViewController:pageVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self containerViewController].delegate bookmarkViewWasDismissed:-2];
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

#pragma mark
#pragma mark UISearchBar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
  [self.searchBar setShowsCancelButton:NO animated:YES];
  [self.searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

  return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
  [self.searchBar setShowsCancelButton:NO animated:YES];
  [self.searchBar resignFirstResponder];
  return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  [self.searchBar setShowsCancelButton:NO animated:YES];
  [self.searchBar resignFirstResponder];
}

@end
