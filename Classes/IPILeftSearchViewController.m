//
//  IPILeftPagesViewController.h
//

#import "IPILeftSearchViewController.h"
#import "IPIProviderViewController.h"
#import "IPIPageSearchTableViewCell.h"
#import "IPIProviderSearchTableViewCell.h"
#import "IPISegmentContainerViewController.h"
#import "IPIUserSearchTableViewCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "CDINoListsView.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>
#import "SVPullToRefresh.h"
#import "IPISearchBar.h"

@interface IPILeftSearchViewController ()
- (void)_currentUserDidChange:(NSNotification *)notification;
@end

@implementation IPILeftSearchViewController 

#pragma mark - NSObject

- (void)dealloc {

}

- (BOOL)viewDeckControllerWillOpenLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated{
//    self.tableView.hidden = YES;
    [self.view bringSubviewToFront:self.coverView];
    [self showCoverView];

    return YES;
}

-(UITableView *)tableView{
    return self.searchDisplayController.searchResultsTableView;
}

- (void)customizeSearchBar {
    [self.searchDisplayController.searchBar setBackgroundImage:[UIImage imageNamed:@"bar_background.png"]];
    UITextField *searchField;
    
    NSUInteger numViews = [self.searchDisplayController.searchBar.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.searchDisplayController.searchBar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //?
            searchField = [self.searchDisplayController.searchBar.subviews  objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.textColor = [UIColor whiteColor];
        [searchField setBackground: [UIImage imageNamed:@"field.png"] ];
        [searchField setBorderStyle:UITextBorderStyleNone];
    }
}

- (void)viewDeckControllerDidOpenLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    CGRect frame = [[self searchDisplayController] searchBar].frame;
    frame.size.width = 320 - 44;
    [[[self searchDisplayController] searchBar] setFrame:frame];
    [UIView commitAnimations];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCreatePageView)];
        self.queryModel = [IPKQueryModel MR_createEntity];
        [self.queryModel setFilterType:@(kIPKQueryModelFilterAll)];
        self.queryModel.queryString = @"";
        self.queryModel.city = @"Los Angeles";
        self.queryModel.state = @"CA";
        self.queryModel.currentPage = @"1";
        self.queryModel.perPageNumber = @"10";
	}
	return self;
}

- (UIView *)coverView {
    if (![[self.view subviews] containsObject:self.pullOutTableViewController.tableView]) {
        
        self.pullOutTableViewController = [[IPIPullOutTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.pullOutTableViewController.tableView setFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height-44)];
        [self.pullOutTableViewController.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTapped:)]];
        [self.view addSubview:self.pullOutTableViewController.tableView];
    }

    return self.pullOutTableViewController.tableView;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setContentEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setImage:[UIImage imageNamed:@"cancel_icon"] forState:UIControlStateNormal];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setImage:[UIImage imageNamed:@"cancel_icon"] forState:UIControlStateDisabled];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setImage:[UIImage imageNamed:@"cancel_icon"] forState:UIControlStateSelected];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setImage:[UIImage imageNamed:@"cancel_icon"] forState:UIControlStateHighlighted];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:nil forState:UIControlStateNormal];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:nil forState:UIControlStateSelected];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:nil forState:UIControlStateHighlighted];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"" forState:UIControlStateNormal];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"" forState:UIControlStateSelected];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"" forState:UIControlStateHighlighted];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"" forState:UIControlStateDisabled];
//    [[NSClassFromString(@"UINavigationButton") appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"" forState:UIControlStateApplication];

//    self.noContentView = [[CDINoListsView alloc] initWithFrame:CGRectZero];
    self.tableView.showsPullToRefresh = NO;
    self.tableView.showsInfiniteScrolling = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kIPKCurrentUserChangedNotificationName object:nil];

    self.searchDisplayController.searchBar.scopeButtonTitles = @[@"Pages", @"Places", @"Users"];
    [self.searchDisplayController.searchBar setShowsScopeBar:YES];
    

    [((UITableView*)self.view) setBounces:NO];
    [self customizeSearchBar];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self setWantsFullScreenLayout:NO];
//    [self showCoverView];
    UIView * backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    backgroundView.backgroundColor = [UIColor pulloutBackgroundColor];
    ((UITableView*)self.tableView).backgroundView = backgroundView;
    self.view.backgroundColor = [UIColor pulloutBackgroundColor];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

	[SSRateLimit executeBlock:[self refresh] name:@"refresh-mine-pages" limit:30.0];
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
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}


#pragma mark - SSManagedViewController

- (Class)entityClass {
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case 0: {
            return [IPKPage class];
        }
            break;
        case 1: {
            return [IPKProvider class];
        }
            break;
        case 2: {
            return [IPKUser class];
        }
            break;
    }
    return nil;
}


- (NSPredicate *)predicate {
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case 0: {
            return [NSPredicate predicateWithFormat:@"name contains[cd] %@", self.queryModel.queryString];
        }
            break;
        case 1: {
            return [NSPredicate predicateWithFormat:@"(business_name contains[cd] %@) OR (first_name contains[cd] %@) OR (last_name contains[cd] %@)", self.queryModel.queryString, self.queryModel.queryString, self.queryModel.queryString];
        }
            break;
        case 2: {
            return [NSPredicate predicateWithFormat:@"name contains[cd] %@", self.queryModel.queryString];
        }
            break;
    }
    return nil;
}

-(NSString *)sortDescriptors{
    return nil;
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

+ (Class)fetchedResultsControllerClass {
	return [SSFilterableFetchedResultsController class];
}

#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case 0: {
            ((IPIPageSearchTableViewCell*)cell).page = (IPKPage*)[self objectForViewIndexPath:indexPath];
        }
            break;
        case 1: {
            ((IPIProviderSearchTableViewCell*)cell).provider = (IPKProvider*)[self objectForViewIndexPath:indexPath];
        }
            break;
        case 2: {
            ((IPIUserSearchTableViewCell*)cell).user = (IPKUser*)[self objectForViewIndexPath:indexPath];
        }
            break;
    }
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

#pragma mark - Private

- (void)_currentUserDidChange:(NSNotification *)notification {
	self.fetchedResultsController = nil;
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
        return rows;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const pageIdentifier = @"pageIdentifier";
    static NSString *const providerIdentifier = @"providerIdentifier";
    static NSString *const userIdentifier = @"userIdentifier";
    UITableViewCell * cell = nil;
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:pageIdentifier];
            if (cell == nil) {
                cell = [[IPIPageSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pageIdentifier];
            }
        }
            break;
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:providerIdentifier];
            if (cell == nil) {
                cell = [[IPIProviderSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:providerIdentifier];
            }
        }
            break;
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
            if (cell == nil) {
                cell = [[IPIUserSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier];
            }
        }
            break;
    }
	[self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchDisplayController.searchBar resignFirstResponder];
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case 0: {
            [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
                IPKPage * page = ((IPKPage*)[self objectForViewIndexPath:indexPath]);
                IPISegmentContainerViewController * pageVC = [[IPISegmentContainerViewController alloc] init];
                pageVC.page = page;
                [((UINavigationController*)controller.centerController) pushViewController:pageVC animated:NO];
            }];
        }
            break;
        case 1: {
            [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
                IPKProvider * provider = ((IPKProvider*)[self objectForViewIndexPath:indexPath]);
                IPIProviderViewController * providerVC = [[IPIProviderViewController alloc] init];
                providerVC.provider = provider;
                [((UINavigationController*)controller.centerController) pushViewController:providerVC animated:NO];
            }];
                   }
            break;
        case 2: {
            SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"User profile TBD."];
            [hud show];
            [hud failAndDismissWithTitle:@"User profile TBD."];
        }
            break;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    // necessary, disables uitableviewindex http://stackoverflow.com/questions/3189345/remove-gray-uitableview-index-bar
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    return YES;
}// return NO to not become first responder

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self hideCoverView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView commitAnimations];
    [self.viewDeckController setLeftLedge:0];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    CGRect frame = [self view].frame;
    frame.size.width = 320;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}                     // called when text starts editing

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [self.viewDeckController setLeftLedge:44];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    CGRect frame = [self view].frame;
    frame.size.width = 320 - 44;
    [[self view] setFrame:frame];
    [UIView commitAnimations];
    return YES;
}                        // return NO to not resign first responder

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}                       // called when text ends editing

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    for (UIView * view in searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            [((UIButton*)view) setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        }
    }
    
    self.queryModel.queryString = searchText;
    NSString * queryKey = [NSString stringWithFormat:@"%@-%d", self.queryModel.queryString, self.searchDisplayController.searchBar.selectedScopeButtonIndex];
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case 0: {

            [((SSFilterableFetchedResultsController*)self.fetchedResultsController) addFilterPredicate:^BOOL(id obj) {
                return ([[((IPKPage *)obj) name] rangeOfString:self.queryModel.queryString].location != NSNotFound);} forKey:queryKey];
        }
            break;
        case 1: {
            [((SSFilterableFetchedResultsController*)self.fetchedResultsController) addFilterPredicate:^BOOL(id obj) {
                return ([[((IPKProvider *)obj) full_name] rangeOfString:self.queryModel.queryString].location != NSNotFound);} forKey:queryKey];
        }
            break;
        case 2: {
            [((SSFilterableFetchedResultsController*)self.fetchedResultsController) addFilterPredicate:^BOOL(id obj) {
                return ([[((IPKUser *)obj) name] rangeOfString:self.queryModel.queryString].location != NSNotFound);} forKey:queryKey];
        }
            break;
    }

//    [((SSFilterableFetchedResultsController*)self.fetchedResultsController) setActiveFilterByKey:queryKey];
    [self.searchDisplayController.searchResultsTableView reloadData];
//    [self.queryModel setQueryString:searchText];
//    switch (searchBar.selectedScopeButtonIndex) {
//        case 0: {
//            [[IPKHTTPClient sharedClient] pageSearchWithQueryModel:self.queryModel success:^(AFJSONRequestOperation *operation, id responseObject) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.fetchedResultsController = nil;
//                    self.loading = NO;
//                    [[self tableView] reloadData];
//                });
//            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SSRateLimit resetLimitForName:@"refresh-activity"];
//                    self.loading = NO;
//                });
//            }];
//        }
//            break;
//        case 1: {
//            [[IPKHTTPClient sharedClient] providerSearchWithQueryModel:self.queryModel success:^(AFJSONRequestOperation *operation, id responseObject) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.fetchedResultsController = nil;
//                    self.loading = NO;
//                    
//                    [[self tableView] reloadData];
//                });
//            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SSRateLimit resetLimitForName:@"refresh-activity"];
//                    self.loading = NO;
//                });
//            }];
//        }
//
//            break;
//        case 2: {
//            [[IPKHTTPClient sharedClient] insiderSearchWithQueryModel:self.queryModel success:^(AFJSONRequestOperation *operation, id responseObject) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.fetchedResultsController = nil;
//                    self.loading = NO;
//                    
//                    [[self tableView] reloadData];
//                });
//            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SSRateLimit resetLimitForName:@"refresh-activity"];
//                    self.loading = NO;
//                });
//            }];
//        }
//            break;
//            
//        default:
//            break;
//    }
   
}   // called when text changes (including clear)

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
} // called before text changes

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searched for %@", self.queryModel.queryString);
    [self.queryModel setQueryString:searchBar.text];
    switch (searchBar.selectedScopeButtonIndex) {
        case 0: {
            SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Searching for pages..."];
            [hud show];
            [[IPKHTTPClient sharedClient] pageSearchWithQueryModel:self.queryModel success:^(AFJSONRequestOperation *operation, id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud completeAndDismissWithTitle:@"Finished searching."];
                    self.fetchedResultsController = nil;
                    self.loading = NO;
                    [self.searchDisplayController.searchResultsTableView reloadData];
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud failAndDismissWithTitle:@"Error searching pages"];
                    [SSRateLimit resetLimitForName:@"refresh-activity"];
                    self.loading = NO;
                });
            }];
        }
            break;
        case 1: {
            SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Searching for providers..."];
            [hud show];
            [[IPKHTTPClient sharedClient] providerSearchWithQueryModel:self.queryModel success:^(AFJSONRequestOperation *operation, id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud completeAndDismissWithTitle:@"Finished searching."];
                    self.fetchedResultsController = nil;
                    self.loading = NO;
                    
                    [self.searchDisplayController.searchResultsTableView reloadData];
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud failAndDismissWithTitle:@"Error searching providers"];
                    [SSRateLimit resetLimitForName:@"refresh-activity"];
                    self.loading = NO;
                });
            }];
        }
            
            break;
        case 2: {
            SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Searching for users..."];
            [hud show];
            [[IPKHTTPClient sharedClient] insiderSearchWithQueryModel:self.queryModel success:^(AFJSONRequestOperation *operation, id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud completeAndDismissWithTitle:@"Finished searching."];
                    self.fetchedResultsController = nil;
                    self.loading = NO;
                    
                    [self.searchDisplayController.searchResultsTableView reloadData];
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud failAndDismissWithTitle:@"Error searching users"];
                    [SSRateLimit resetLimitForName:@"refresh-activity"];
                    self.loading = NO;
                });
            }];
        }
            break;
            
        default:
            break;
    }

}                     // called when keyboard search button pressed

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
}                   // called when bookmark button pressed

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self showCoverView];
}                    // called when cancel button pressed

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    
} // called when search results button pressed

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    self.fetchedResultsController = nil;
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case 0: {

        }
            break;
        case 1: {
            SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Place search is broken."];
            [hud show];
            [hud failAndDismissWithTitle:@"Place search is iffy."];
//            [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:0];
        }
            break;
        case 2: {

        }
            break;
    }

}

// when we start/end showing the search UI
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{

}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    Class navButtonClass = NSClassFromString(@"UINavigationButton");
    id navButton;
    NSUInteger numViews = [self.searchDisplayController.searchBar.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.searchDisplayController.searchBar.subviews objectAtIndex:i] isKindOfClass:navButtonClass]) { //?
            navButton = [self.searchDisplayController.searchBar.subviews  objectAtIndex:i];
        }
    }
    if(!(navButton == nil)) {
        [navButton setImage:[UIImage imageNamed:@"back.png"]];
    }
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
