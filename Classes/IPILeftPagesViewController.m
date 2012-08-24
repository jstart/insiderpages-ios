//
//  IPILeftPagesViewController.h
//

#import "IPILeftPagesViewController.h"
#import "IPIPageTableViewCell.h"
#import "IPIExpandingPageHeaderTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"
//#import "CDINoListsView.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>
#import "SVPullToRefresh.h"

@interface IPILeftPagesViewController ()
- (void)_currentUserDidChange:(NSNotification *)notification;
@end

@implementation IPILeftPagesViewController 

#pragma mark - NSObject

- (void)dealloc {

}
- (BOOL)viewDeckControllerWillOpenLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated{
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-mine-pages" limit:0.0];

    return YES;
}

- (id)init {
	if ((self = [super init])) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openCreatePageView)];
	}
	return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.tableView.showsInfiniteScrolling = NO;
    //	self.noContentView = [[CDINoListsView alloc] initWithFrame:CGRectZero];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kIPKCurrentUserChangedNotificationName object:nil];
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
	return [IPKPage class];
}


- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"name != %@ && section_header != %@", @"",@""];
}

-(NSString *)sortDescriptors{
    return @"section_header";
}

- (NSString *)sectionNameKeyPath {
	return @"section_header";
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
        if (self.loading || ![IPKUser currentUser]) {
            return;
        }
        
        self.loading = YES;
        NSString * myUserId = [NSString stringWithFormat:@"%@", [IPKUser currentUser].id];
        [[IPKHTTPClient sharedClient] getPagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                [self.fetchedResultsController performFetch:nil];
                [self.tableView reloadData];
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
                [self.fetchedResultsController performFetch:nil];
                [self.tableView reloadData];
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
                [self.fetchedResultsController performFetch:nil];
                [self.tableView reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:@"refresh-mine-pages"];
                self.loading = NO;
            });
        }];
    };
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


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	if (sourceIndexPath.row == destinationIndexPath.row) {
		return;
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Archive";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle != UITableViewCellEditingStyleDelete) {
		return;
	}
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];
	
}


#pragma mark - UIExpandableTableView
- (BOOL)tableView:(UIExpandableTableView *)tableView canExpandSection:(NSInteger)section{
    return YES;
}

- (BOOL)tableView:(UIExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section{
    return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(UIExpandableTableView *)tableView expandingCellForSection:(NSInteger)section{
    IPIExpandingPageHeaderTableViewCell *cell = (IPIExpandingPageHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"sectionIdentifier"];
	if (!cell) {
		cell = [[IPIExpandingPageHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionIdentifier"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	[cell.textLabel setText:((id <NSFetchedResultsSectionInfo>)[[self.fetchedResultsController sections] objectAtIndex:section]).name];
	
	return cell;
}

- (void)tableView:(UIExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section{
    
}

@end
