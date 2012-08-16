//
//  IPIProviderViewController
//

#import "IPIProviderViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIProviderTableViewCell.h"
//#import "CDIAddTaskView.h"
//#import "CDIAddTaskAnimationView.h"
//#import "CDIAttributedLabel.h"
//#import "CDICreateListViewController.h"
//#import "CDINoTasksView.h"
//#import "CDIRenameTaskViewController.h"
//#import "CDIWebViewController.h"
#import "UIColor+CheddariOSAdditions.h"
#import "UIFont+CheddariOSAdditions.h"

@interface IPIProviderViewController () <TTTAttributedLabelDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@end

@implementation IPIProviderViewController

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
	
	[self setEditing:NO animated:NO];
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    [backgroundView addSubview:self.mapView];
    [self.tableView setBackgroundView:backgroundView];
	self.tableView.hidden = self.provider == nil;
//	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake([CDIAddTaskView height], 0.0f, 0.0f, 0.0f);

//	self.noContentView = [[CDINoTasksView alloc] initWithFrame:CGRectZero];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
//	[SSRateLimit executeBlock:^{
//		[self refresh:nil];
//	} name:[NSString stringWithFormat:@"refresh-list-%@", self.provider.remoteID] limit:30.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - SSManagedViewController

+ (Class)fetchedResultsControllerClass {
	return [SSFilterableFetchedResultsController class];
}


- (Class)entityClass {
	return [IPKActivity class];
}


- (NSPredicate *)predicate {	
//	return [NSPredicate predicateWithFormat:@"(SUBQUERY(activities, $eachProvider, $eachProvider.remoteID == %@).@count !=0)", self.provider.remoteID];
    return nil;
}


#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	IPIProviderTableViewCell *providerCell = (IPIProviderTableViewCell *)cell;
//	providerCell.provider = [self objectForViewIndexPath:indexPath];
    providerCell.provider = self.provider;
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

//- (void)refresh:(id)sender {
//	if (self.provider == nil || self.loading) {
//		return;
//	}
//	
//	self.loading = YES;
//    NSString * pageIDString = [NSString stringWithFormat:@"%@", self.provider.id];
//	[[IPKHTTPClient sharedClient] getProvidersForPageWithId:pageIDString success:^(AFJSONRequestOperation *operation, id responseObject) {
//		dispatch_async(dispatch_get_main_queue(), ^{
//			self.loading = NO;
//		});
//	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-list-%@", self.provider.remoteID]];
//			self.loading = NO;
//		});
//	}];
//}


#pragma mark - Private

- (void)updateTableViewOffsets {
//	CGFloat offset = self.tableView.contentOffset.y;
//	CGFloat top = [CDIAddTaskView height] - fminf(0.0f, offset);
//	CGFloat bottom = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? self.keyboardRect.size.height : 0.0f;
//	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0.0f, bottom, 0.0f);
//	self.pullToRefreshView.defaultContentInset = UIEdgeInsetsMake(0.0f, 0.0f, bottom, 0.0f);
//	self.addTaskView.shadowView.alpha = fmaxf(0.0f, fminf(offset / 24.0f, 1.0f));
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	static NSString *const mapCellIdentifier = @"mapCellIdentifier";
    
	IPIProviderTableViewCell *cell = (IPIProviderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell && indexPath.row != 0) {
		cell = [[IPIProviderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}else if (indexPath.row == 0){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mapCellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell setUserInteractionEnabled:NO];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
	
//	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	return self.addTaskView;
//}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 100;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	CDKTask *task = [self objectForViewIndexPath:indexPath];
//	[task toggleCompleted];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	if (sourceIndexPath.row == destinationIndexPath.row) {
		return;
	}
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
//	if ([self showingCoverView]) {
//		[self.addTaskView.textField resignFirstResponder];
//	}
	
//	[super scrollViewDidScroll:scrollView];
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
}

@end
