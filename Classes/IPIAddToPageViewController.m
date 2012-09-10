//
//  IPIAddToPageViewController
//

#import "IPIAddToPageViewController.h"
#import "IPIPageTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"
//#import "CDINoListsView.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>

@implementation IPIAddToPageViewController 

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
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem * closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [closeButton setTitle:@"Done"];
    self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[SSRateLimit executeBlock:[self refresh] name:@"refresh-add-to-pages" limit:30.0];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

-(void)close{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
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
    SSHUDView * hudView = [[SSHUDView alloc] initWithTitle:@"Adding Provider" loading:YES];
    [hudView show];
    IPKPage * page = [self objectForViewIndexPath:indexPath];
    NSString * pageIDString = [NSString stringWithFormat:@"%@", page.id];
    NSString * providerIDString = [NSString stringWithFormat:@"%@", self.provider.id];
    [[IPKHTTPClient sharedClient] addProvidersToPageWithId:pageIDString providerId:providerIDString success:^(AFJSONRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loading = NO;
            [hudView completeAndDismissWithTitle:@"Provider Added"];
            [self.presentingViewController dismissModalViewControllerAnimated:YES];
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudView failAndDismissWithTitle:@"Could not add provider"];
            [SSRateLimit resetLimitForName:@"refresh-mine-pages"];
            self.loading = NO;
        });
    }];
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

@end
