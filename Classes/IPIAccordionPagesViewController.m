//
//  IPILeftPagesViewController.h
//

#import "IPIAccordionPagesViewController.h"
#import "IPIPageTableViewCell.h"
#import "IPIPageViewController.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
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
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    return tableView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    //	self.noContentView = [[CDINoListsView alloc] initWithFrame:CGRectZero];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kIPKCurrentUserChangedNotificationName object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [SSRateLimit executeBlock:[self refresh] name:@"refresh-mine-pages" limit:30.0];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[SSRateLimit executeBlock:[self refresh] name:@"refresh-mine-pages" limit:30.0];
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

-(NSString *)sortDescriptors{
    return @"section_header,createdAt,remoteID";
}

-(NSString*)sectionNameKeyPath{
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
        if (self.loading || ![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
            return;
        }
        
        self.loading = YES;
        
        NSString * myUserId = [NSString stringWithFormat:@"%@", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID];

        if ([self.section_header isEqualToString:@"Mine"]) {
            [[IPKHTTPClient sharedClient] getPagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loading = NO;
                    [self.tableView reloadData];
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SSRateLimit resetLimitForName:@"refresh-mine-pages"];
                    self.loading = NO;
                });
            }];
        }
        else if ([self.section_header isEqualToString:@"Following"]){
            [[IPKHTTPClient sharedClient] getFollowingPagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loading = NO;
                    [self.tableView reloadData];
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SSRateLimit resetLimitForName:@"refresh-following-pages"];
                    self.loading = NO;
                });
            }];
        }
        else if ([self.section_header isEqualToString:@"Favorite"]){
            [[IPKHTTPClient sharedClient] getFavoritePagesForUserWithId:myUserId success:^(AFJSONRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loading = NO;
                    [self.tableView reloadData];
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SSRateLimit resetLimitForName:@"refresh-favorite-pages"];
                    self.loading = NO;
                });
            }];
        }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate) {
        IPKPage * page = ((IPKPage*)[self objectForViewIndexPath:indexPath]);
        [self.delegate didChoosePage:page];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

#pragma mark - NSFetchedResultsController

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[super controllerDidChangeContent:controller];

}

@end
