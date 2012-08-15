//
//  IPILeftPagesViewController.h
//

#import "IPIAccordionPagesViewController.h"
#import "IPIPageTableViewCell.h"
#import "IPIPageViewController.h"
#import "IPIExpandingPageHeaderTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"
//#import "CDINoListsView.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>

#define CHEDDAR_USE_PASSWORD_FLOW 1

#ifdef CHEDDAR_USE_PASSWORD_FLOW
	#import "CDISignUpViewController.h"
#else
	#import "CDIWebSignInViewController.h"
#endif

@interface IPIAccordionPagesViewController ()

@property (nonatomic, strong) NSString * section_header;

- (void)_currentUserDidChange:(NSNotification *)notification;
@end

@implementation IPIAccordionPagesViewController 

#pragma mark - NSObject

- (void)dealloc {

}

- (id)init {
	if ((self = [super init])) {
	}
	return self;
}

-(id)initWithSectionHeader:(NSString *)section_header{
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.section_header = section_header;
	}
	return self;
}

#pragma mark - UIViewController

-(UITableView*)tableView{
    return [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) style:UITableViewStylePlain];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    //	self.noContentView = [[CDINoListsView alloc] initWithFrame:CGRectZero];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_listUpdated:) name:kIPKListDidUpdateNotificationName object:nil];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kIPKCurrentUserChangedNotificationName object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[SSRateLimit executeBlock:^{
		[self refresh:nil];
	} name:@"refresh-mine-pages" limit:30.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKPage class];
}


- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"name != %@ && section_header == %@", @"",self.section_header];
}

-(NSArray *)sortDescriptors{
    return [NSArray arrayWithObjects:
            [NSSortDescriptor sortDescriptorWithKey:@"section_header" ascending:NO],
            [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO],
            [NSSortDescriptor sortDescriptorWithKey:@"remoteID" ascending:NO],
            nil];
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

- (void)refresh:(id)sender {
	if (self.loading || ![IPKUser currentUser]) {
		return;
	}
	
	self.loading = YES;
    NSString * myUserId = [NSString stringWithFormat:@"%@", [IPKUser currentUser].id];
	[[IPKHTTPClient sharedClient] getPagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.loading = NO;
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[SSRateLimit resetLimitForName:@"refresh-mine-pages"];
			self.loading = NO;
		});
	}];
    
    [[IPKHTTPClient sharedClient] getFavoritePagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.loading = NO;
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[SSRateLimit resetLimitForName:@"refresh-mine-pages"];
			self.loading = NO;
		});
	}];
    
    [[IPKHTTPClient sharedClient] getFollowingPagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.loading = NO;
		});
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[SSRateLimit resetLimitForName:@"refresh-mine-pages"];
			self.loading = NO;
		});
	}];
}

#pragma mark - Private

- (void)_currentUserDidChange:(NSNotification *)notification {
	self.fetchedResultsController = nil;
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
	
	return rows;
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


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        IPKPage * page = ((IPKPage*)[self objectForViewIndexPath:indexPath]);
        IPIPageViewController * pageVC = [[IPIPageViewController alloc] init];
        pageVC.managedObject = page;
        [((UINavigationController*)controller.centerController) pushViewController:pageVC animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
	
}

@end
