//
//  IPIAddPlaceSearchViewController
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/8/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIAddPlaceSearchViewController.h"
#import "IPIProviderTableViewCell.h"
#import "SVPullToRefresh.h"

@implementation IPIAddPlaceSearchViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Add a Place";
    
    UIView * cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cancelButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:cancelButton];
    UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelView];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    self.queryModel = [IPKQueryModel MR_createEntity];
    [self.queryModel setFilterType:@(kIPKQueryModelFilterAll)];
    self.queryModel.queryString = @"";
    self.queryModel.city = @"Los Angeles";
    self.queryModel.state = @"CA";
    self.queryModel.currentPage = @"1";
    self.queryModel.perPageNumber = @"10";
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)customizeSearchBar {
    [super customizeSearchBar];
    UITextField *searchField;
    
    NSUInteger numViews = [self.customSearchDisplayController.searchBar.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.customSearchDisplayController.searchBar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //?
            searchField = [self.customSearchDisplayController.searchBar.subviews  objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.placeholder = @"Search For Places";
    }
}

- (void(^)(void))refresh {
    return ^(void){
        if (self.loading || ![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
            return;
        }
        
        self.loading = NO;
        //get nearby places
//        NSString * userID = [NSString stringWithFormat:@"%@", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID];
//        [[IPKHTTPClient sharedClient] getFollowersForUserWithId:userID success:^(AFJSONRequestOperation *operation, id responseObject) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.loading = NO;
//                self.fetchedResultsController = nil;
//                [self.tableView reloadData];
//            });
//        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SSRateLimit resetLimitForName:@"refresh-followers"];
//                self.loading = NO;
//            });
//        }];
    };
}

-(void)close{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKProvider class];
}

- (NSPredicate *)predicate {
    if (self.customSearchDisplayController.searchBar.text != nil && ![self.customSearchDisplayController.searchBar.text isEqualToString:@""]) {
        return [NSPredicate predicateWithFormat:@"name CONTAINS [cd] %@", self.customSearchDisplayController.searchBar.text];
    }else{
        return [NSPredicate predicateWithValue:YES];
    }
}

- (NSArray *)sortDescriptors{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]];
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

#pragma mark - 
#pragma mark UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IPKProvider * provider = ((IPKProvider*)[self objectForViewIndexPath:indexPath]);
    self.loading = YES;
    NSString * pageID = [NSString stringWithFormat:@"%@", self.page.remoteID];
    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Adding place" loading:YES];
    [hud show];
    [[IPKHTTPClient sharedClient] addProvidersToPageWithId:pageID provider:provider success:^(AFJSONRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud completeAndDismissWithTitle:@"Place added"];
            self.loading = NO;
            [self close];
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.customSearchDisplayController.searchBar resignFirstResponder];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [hud failAndDismissWithTitle:@"Failed to add."];
            self.loading = NO;
        });
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
    
	IPIProviderTableViewCell *cell = (IPIProviderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPIProviderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	cell.provider = [self objectForViewIndexPath:indexPath];
	
	return cell;
}

#pragma mark - 
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.queryModel.queryString = searchText;
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searched for %@", self.queryModel.queryString);
    [self.queryModel setQueryString:searchBar.text];
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
    
}                     // called when keyboard search button pressed

@end
