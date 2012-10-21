//
//  IPICollaboratorRankingsViewController
//

#import "IPICollaboratorRankingsViewController.h"
#import "IPIInviteCollaboratorViewController.h"
#import "IPIUserTableViewCell.h"
#import "SVPullToRefresh.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
//#import "CDINoListsView.h"
#import <SSToolkit/UIScrollView+SSToolkitAdditions.h>

@implementation IPICollaboratorRankingsViewController 

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
    self.title = @"Insiders";
    
    UIView * cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cancelButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [cancelView addSubview:cancelButton];
    UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelView];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[self.tableView.pullToRefreshView triggerRefresh];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

-(void)setPage:(IPKPage *)page{
    _page = page;
    if ([page.owner isEqual:[IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]]) {
        UIView * addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIButton * addButton = [[UIButton alloc] initWithFrame:CGRectMake(11, 11, 22, 22)];
        [addButton setImage:[UIImage imageNamed:@"add_page_button"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(new) forControlEvents:UIControlEventTouchUpInside];
        [addView addSubview:addButton];
        UIBarButtonItem * addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addView];
        self.navigationItem.rightBarButtonItem = addButtonItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)new{
    IPIInviteCollaboratorViewController * inviteCollaboratorViewController = [[IPIInviteCollaboratorViewController alloc] init];
    inviteCollaboratorViewController.page = self.page;
    [self.navigationController pushViewController:inviteCollaboratorViewController animated:YES];
}

-(void)close{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKTeamFollowing class];
}


- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"privilege == %@ && team_id == %@", @(1), self.page.remoteID];
}

-(NSString *)sortDescriptors{
    return @"user.name";
}
//
//- (NSString *)sectionNameKeyPath {
//	return @"section_header";
//}

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
        NSString * pageID = [NSString stringWithFormat:@"%@", self.page.remoteID];
        [[IPKHTTPClient sharedClient] getCollaboratorsForPageWithId:pageID success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                self.fetchedResultsController = nil;
                [self.tableView reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:@"refresh-collaborators"];
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

	IPIUserTableViewCell *cell = (IPIUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPIUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	cell.user = ((IPKTeamFollowing*)[self objectForViewIndexPath:indexPath]).user;
	
	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IPKUser * sortUser = ((IPKTeamFollowing*)[self objectForViewIndexPath:indexPath]).user;
    [self.delegate didSelectUser:sortUser];
    [self close];
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
