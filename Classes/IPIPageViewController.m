//
//  CDIListViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/31/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "IPIPageViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIProviderTableViewCell.h"
#import "IPIProviderViewController.h"
#import "IPIPageTableViewHeader.h"
#import "IPISocialShareHelper.h"
//#import "CDIAddTaskView.h"
//#import "CDIAddTaskAnimationView.h"
//#import "CDIAttributedLabel.h"
//#import "CDICreateListViewController.h"
#import "CDINoTasksView.h"
//#import "CDIRenameTaskViewController.h"
//#import "CDIWebViewController.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface IPIPageViewController () <IPIPageTableViewHeaderDelegate, TTTAttributedLabelDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
- (void)_renameList:(id)sender;
- (void)_archiveTasks:(id)sender;
- (void)_archiveAllTasks:(id)sender;
- (void)_archiveCompletedTasks:(id)sender;
@end

@implementation IPIPageViewController
@synthesize page = _page;

- (void)setPage:(IPKPage *)page {

	void *context = (__bridge void *)self;
	_page = page;
	self.title = self.page.name;
//	self.tableView.hidden = self.page == nil;
	
	if (page == nil) {
		return;
	}
	
	[page addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:context];
    [page addObserver:self forKeyPath:@"owner" options:NSKeyValueObservingOptionNew context:context];
    [page addObserver:self forKeyPath:@"is_favorite" options:NSKeyValueObservingOptionNew context:context];
    [page addObserver:self forKeyPath:@"is_following" options:NSKeyValueObservingOptionNew context:context];
    
//	self.ignoreChange = YES;
	[self.headerView setPage:page];
	self.fetchedResultsController = nil;
	[self.tableView reloadData];
	self.ignoreChange = NO;
	
	[SSRateLimit executeBlock:[self refresh]
	 name:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID] limit:0.0];
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
	
	self.view.backgroundColor = [UIColor cheddarArchesColor];
//	self.tableView.hidden = self.page == nil;
    [self.tableView setAllowsSelectionDuringEditing:YES];
//	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake([CDIAddTaskView height], 0.0f, 0.0f, 0.0f);
	self.pullToRefreshView.bottomBorderColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    [self.tableView setFrame:CGRectMake(0, 180, 320, [UIScreen mainScreen].bounds.size.height-180)];
//	self.noContentView = [[CDINoTasksView alloc] initWithFrame:CGRectZero];
    self.headerView = [[IPIPageTableViewHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    [self.headerView setDelegate:self];
    [self.view addSubview:self.headerView];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setEditing:YES animated:YES];
    [SSRateLimit executeBlock:[self refresh] name:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID] limit:0.0];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    [self.headerView setPage:self.page];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}


#pragma mark - SSManagedViewController

+ (Class)fetchedResultsControllerClass {
	return [SSFilterableFetchedResultsController class];
}


- (Class)entityClass {
	return [IPKProvider class];
}


- (NSPredicate *)predicate {	
	return [NSPredicate predicateWithFormat:@"(SUBQUERY(pages, $eachPage, $eachPage.remoteID == %@).@count !=0)", self.page.remoteID];
}


#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	IPIProviderTableViewCell *providerCell = (IPIProviderTableViewCell *)cell;
	providerCell.provider = [self objectForViewIndexPath:indexPath];
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
        
        if ([self.page.owner.remoteID isEqualToNumber:@(0)]) {
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
        [[IPKHTTPClient sharedClient] getProvidersForPageWithId:pageIDString success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                self.fetchedResultsController = nil;
                [self.tableView reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.page.remoteID]];
                self.loading = NO;
            });
        }];
    };
}


#pragma mark - Private

- (void)updateTableViewOffsets {
//	CGFloat offset = self.tableView.contentOffset.y;
//	CGFloat top = [CDIAddTaskView height] - fminf(0.0f, offset);
//	CGFloat bottom = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? self.keyboardRect.size.height : 0.0f;
//	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0.0f, bottom, 0.0f);
//	self.pullToRefreshView.defaultContentInset = UIEdgeInsetsMake(0.0f, 0.0f, bottom, 0.0f);
//	self.addTaskView.shadowView.alpha = fmaxf(0.0f, fminf(offset / 24.0f, 1.0f));
}


- (void)_renameList:(id)sender {
//	CDICreateListViewController *viewController = [[CDICreateListViewController alloc] init];
//	viewController.list = self.list;
//	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
//	[self.navigationController presentModalViewController:navigationController animated:YES];
}


- (void)_archiveTasks:(id)sender {
	// TODO: This is super ugly
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Archive Completed", @"Archive All", nil];
		[actionSheet showFromRect:[sender frame] inView:self.view animated:YES];
	} else {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Archive Completed", @"Archive All", nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[actionSheet showInView:self.navigationController.view];
	}
}


- (void)_archiveAllTasks:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Archive All Tasks" message:@"Do you want to archive all of the tasks in this list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Archive", nil];
	alert.tag = 1;
	[alert show];
}


- (void)_archiveCompletedTasks:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Archive Completed Tasks" message:@"Do you want to archive all of the completed tasks in this list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Archive", nil];
	alert.tag = 2;
	[alert show];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	
	IPIProviderTableViewCell *cell = (IPIProviderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPIProviderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    IPKProvider * provider = [self objectForViewIndexPath:indexPath];
    [self.delegate didSelectProvider:provider];
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
	
	self.ignoreChange = YES;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([self showingCoverView]) {
//		[self.addTaskView.textField resignFirstResponder];
	}
	
	[super scrollViewDidScroll:scrollView];
}


#pragma mark - CDIAddTaskViewDelegate

//- (void)addTaskView:(CDIAddTaskView *)addTaskView didReturnWithTitle:(NSString *)title {
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//		dispatch_semaphore_wait(_createTaskSemaphore, DISPATCH_TIME_FOREVER);
//		dispatch_async(dispatch_get_main_queue(), ^{
//			CDIAddTaskAnimationView *animation = [[CDIAddTaskAnimationView alloc] initWithFrame:self.view.bounds];
//			animation.title = title;
//			[self.view addSubview:animation];
//			
//			self.ignoreChange = YES;
//			
//			NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
//			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows inSection:0];
//			
//			CDKTask *task = [[CDKTask alloc] init];
//			task.text = title;
//			task.displayText = title;
//			task.list = self.list;
//			task.position = [NSNumber numberWithInteger:self.list.highestPosition + 1];
//			
//			CGPoint point = CGPointZero;
//			if (numberOfRows > 0) {
//				CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows - 1 inSection:0]];
//				point = rect.origin;
//				point.y += rect.size.height;
//			} else {
//				point.y = [CDIAddTaskView height];
//			}
//			
//			[animation animationToPoint:point height:self.tableView.bounds.size.height insertTask:^{
//				[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//				self.ignoreChange = NO;
//			} completion:^{		
//				[animation removeFromSuperview];
//				dispatch_semaphore_signal(_createTaskSemaphore);
//			}];
//			
//			[task createWithSuccess:nil failure:^(AFJSONRequestOperation *remoteOperation, NSError *error) {
//				dispatch_async(dispatch_get_main_queue(), ^{
//					addTaskView.textField.text = title;
//					SSHUDView *hud = [[SSHUDView alloc] init];
//					[hud failQuicklyWithTitle:@"Failed to create task"];
//				});
//			}];
//		});
//	});
//}
//
//
//- (void)addTaskViewDidBeginEditing:(CDIAddTaskView *)addTaskView {
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//		[self showCoverView];
//	}
//}
//
//
//- (void)addTaskViewDidEndEditing:(CDIAddTaskView *)addTaskView {
//	[self hideCoverView];
//}
//
//
//- (void)addTaskViewShouldCloseTag:(CDIAddTaskView *)addTaskView; {
//	self.currentTag = nil;
//}


#pragma mark - TTTAttributedLabelDelegate

//- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
//	// Open tag
//	if ([url.scheme isEqualToString:@"x-cheddar-tag"]) {
//		CDKTag *tag = [CDKTag existingTagWithName:url.host];
//		self.currentTag = tag;
//		return;
//	}
//	
//	// Open browser
//	if ([url.scheme.lowercaseString isEqualToString:@"http"] || [url.scheme.lowercaseString isEqualToString:@"https"]) {
//		CDIWebViewController *viewController = [[CDIWebViewController alloc] init];
//		[viewController loadURL:url];
//		
//		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//			[self.splitViewController presentModalViewController:navigationController animated:YES];
//		} else {
//			[self.navigationController pushViewController:viewController animated:YES];
//		}
//		return;
//	}
//	
//	// Open other URLs
//	[[UIApplication sharedApplication] openURL:url];
//}


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
//	CDKTask *task = [self objectForViewIndexPath:self.editingIndexPath];
//	task.text = textField.text;
//	task.displayText = textField.text;
//	task.entities = nil;
//	[task save];
//	[task update];
//	
//	[self endCellTextEditing];
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
