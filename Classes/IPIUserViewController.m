//
//  IPIUserViewController
//  InsiderPages for iOS
//
//

#import "IPIUserViewController.h"
#import "IPIPageRankActionViewController.h"
#import "IPIPushNotificationRouter.h"
#import "TTTAttributedLabel.h"
#import "IPIPageTableViewCell.h"
#import "IPIProviderViewController.h"
#import "IPIPageTableViewHeader.h"
#import "IPISocialShareHelper.h"
#import "SVPullToRefresh.h"
#import "CDINoTasksView.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIColor-Expanded.h"
#import "UIFont+InsiderPagesiOSAdditions.h"

@interface IPIUserViewController () <IPIUserTableViewHeaderDelegate, IPIUserBarDelegate, TTTAttributedLabelDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@end

@implementation IPIUserViewController
@synthesize user = _user;

static CGFloat prevContentOffset = 0;

- (void)setUser:(IPKUser *)user {

	void *context = (__bridge void *)self;
	_user = user;
	self.title = self.user.name;
	
	if (_user == nil) {
		return;
	}
	
	[_user addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:context];
    [_user addObserver:self forKeyPath:@"is_favorite" options:NSKeyValueObservingOptionNew context:context];
    [_user addObserver:self forKeyPath:@"is_following" options:NSKeyValueObservingOptionNew context:context];
    if (_user.name == nil) {
        [_user updateWithSuccess:^(){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.headerView setUser:_user];
                [self.userBar setUser:_user];
                [self.headerView setNeedsDisplay];
                self.ignoreChange = NO;
                [self.tableView reloadData];

            });
        } failure:^(AFJSONRequestOperation * op, NSError * err){
            
        }];
    }
    
    
	[self.headerView setUser:_user];
    [self.headerView setNeedsDisplay];
    [self.userBar setUser:_user];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.ignoreChange = NO;
        [self.tableView reloadData];
    });
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-user" limit:0.0];
}

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
        self.headerView = [[IPIUserTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        [self.headerView setDelegate:self];
        
        self.userBar = [[IPIUserBar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50 - 44 - 20, 320, 50)];
        [self.userBar setDelegate:self];
	}
	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.tableView.showsInfiniteScrolling = NO;
	
//	self.view.backgroundColor = [UIColor cheddarArchesColor];
//	self.tableView.hidden = self.page == nil;
    [self.tableView setAllowsSelectionDuringEditing:YES];
//	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake([CDIAddTaskView height], 0.0f, 0.0f, 0.0f);
	self.pullToRefreshView.bottomBorderColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
     [self.tableView setFrame:CGRectMake(15, 165, 290, [UIScreen mainScreen].bounds.size.height-185)];
    [self.tableView.layer setCornerRadius:3.0];
    [self.tableView setClipsToBounds:YES];
    self.tableView.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"cccccc"]];
    self.tableView.layer.borderWidth = 1;
//	self.noContentView = [[CDINoTasksView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.headerView];

    [self.view addSubview:self.userBar];
    
    [self.view setBackgroundColor:[UIColor standardBackgroundColor]];
}

//these aren't being called in the segment container
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:4 forBarMetrics:UIBarMetricsDefault];
//    [self setEditing:YES animated:YES];
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-user" limit:0.0];
    [self.tableView.pullToRefreshView triggerRefresh];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    NSString * userID = [self.user.remoteID stringValue];
    [[IPKHTTPClient sharedClient] getFollowersForUserWithId:userID success:^(AFJSONRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"errors"]) {
            NSLog(@"%@", responseObject);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userBar setUser:self.user];
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * errorDescription = [[[error localizedRecoverySuggestion] stringByReplacingOccurrencesOfString:@"{\"message\":\"" withString:@""] stringByReplacingOccurrencesOfString:@"\"}" withString:@""];
            if (errorDescription) {
                SSHUDView * hud = [[SSHUDView alloc] initWithTitle:errorDescription];
                [hud show];
                [hud failAndDismissWithTitle:errorDescription];
            }else{
                SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Can't Access User"];
                [hud show];
                [hud failAndDismissWithTitle:@"Can't Access User"];
            }
            
            [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-user-%@", self.user.remoteID]];
            self.loading = NO;
        });
    }];
    [[IPKHTTPClient sharedClient] getFollowingForUserWithId:userID success:^(AFJSONRequestOperation *operation, id responseObject) {
        if ([responseObject objectForKey:@"errors"]) {
            NSLog(@"%@", responseObject);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userBar setUser:self.user];
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * errorDescription = [[[error localizedRecoverySuggestion] stringByReplacingOccurrencesOfString:@"{\"message\":\"" withString:@""] stringByReplacingOccurrencesOfString:@"\"}" withString:@""];
            if (errorDescription) {
                SSHUDView * hud = [[SSHUDView alloc] initWithTitle:errorDescription];
                [hud show];
                [hud failAndDismissWithTitle:errorDescription];
            }else{
                SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Can't Access User"];
                [hud show];
                [hud failAndDismissWithTitle:@"Can't Access User"];
            }
            
            [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-user-%@", self.user.remoteID]];
            self.loading = NO;
        });
    }];

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

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SSManagedViewController

+ (Class)fetchedResultsControllerClass {
	return [NSFetchedResultsController class];
}


- (Class)entityClass {
	return [IPKPage class];
}


- (NSPredicate *)predicate {
    if (self.user != nil) {
        return [NSPredicate predicateWithFormat:@"owner.remoteID == %@ || (0 != SUBQUERY(following_users, $follower, $follower.remoteID == %@).@count)", self.user.remoteID, self.user.remoteID];
    }else{
        return [NSPredicate predicateWithValue:NO];
    }
}

- (NSArray *)sortDescriptors{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:NO]];
}

//#pragma mark - IPICollaboratorRankingsDelegate
//
//-(void)didSelectUser:(IPKUser*)sortUser{
//    [self setSortUser:sortUser];
//}


#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	IPIPageTableViewCell *pageCell = (IPIPageTableViewCell *)cell;
    pageCell.user = self.user;
	pageCell.page = ((IPKPage*)[self objectForViewIndexPath:indexPath]);
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
        if (self.user == nil || self.loading) {
            return;
        }
        
        if (self.user.name == nil) {
            self.loading = YES;

            [self.user updateWithSuccess:^(void){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loading = NO;
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-user-%@", self.user.remoteID]];
                    self.loading = NO;
                });
            }];
        }
        
        self.loading = YES;

        NSString * userIDString = [NSString stringWithFormat:@"%@", self.user.remoteID];
        self.ignoreChange = YES;
        [[IPKHTTPClient sharedClient] getPagesForUserWithId:userIDString success:^(AFJSONRequestOperation *operation, id responseObject) {
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
                NSString * errorDescription = [[[error localizedRecoverySuggestion] stringByReplacingOccurrencesOfString:@"{\"message\":\"" withString:@""] stringByReplacingOccurrencesOfString:@"\"}" withString:@""];
                if (errorDescription) {
                    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:errorDescription];
                    [hud show];
                    [hud failAndDismissWithTitle:errorDescription];
                }else{
                    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Can't Access User"];
                    [hud show];
                    [hud failAndDismissWithTitle:@"Can't Access User"];
                }

                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-user-%@", self.user.remoteID]];
                self.loading = NO;
            });
        }];
        
        [[IPKHTTPClient sharedClient] getFollowingPagesForUserWithId:userIDString withCurrentPage:@(1) perPage:@(20) success:^(AFJSONRequestOperation *operation, id responseObject) {
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
                NSString * errorDescription = [[[error localizedRecoverySuggestion] stringByReplacingOccurrencesOfString:@"{\"message\":\"" withString:@""] stringByReplacingOccurrencesOfString:@"\"}" withString:@""];
                if (errorDescription) {
                    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:errorDescription];
                    [hud show];
                    [hud failAndDismissWithTitle:errorDescription];
                }else{
                    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Can't Access User"];
                    [hud show];
                    [hud failAndDismissWithTitle:@"Can't Access User"];
                }
                
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-user-%@", self.user.remoteID]];
                self.loading = NO;
            });
        }];
    };
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[super controllerWillChangeContent:controller];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	
	IPIPageTableViewCell *cell = (IPIPageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPIPageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    IPKPage * page = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIViewController * vc = [IPIPushNotificationRouter viewControllerForTeamID:page.remoteID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle != UITableViewCellEditingStyleDelete) {
		return;
	}
}
// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
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
	
	self.ignoreChange = NO;
//	NSMutableArray *tasks = [self.fetchedResultsController.fetchedObjects mutableCopy];
//	CDKTask *task = [self objectForViewIndexPath:sourceIndexPath];
//	[tasks removeObject:task];
//	[tasks insertObject:task atIndex:destinationIndexPath.row];
//	
//	NSInteger i = 0;
//	for (task in tasks) {
//		task.position = [NSNumber numberWithInteger:i++];
//	}
//	
//	[self.managedObjectContext save:nil];
//	self.ignoreChange = NO;
//	
//	[CDKTask sortWithObjects:tasks];
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	return [CDIAddTaskView height];
//}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	CDKTask *task = [self objectForViewIndexPath:indexPath];
//	CGFloat offset = self.editing ? 29.0f : 0.0f;
//	return [CDITaskTableViewCell cellHeightForTask:task width:tableView.frame.size.width - offset];
//	return [CDITaskTableViewCell cellHeightForTask:task width:tableView.frame.size.width];
//}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    prevContentOffset = scrollView.contentOffset.y;
//    [_fullScreenDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (prevContentOffset < scrollView.contentOffset.y) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect userBarFrame = self.userBar.frame;
        userBarFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.userBar.frame = userBarFrame;
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect userBarFrame = self.userBar.frame;
        userBarFrame.origin.y = [UIScreen mainScreen].bounds.size.height - userBarFrame.size.height - 44 - 20;
        self.userBar.frame = userBarFrame;
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    LOG_INT(self.tableView.tracking);
    //    LOG_INT(self.tableView.dragging);
    //    LOG_INT(self.tableView.decelerating);
    
//    [_fullScreenDelegate scrollViewDidScroll:scrollView];
    

}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
//    [_fullScreenDelegate scrollViewDidScrollToTop:scrollView];
}

#pragma mark - IPIUserBarDelegate

-(void)didSelectFollowers{
    
}

-(void)didSelectFollowing{
    
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
    
    if ([keyPath isEqualToString:@"owner"] || [keyPath isEqualToString:@"is_favorite"] || [keyPath isEqualToString:@"is_following"]) {
    }
    if ([keyPath isEqualToString:@"name"]) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.headerView setUser:_user];
        });
    }
}

#pragma mark - IPIUserTableViewHeaderDelegate

-(void)followButtonPressed:(IPKUser*)user{
    NSString * userId = [NSString stringWithFormat:@"%@", user.remoteID];
    IPKUser * currentUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSSet * filteredSet = [_user.followers filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"remoteID == %@", currentUser.remoteID]];
    if (filteredSet.count > 0) {
        [[IPKHTTPClient sharedClient] unfollowUserWithId:userId success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [self setUser:user];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-user-%@", self.user.remoteID]];
                self.loading = NO;
            });
        }];
    } else {
        [[IPKHTTPClient sharedClient] followUserWithId:userId success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [self setUser:user];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-user-%@", self.user.remoteID]];
                self.loading = NO;
            });
        }];
    }
}

@end
