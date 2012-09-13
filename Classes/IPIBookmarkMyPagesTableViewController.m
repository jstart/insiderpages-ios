//
//  IPBookmarkViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkMyPagesTableViewController.h"
#import "IPIBookmarkContainerViewController.h"
#import "IPIPageTableViewCell.h"
#import "IPIAppDelegate.h"
#import "IIViewDeckController.h"
#import "IPIPageViewController.h"
#import "SVPullToRefresh.h"

@interface IPIBookmarkMyPagesTableViewController ()

@end

@implementation IPIBookmarkMyPagesTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.searchDisplayController.searchBar.barStyle = UIBarStyleDefault;
    self.searchDisplayController.searchBar.contentMode = UIViewContentModeScaleToFill;
//    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"One", @"Two", nil];
    self.searchDisplayController.searchBar.showsScopeBar = YES;
    
    self.tableView.showsInfiniteScrolling = NO;
    self.fetchedResultsController = nil;
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-my-pages" limit:0];
}

-(UITableView *)tableView{
    return self.view;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.fetchedResultsController = nil;
    [[self tableView] reloadData];
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-my-pages" limit:0];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
                self.fetchedResultsController = nil;                
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

#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKPage class];
}

- (NSPredicate *)predicate {
    if (self.searchDisplayController.searchBar.text != nil && ![self.searchDisplayController.searchBar.text isEqualToString:@""]) {
        return [NSPredicate predicateWithFormat:@"user_id == %@ AND name CONTAINS [cd] %@", [IPKUser currentUser].id, self.searchDisplayController.searchBar.text];
    }
	return [NSPredicate predicateWithFormat:@"user_id == %@", [IPKUser currentUser].id];
}

-(NSString *)sortDescriptors{
    return @"updatedAt,remoteID";
}

-(BOOL)ascending{
    return NO;
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

+(Class)fetchedResultsControllerClass{
    return [SSFilterableFetchedResultsController class];
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
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.fetchedResultsController = nil;
    [[self tableView] reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [((SSFilterableFetchedResultsController*)self.fetchedResultsController) addFilterPredicate:^BOOL(id obj) {
                return ([[((IPKPage *)obj) name] rangeOfString:searchText].location != NSNotFound);} forKey:searchText];
    [((SSFilterableFetchedResultsController*)self.fetchedResultsController) setActiveFilterByKey:searchText];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

#pragma mark
#pragma mark UISearchDisplay Delegate
// when we start/end showing the search UI
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
}
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    
}
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
}

// called when the table is created destroyed, shown or hidden. configure as necessary.
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView{
    
}

// called when table is shown/hidden
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    self.fetchedResultsController = nil;
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    
}

// return YES to reload table. called when search string/option changes. convenience methods on top UISearchBar delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    self.fetchedResultsController = nil;
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    self.fetchedResultsController = nil;
    return YES;
}


@end
