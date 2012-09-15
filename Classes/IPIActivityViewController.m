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
#import "IPISegmentContainerViewController.h"
#import "IPIActivityTableViewCell.h"
#import "IPIActivityPageTableViewFooter.h"
#import "CDINoListsView.h"
#import "UIColor+CheddariOSAdditions.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>
#import "IIViewDeckController.h"

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
    YIFullScreenScroll* _fullScreenDelegate;
}

#pragma mark - NSObject

- (void)dealloc {

}

#pragma mark - UIViewController

- (void)viewDidLoad {
    self.loadingView = nil;
	[super viewDidLoad];
//	UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-title.png"]];
//	title.frame = CGRectMake(0.0f, 0.0f, 116.0f, 21.0f);	
//	self.navigationItem.titleView = title;
    self.title = @"InsiderPages";
	[self setEditing:NO animated:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.viewDeckController action:@selector(toggleLeftView)];
    
    _adding = NO;
    
    self.tabBar = [[IPITabBar alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 114, 320, 50)];
    [self.tabBar setDelegate:self];
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:1]];
    [[self view] addSubview:self.tabBar];
//	self.noContentView = [[CDINoListsView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundView.backgroundColor = [UIColor grayColor];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kIPKCurrentUserChangedNotificationName object:nil];
    
	_fullScreenDelegate = [[YIFullScreenScroll alloc] initWithViewController:self];
    _fullScreenDelegate.shouldShowUIBarsOnScrollUp = YES;
    self.filterType = IPKActivityFilterTypeFollowers;
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-activity" limit:0];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self _checkUser];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_fullScreenDelegate layoutTabBarController];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKActivity class];
}

- (NSPredicate *)predicate {
    switch (self.filterType) {
        case IPKActivityFilterTypeYou:
            return [NSPredicate predicateWithFormat:@"page.name != %@ && page.name != nil && user.remoteID == %@", @"", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID];
            break;
        case IPKActivityFilterTypeFollowers:
            return [NSPredicate predicateWithFormat:@"page.name != %@ && page.name != nil", @""];
            break;
        case IPKActivityFilterTypePopular:
            return [NSPredicate predicateWithFormat:@"page.name != %@ && page.name != nil && user.remoteID != %@", @"", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID];
            break;
            
        default:
            break;
    }
}

-(NSString *)sortDescriptors{
    return @"page.name,createdAt";
}

- (NSString *)sectionNameKeyPath {
	return @"page.name";
}

//+ (Class)fetchedResultsControllerClass {
//	return [SSFilterableFetchedResultsController class];
//}

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

#pragma mark IPIActivityTableViewHeaderDelegate
-(void)favoriteButtonPressed:(IPKPage*)page{
    NSString * pageID = [NSString stringWithFormat:@"%@", page.remoteID];

    if ([page.is_favorite boolValue]) {
        self.loading = YES;

        [[IPKHTTPClient sharedClient] unfavoritePageWithId:pageID success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [[self tableView] reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
            });
        }];
    }
    else{
        self.loading = YES;
        
        [[IPKHTTPClient sharedClient] favoritePageWithId:pageID success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [[self tableView] reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
            });
        }];
    }
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void(^)(void))refresh {

    return ^(void){
        if (self.loading || ![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
            self.loading = NO;
            [SSRateLimit resetLimitForName:@"refresh-activity"];
            return;
        }
                
        BOOL following = NO;
        
        switch (self.filterType) {
            case IPKActivityFilterTypeYou:
                following = NO;
                break;
            case IPKActivityFilterTypeFollowers:
                following = YES;
                break;
            case IPKActivityFilterTypePopular:
                following = YES;
                break;
                
            default:
                break;
        }
        self.loading = YES;
        self.currentPage = @(1);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [IPKActivity deleteAllLocal];
            self.ignoreChange = YES;
            [[IPKHTTPClient sharedClient] getActivititesOfType:IPKTrackableTypeAll includeFollowing:following currentPage:@1 perPage:self.perPage success:^(AFJSONRequestOperation *operation, id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.fetchedResultsController = nil;
                    self.loading = NO;
                    self.ignoreChange = NO;
                    NSLog(@"retrieved %d activity items", ((NSArray*)responseObject[@"activities"]).count);
                    [[self tableView] reloadData];
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"failed to retrieve activity items, %@", [error debugDescription]);
                    if ([[operation.error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"] isEqualToString:@"{\"message\":\"you are not logged in\"}"]) {
                        [[IPIAppDelegate sharedAppDelegate] registerOrLogin];
                    }
                    [SSRateLimit resetLimitForName:@"refresh-activity"];
                    [SSRateLimit executeBlock:[self refresh] name:@"refresh-activity" limit:0];
                    self.loading = NO;
                });
            }];
        });
    };
}

- (void(^)(void))nextPage {
    return ^(void){
        if (self.loading || ![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
            self.loading = NO;
            return;
        }
        
        self.loading = YES;
        self.currentPage = @([self.currentPage intValue]+1);
        BOOL following = NO;
        
        switch (self.filterType) {
            case IPKActivityFilterTypeYou:
                following = NO;
                break;
            case IPKActivityFilterTypeFollowers:
                following = YES;
                break;
            case IPKActivityFilterTypePopular:
                following = YES;
                break;
                
            default:
                break;
        }
        self.ignoreChange = YES;

        [[IPKHTTPClient sharedClient] getActivititesOfType:IPKTrackableTypeAll includeFollowing:following currentPage:self.currentPage perPage:self.perPage success:^(AFJSONRequestOperation *operation, id responseObject) {
            self.fetchedResultsController = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                self.ignoreChange = NO;
                [[self tableView] reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:@"refresh-activity"];
                self.loading = NO;
            });
        }];
    };
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
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-activity" limit:0];
	[self.tableView reloadData];
}

- (void)_checkUser {
    NSLog(@"current user %@ boolean user has logged in %d", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].name, [IPKUser userHasLoggedIn]);
    if ([IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]])
        return;
    if ([IPKUser userHasLoggedIn] && ![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
        NSLog(@"current user %@ boolean user has logged in %d", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]], [IPKUser userHasLoggedIn]);
        [[IPIAppDelegate sharedAppDelegate].session close];
        UIViewController *viewController = [[CDISignUpViewController alloc] init];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
		navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.navigationController presentModalViewController:navigationController animated:NO];
		return;
    }
    NSLog(@"current user %@ boolean user has logged in %d", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]], [IPKUser userHasLoggedIn]);
    [[IPIAppDelegate sharedAppDelegate].session close];
    UIViewController *viewController = [[CDISignUpViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentModalViewController:navigationController animated:NO];
    return;
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
    if (activity.page.remoteID == @0) {
        if (self.loading || ![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
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
            IPISegmentContainerViewController * pageVC = [[IPISegmentContainerViewController alloc] init];
            pageVC.page = activity.page;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
        case IPKTrackableTypeReview:{
            //Display Review with approriate action
            IPISegmentContainerViewController * pageVC = [[IPISegmentContainerViewController alloc] init];
            pageVC.page = activity.page;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
        case IPKTrackableTypeUser:{
            //UPP
            IPISegmentContainerViewController * pageVC = [[IPISegmentContainerViewController alloc] init];
            pageVC.page = activity.page;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
        case IPKTrackableTypeCgListing:{
            //UPP
            IPISegmentContainerViewController * pageVC = [[IPISegmentContainerViewController alloc] init];
            pageVC.page = activity.page;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
        case IPKTrackableTypeTeam:{
            //UPP
            IPISegmentContainerViewController * pageVC = [[IPISegmentContainerViewController alloc] init];
            pageVC.page = activity.page;
            [self.navigationController pushViewController:pageVC animated:YES];
        }
            break;
        case IPKTrackableTypeAll:{
            //Generic Activity
            IPISegmentContainerViewController * pageVC = [[IPISegmentContainerViewController alloc] init];
            pageVC.page = activity.page;
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
    NSIndexPath * sectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    IPKPage * page = ((IPKActivity *)[self objectForViewIndexPath:sectionIndexPath]).page;
    IPIActivityPageTableViewHeader * headerView = [[IPIActivityPageTableViewHeader alloc] initWithFrame:CGRectMake(10, 0, 300, 92.5)];
    [headerView setDelegate:self];
    [headerView setPage:page];

    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSIndexPath * sectionIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    IPKPage * page = ((IPKActivity *)[self objectForViewIndexPath:sectionIndexPath]).page;
    IPIActivityPageTableViewFooter * footerView = [[IPIActivityPageTableViewFooter alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    [footerView setPage:page];
    
    return footerView;
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 0:
            self.filterType = IPKActivityFilterTypeYou;
            [SSRateLimit executeBlock:[self refresh] name:@"refresh-activity" limit:0];
            self.fetchedResultsController = nil;
            [self.tableView reloadData];
            break;
        case 1:
            self.filterType = IPKActivityFilterTypeFollowers;
            [SSRateLimit executeBlock:[self refresh] name:@"refresh-activity" limit:0];
            self.fetchedResultsController = nil;
            [self.tableView reloadData];
            break;
        case 2:
            self.filterType = IPKActivityFilterTypePopular;
            [SSRateLimit executeBlock:[self refresh] name:@"refresh-activity" limit:0];
            self.fetchedResultsController = nil;
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_fullScreenDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    LOG_INT(self.tableView.tracking);
    //    LOG_INT(self.tableView.dragging);
    //    LOG_INT(self.tableView.decelerating);
    
    [_fullScreenDelegate scrollViewDidScroll:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return [_fullScreenDelegate scrollViewShouldScrollToTop:scrollView];;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [_fullScreenDelegate scrollViewDidScrollToTop:scrollView];
}

#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
	
}

#pragma mark - Private

- (void)updateTableViewOffsets {
	CGFloat offset = self.tableView.contentOffset.y;
	CGFloat top = fminf(0.0f, offset);
	CGFloat bottom = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? self.keyboardRect.size.height : 0.0f;
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0.0f, bottom, 0.0f);
	self.pullToRefreshView.defaultContentInset = UIEdgeInsetsMake(0.0f, 0.0f, bottom, 0.0f);
}

@end
