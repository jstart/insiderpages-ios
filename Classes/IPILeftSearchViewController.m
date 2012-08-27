//
//  IPILeftPagesViewController.h
//

#import "IPILeftSearchViewController.h"
#import "IPIProviderViewController.h"
#import "IPIPageTableViewCell.h"
#import "IPIProviderTableViewCell.h"
#import "IPIUserTableViewCell.h"
#import "IPIExpandingPageHeaderTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"
//#import "CDINoListsView.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>
#import "SVPullToRefresh.h"

@interface IPILeftSearchViewController ()
- (void)_currentUserDidChange:(NSNotification *)notification;
@end

@implementation IPILeftSearchViewController 

#pragma mark - NSObject

- (void)dealloc {

}

- (BOOL)viewDeckControllerWillOpenLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated{
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-mine-pages" limit:0.0];

    return YES;
}

- (void)viewDeckControllerDidOpenLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    CGRect frame = [self view].frame;
    frame.size.width = 320 - 44;
    [[self view] setFrame:frame];
    [UIView commitAnimations];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCreatePageView)];
        self.queryModel = [IPKQueryModel MR_createEntity];
        [self.queryModel setFilterType:@(kIPKQueryModelFilterAll)];
        self.queryModel.queryString = @"";
        self.queryModel.city = [[IPKUser currentUser].city_id stringValue];
        self.queryModel.currentPage = @"1";
        self.queryModel.perPageNumber = @"20";
	}
	return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.tableView.showsInfiniteScrolling = NO;
    //	self.noContentView = [[CDINoListsView alloc] initWithFrame:CGRectZero];
    self.tableView.showsPullToRefresh = NO;
    self.tableView.showsInfiniteScrolling = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kIPKCurrentUserChangedNotificationName object:nil];

    self.searchDisplayController.searchBar.showsCancelButton = YES;
    self.searchDisplayController.searchBar.scopeButtonTitles = @[@"Pages", @"Places", @"Users"];
    [self.searchDisplayController.searchBar setShowsScopeBar:YES];

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
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
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
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
            return [NSPredicate predicateWithFormat:@"business_name contains[cd] %@", self.queryModel.queryString];
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
            ((IPIPageTableViewCell*)cell).page = (IPKPage*)[self objectForViewIndexPath:indexPath];
        }
            break;
        case 1: {
            ((IPIProviderTableViewCell*)cell).provider = (IPKProvider*)[self objectForViewIndexPath:indexPath];
        }
            break;
        case 2: {
            ((IPIUserTableViewCell*)cell).user = (IPKUser*)[self objectForViewIndexPath:indexPath];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
	return rows;
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
                cell = [[IPIPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pageIdentifier];
            }
        }
            break;
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:providerIdentifier];
            if (cell == nil) {
                cell = [[IPIProviderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:providerIdentifier];
            }
        }
            break;
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
            if (cell == nil) {
                cell = [[IPIUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier];
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
                IPIPageViewController * pageVC = [[IPIPageViewController alloc] init];
                pageVC.managedObject = page;
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
    [UIView setAnimationDuration:.3];
    CGRect frame = [self view].frame;
    frame.size.width = 320 - 44;
    [[self view] setFrame:frame];
    [UIView commitAnimations];
    return YES;
}                        // return NO to not resign first responder

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}                       // called when text ends editing

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.queryModel.queryString = searchText;
    NSString * queryKey = [NSString stringWithFormat:@"%@-%d", self.queryModel.queryString, self.searchDisplayController.searchBar.selectedScopeButtonIndex];
    switch (self.searchDisplayController.searchBar.selectedScopeButtonIndex) {
        case 0: {

            [((SSFilterableFetchedResultsController*)self.fetchedResultsController) addFilterPredicate:^BOOL(id obj) {
                NSLog(@"%@ %@", [((IPKPage *)obj) name], self.queryModel.queryString);
                return ([[((IPKPage *)obj) name] rangeOfString:self.queryModel.queryString].location != NSNotFound);} forKey:queryKey];
        }
            break;
        case 1: {
            [((SSFilterableFetchedResultsController*)self.fetchedResultsController) addFilterPredicate:^BOOL(id obj) {
                NSLog(@"%@ %@", [((IPKProvider *)obj) full_name], self.queryModel.queryString);
                return ([[((IPKProvider *)obj) full_name] rangeOfString:self.queryModel.queryString].location != NSNotFound);} forKey:queryKey];
        }
            break;
        case 2: {
            [((SSFilterableFetchedResultsController*)self.fetchedResultsController) addFilterPredicate:^BOOL(id obj) {
                NSLog(@"%@ %@", [((IPKUser *)obj) name], self.queryModel.queryString);
                return ([[((IPKUser *)obj) name] rangeOfString:self.queryModel.queryString].location != NSNotFound);} forKey:queryKey];
        }
            break;
    }

    
    [((SSFilterableFetchedResultsController*)self.fetchedResultsController) setActiveFilterByKey:queryKey];
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
