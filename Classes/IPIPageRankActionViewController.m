//
//  IPIPageRankActionViewController
//  InsiderPages for iOS
//

#import "IPIPageRankActionViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIProviderRankTableViewCell.h"
#import "IPIProviderViewController.h"
#import "IPIPageTableViewHeader.h"
#import "IPISocialShareHelper.h"
#import "IIViewDeckController.h"
#import "SVPullToRefresh.h"
#import "IPIAddPlaceSearchViewController.h"
//#import "CDIAddTaskView.h"
//#import "CDIAttributedLabel.h"
//#import "CDICreateListViewController.h"
#import "CDINoTasksView.h"
//#import "CDIRenameTaskViewController.h"
//#import "CDIWebViewController.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIColor-Expanded.h"
#import "UIFont+InsiderPagesiOSAdditions.h"

@interface IPIPageRankActionViewController () <IPIPageTableViewHeaderDelegate, TTTAttributedLabelDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@end

@implementation IPIPageRankActionViewController
@synthesize page = _page;

- (void)setPage:(IPKPage *)page {

	void *context = (__bridge void *)self;
	_page = page;
//	self.tableView.hidden = self.page == nil;
	
	if (_page == nil) {
		return;
	}
	
	[_page addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:context];
    [_page.owner addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:context];
    [_page addObserver:self forKeyPath:@"is_favorite" options:NSKeyValueObservingOptionNew context:context];
    [_page addObserver:self forKeyPath:@"is_following" options:NSKeyValueObservingOptionNew context:context];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ignoreChange = NO;
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
    });
}

//-(UITableView*)tableView{
//    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//    [tableView setContentInset:UIEdgeInsetsMake(44.0f, 0.0f, 0.0f, 0.0f)];
//    
//    [tableView setContentOffset:CGPointMake(0.0f, 180.0f)];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    return tableView;
//}

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
//		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tasks" style:UIBarButtonItemStyleBordered target:nil action:nil];
	}
	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Your Ranking";
    
    UIImageView * titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]];
    CGRect frame = titleView.frame;
    frame.origin.x = 11;
    frame.origin.y = 40;
    titleView.frame = frame;
    [self.view addSubview:titleView];
    
    self.addPlaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addPlaceButton setFrame:CGRectMake(117, 107, 85, 31)];
    [self.addPlaceButton setImage:[UIImage imageNamed:@"add_place_button.png"] forState:UIControlStateNormal];
    [self.addPlaceButton addTarget:self action:@selector(addPlace) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addPlaceButton];
    
    UIView * cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cancelButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:cancelButton];
    UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelView];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    UIView * checkmarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton * checkmarkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [checkmarkButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [checkmarkButton setImage:[UIImage imageNamed:@"checkmark_inactive"] forState:UIControlStateNormal];
    [checkmarkButton setImage:[UIImage imageNamed:@"checkmark_active"] forState:UIControlStateSelected];
    [checkmarkButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [checkmarkButton setEnabled:NO];
    [checkmarkView addSubview:checkmarkButton];
    UIBarButtonItem * checkmarkButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkmarkView];
    self.navigationItem.rightBarButtonItem = checkmarkButtonItem;
    
//	self.view.backgroundColor = [UIColor cheddarArchesColor];
//	self.tableView.hidden = self.page == nil;
    [self.tableView setAllowsSelectionDuringEditing:YES];
//	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake([CDIAddTaskView height], 0.0f, 0.0f, 0.0f);
	self.pullToRefreshView.bottomBorderColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    self.tableView.showsInfiniteScrolling = NO;
    [self.tableView setFrame:CGRectMake(15, 165, 290, [UIScreen mainScreen].bounds.size.height-185)];
    [self.tableView.layer setCornerRadius:3.0];
    [self.tableView setClipsToBounds:YES];
    self.tableView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"cccccc"]];
    self.tableView.layer.borderWidth = 1;
//	self.noContentView = [[CDINoTasksView alloc] initWithFrame:CGRectZero];
    
//    self.headerView = [[IPIPageTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
//    [self.headerView setDelegate:self];
//    [self.view addSubview:self.headerView];
    
    [self.view setBackgroundColor:[UIColor standardBackgroundColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.ignoreChange = NO;
    [self setEditing:YES animated:YES];
    [self.viewDeckController setPanningMode:IIViewDeckNavigationBarPanning];
    [self.tableView triggerPullToRefresh];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:7 forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
//    [self.headerView setPage:self.page];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

-(void)addPlace{
    IPIAddPlaceSearchViewController * addPlaceSearchViewController  = [[IPIAddPlaceSearchViewController alloc] init];
    [addPlaceSearchViewController setPage:self.page];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:addPlaceSearchViewController];
    [self presentModalViewController:navigationController animated:YES];
    self.ignoreChange = YES;
}

-(void)close{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)done{
    NSMutableArray * teamMemberships = [[IPKTeamMembership MR_findAllSortedBy:@"position" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"owner_id == %@ && team_id == %@", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID, self.page.remoteID] inContext:[NSManagedObjectContext MR_contextForCurrentThread]] mutableArrayValueForKey:@"position"];
    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Submitting page order." loading:YES];
    [hud show];
    [[IPKHTTPClient sharedClient] reorderProvidersForPageWithId:[self.page.remoteID stringValue] newOrder:teamMemberships success:^(AFJSONRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"errors"]) {
            NSLog(@"%@", responseObject);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ignoreChange = NO;
            self.fetchedResultsController = nil;
            [self.tableView reloadData];
            self.loading = NO;
            [hud completeAndDismissWithTitle:@"Page reordered."];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Page is private"];
            [hud show];
            [hud failAndDismissWithTitle:@"Reorder failed."];
            [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID]];
            self.loading = NO;
        });
    }];

}

-(void)tabSelected{
    //
}

#pragma mark - SSManagedViewController

+ (Class)fetchedResultsControllerClass {
	return [NSFetchedResultsController class];
}


- (Class)entityClass {
	return [IPKTeamMembership class];
}


- (NSPredicate *)predicate {
    return [NSPredicate predicateWithFormat:@"team_id == %@ && owner_id == %@", self.page.remoteID, [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID];
}

- (NSArray *)sortDescriptors{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[super controllerWillChangeContent:controller];
}

#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	IPIProviderRankTableViewCell *providerCell = (IPIProviderRankTableViewCell *)cell;
	providerCell.provider = ((IPKTeamMembership*)[self objectForViewIndexPath:indexPath]).listing;
    providerCell.rankNumberLabel.text = [NSString stringWithFormat:@"%@",((IPKTeamMembership*)[self objectForViewIndexPath:indexPath]).position];
}


#pragma mark - CDIManagedTableViewController

- (void)editRow:(UITapGestureRecognizer *)editingTapGestureRecognizer {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)editingTapGestureRecognizer.view];
	if (!indexPath) {
		return;
	}
//
//	CDIRenameTaskViewController *viewController = [[CDIRenameTaskViewController alloc] init];
//	viewController.task = [self objectForViewIndexPath:indexPath];
//	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
//	[self.navigationController presentModalViewController:navigationController animated:YES];
}


//- (void)coverViewTapped:(id)sender {
//	[self.addTaskView.textField resignFirstResponder];
//}


#pragma mark - Actions

- (void (^)(void))refresh {
    return ^(void){
        if (self.page == nil || self.loading) {
            return;
        }
        
        if (self.page.owner.name == nil) {
            self.loading = YES;

            [self.page.owner updateWithSuccess:^(void){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loading = NO;
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID]];
                    self.loading = NO;
                });
            }];
        }
        
        self.loading = YES;

        NSString * pageIDString = [NSString stringWithFormat:@"%@", self.page.remoteID];
        IPKUser * sortUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        self.ignoreChange = YES;
        [[IPKHTTPClient sharedClient] getProvidersForPageWithId:pageIDString sortUser:sortUser success:^(AFJSONRequestOperation *operation, id responseObject) {
            if ([responseObject objectForKey:@"errors"]) {
                NSLog(@"%@", responseObject);
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                self.ignoreChange = NO;
                self.fetchedResultsController = nil;
                [self.tableView reloadData];
                self.loading = NO;
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Page is private"];
                [hud show];
                [hud failAndDismissWithTitle:@"Page is private"];
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID]];
                self.loading = NO;
            });
        }];
    };
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	
	IPIProviderRankTableViewCell *cell = (IPIProviderRankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPIProviderRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.editing = NO;
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	return self.addTaskView;
//}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IPKProvider * provider = ((IPKTeamMembership*)[self objectForViewIndexPath:indexPath]).listing;
    [self.delegate didSelectProvider:provider];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        IPKProvider * provider = ((IPKTeamMembership*)[self.fetchedResultsController objectAtIndexPath:indexPath]).listing;
        [[IPKHTTPClient sharedClient] removeProvidersFromPageWithId:[self.page.remoteID stringValue] provider:provider success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ignoreChange = NO;
                self.fetchedResultsController = nil;
                [self.tableView reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Failed to delete."];
            [hud show];
            [hud failAndDismissWithTitle:@"Failed to delete."];
        }];
	}
}
// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	if (sourceIndexPath.row == destinationIndexPath.row) {
		return;
	}
    self.ignoreChange = YES;

    IPKTeamMembership * sourceTeamMembership = [self.fetchedResultsController objectAtIndexPath:sourceIndexPath];
    sourceTeamMembership.position = @(destinationIndexPath.row + 1);
    NSMutableArray * teamMemberships = [[IPKTeamMembership MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"owner_id == %@ && team_id == %@", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID, self.page.remoteID] inContext:[NSManagedObjectContext MR_contextForCurrentThread]] mutableCopy];
    [teamMemberships removeObject:sourceTeamMembership];
    for (int i = 0; i < teamMemberships.count; i++) {
        IPKTeamMembership * tm = [teamMemberships objectAtIndex:i];
        if (tm.position.intValue > sourceIndexPath.row + 1 && tm.position.intValue < destinationIndexPath.row + 1) {
            ((IPKTeamMembership*)[tm MR_inThreadContext]).position = @(tm.position.intValue - 1);
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_save];
        }else if (tm.position.intValue - 1 == destinationIndexPath.row){
            if (sourceIndexPath.row > destinationIndexPath.row) {
                tm.position = @(tm.position.intValue + 1);
            }else{
                tm.position = @(tm.position.intValue - 1);
            }
        } else if (tm.position.intValue < sourceIndexPath.row + 1 && tm.position.intValue > destinationIndexPath.row + 1){
            ((IPKTeamMembership*)[tm MR_inThreadContext]).position = @(tm.position.intValue + 1);
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_save];
        }
    }
    self.ignoreChange = NO;
    self.fetchedResultsController = nil;
    [[self tableView] reloadData];
    
    if (![([[(UIButton*)self.navigationItem.rightBarButtonItem.customView subviews] objectAtIndex:0]) isEnabled]){
        [([[(UIButton*)self.navigationItem.rightBarButtonItem.customView subviews] objectAtIndex:0]) setEnabled:YES];
        [([[(UIButton*)self.navigationItem.rightBarButtonItem.customView subviews] objectAtIndex:0]) setSelected:YES];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    return proposedDestinationIndexPath;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    prevContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
//	if (buttonIndex == 0) {
//		[self setEditing:NO animated:YES];
//		[self.list archiveCompletedTasks];
//	} else if (buttonIndex == 1) {
//		[self setEditing:NO animated:YES];
//		[self.list archiveAllTasks];
//	}
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//	if (buttonIndex == 0) {
//		return;
//	}
//
//	[self setEditing:NO animated:YES];
//	
//	if (alertView.tag == 1) {
//		[self.list archiveAllTasks];
//		[self setEditing:NO animated:YES];
//	} else if (alertView.tag == 2) {
//		[self.list archiveCompletedTasks];
//	}
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	return NO;
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}

	if ([keyPath isEqualToString:@"title"]) {
		self.title = [change objectForKey:NSKeyValueChangeNewKey];
	} else if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && [keyPath isEqualToString:@"archivedAt"]) {
		if ([change objectForKey:NSKeyValueChangeNewKey] != [NSNull null]) {
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
	}
    if ([keyPath isEqualToString:@"owner"] || [keyPath isEqualToString:@"is_favorite"] || [keyPath isEqualToString:@"is_following"]) {
    }
    if ([keyPath isEqualToString:@"name"]) {
        [self setPage:_page];
    }
}

#pragma mark - IPIPageTableViewHeaderDelegate

-(void)followButtonPressed:(IPKPage*)page{
    NSString * pageId = [NSString stringWithFormat:@"%@", page.remoteID];
    if ([page.is_following boolValue]) {
        [[IPKHTTPClient sharedClient] unfollowPageWithId:pageId success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [self setManagedObject:[IPKPage objectWithRemoteID:page.remoteID]];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID]];
                self.loading = NO;
            });
        }];
    } else {
        [[IPKHTTPClient sharedClient] followPageWithId:pageId success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [self setManagedObject:[IPKPage objectWithRemoteID:page.remoteID]];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID]];
                self.loading = NO;
            });
        }];
    }
}

-(void)favoriteButtonPressed:(IPKPage*)page{
    NSString * pageId = [NSString stringWithFormat:@"%@", page.remoteID];
    if ([page.is_favorite boolValue]) {
        [[IPKHTTPClient sharedClient] unfavoritePageWithId:pageId success:^(AFJSONRequestOperation *operation, id responseObject) {
            NSLog(@"%@", page);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [self setManagedObject:[IPKPage objectWithRemoteID:page.remoteID]];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID]];
                self.loading = NO;
            });
        }];
    }else{
        [[IPKHTTPClient sharedClient] favoritePageWithId:pageId success:^(AFJSONRequestOperation *operation, id responseObject) {
            NSLog(@"%@", page);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [self setManagedObject:[IPKPage objectWithRemoteID:page.remoteID]];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID]];
                self.loading = NO;
            });
        }];
    }
}

-(void)shareButtonPressed:(IPKPage*)page{
    [IPISocialShareHelper tweetPage:page fromViewController:self];
}

@end
