//
//  IPIBookmarkNotificationsViewController
//

#import "IPIBookmarkNotificationsViewController.h"
#import "IPINotifcationTableViewCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "IPIPushNotificationRouter.h"
#import "IPINotificationPathRouter.h"
#import "IIViewDeckController.h"
#import "IPIAppDelegate.h"
//#import "CDINoListsView.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>

@implementation IPIBookmarkNotificationsViewController 

#pragma mark - NSObject

- (void)dealloc {

}

- (id)init {
	if ((self = [super init])) {

	}
	return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    UIView * customBackButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    UIButton * customBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBackButton setImageEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 0)];
    [customBackButton setImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    customBackButton.frame = CGRectMake(0, 0, customBackButtonView.frame.size.width, customBackButtonView.frame.size.height);
    [customBackButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [customBackButtonView addSubview:customBackButton];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBackButtonView];
    self.parentViewController.parentViewController.navigationItem.leftBarButtonItem = backBarButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.parentViewController.parentViewController.title = @"Notifications";
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    [[IPKHTTPClient sharedClient] markNotificationsReadWithSuccess:^(AFJSONRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationNumber" object:nil userInfo:nil];
    } failure:^(AFJSONRequestOperation *operation, NSError *error){
    
    }];
	[SSRateLimit executeBlock:[self refresh] name:@"refresh-notifications" limit:30.0];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

-(void)back{
    [((UINavigationController*)self.parentViewController) popViewControllerAnimated:YES];
}

#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKNotification class];
}


- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"user.remoteID == %@", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID];
}

- (NSArray *)sortDescriptors{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"remoteID" ascending:NO]];
}

-(BOOL)ascending{
    return NO;
}

#pragma mark - SSManagedTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//	CDKList *list = [self objectForViewIndexPath:indexPath];
//	[(CDIListTableViewCell *)cell setList:list];
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


#pragma mark - Actions

- (void(^)(void))refresh {
    return ^(void){
        if (self.loading || ![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
            return;
        }
        
        self.loading = YES;
        [[IPKHTTPClient sharedClient] getNotificationsWithCurrentPage:@1 perPage:@10 success:^(AFJSONRequestOperation *operation, id responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationNumber" object:nil userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                self.fetchedResultsController = nil;
                [self.tableView reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:@"refresh-notifications"];
                self.loading = NO;
            });
        }];
    };
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
	
	return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";

	IPINotifcationTableViewCell *cell = (IPINotifcationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPINotifcationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	cell.notification = [self objectForViewIndexPath:indexPath];
	
	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IPKNotification * notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIViewController * viewController = [IPINotificationPathRouter viewControllerForActivityParent:notification.activity_parent];
    UINavigationController * wrapperNavigationController = (UINavigationController*)((IIViewDeckController*)[IPIAppDelegate sharedAppDelegate].window.rootViewController);
    UINavigationController * centerNavigationController = [((IIViewDeckController*)[wrapperNavigationController topViewController]) centerController];
    [centerNavigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self containerViewController].delegate bookmarkViewWasDismissed:-2];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    // necessary, disables uitableviewindex http://stackoverflow.com/questions/3189345/remove-gray-uitableview-index-bar
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPKNotification * n = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [IPINotifcationTableViewCell cellHeightForNotification:n];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
	
}

@end
