//
//  IPISearchTableViewController
//

#import "IPISearchTableViewController.h"
#import "IPIAppDelegate.h"
#import "SVPullToRefresh.h"

@interface IPISearchTableViewController ()

@end

@implementation IPISearchTableViewController

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
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [searchBar setDelegate:self];
    self.customSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [self.customSearchDisplayController setSearchResultsDataSource:self];
    [self.customSearchDisplayController setSearchResultsDelegate:self];
    self.customSearchDisplayController.searchBar.barStyle = UIBarStyleDefault;
    self.customSearchDisplayController.searchBar.contentMode = UIViewContentModeScaleToFill;
    self.customSearchDisplayController.searchBar.showsScopeBar = YES;
    [self.customSearchDisplayController setDelegate:self];
    [self customizeSearchBar];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.customSearchDisplayController.searchBar.frame.size.height-1, 320, 1)];
    footerView.backgroundColor = [UIColor lightGrayColor];
    footerView.alpha = 0.3;
    [self.customSearchDisplayController.searchBar addSubview:footerView];
    [self.tableView setTableHeaderView:self.customSearchDisplayController.searchBar];
    
    self.tableView.showsInfiniteScrolling = NO;
    self.fetchedResultsController = nil;
}

- (void)customizeSearchBar {
    [self.customSearchDisplayController.searchBar setBackgroundColor:[UIColor whiteColor]];
    [self.customSearchDisplayController.searchBar setBackgroundImage:nil];
    UITextField *searchField;
    
    NSUInteger numViews = [self.customSearchDisplayController.searchBar.subviews count];
    for(int i = 0; i < numViews; i++) {
        UIView * subview = [self.customSearchDisplayController.searchBar.subviews objectAtIndex:i];
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")] || [subview isKindOfClass:NSClassFromString(@"UITextFieldBorderView")] ) {
            //[searchSubview removeFromSuperview];
            [[self.customSearchDisplayController.searchBar.subviews objectAtIndex:i] setAlpha:0.0];
            //[searchSubview setBackgroundColor:[UIColor clearColor]];
            //break;
        }
        
        if([[self.customSearchDisplayController.searchBar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //?
            searchField = [self.customSearchDisplayController.searchBar.subviews  objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.placeholder = @"Search Your Pages";
        [searchField setBackgroundColor:[UIColor whiteColor]];
        [searchField setBorderStyle:UITextBorderStyleNone];
        [searchField setBackground:nil];
        [searchField setFont:[UIFont fontWithName:@"Myriad Web Pro" size:14]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView.pullToRefreshView triggerRefresh];
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
        if (self.loading || ![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
            return;
        }
//        
//        self.loading = YES;
//        self.ignoreChange = YES;
//        NSString * myUserId = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"IPKUserID"]];
//        [[IPKHTTPClient sharedClient] getPagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.loading = NO;
//                self.ignoreChange = NO;
//                self.fetchedResultsController = nil;                
//                [self.tableView reloadData];
//            });
//        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SSRateLimit resetLimitForName:@"refresh-mine-pages"];
//                self.loading = NO;
//            });
//        }];
    };
}

+(Class)fetchedResultsControllerClass{
    return [SSFilterableFetchedResultsController class];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
