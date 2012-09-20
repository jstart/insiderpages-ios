//
//  IPIProviderViewController
//

#import "IPIPageDisqusViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIProviderTableViewCell.h"
#import "IPIProviderHeaderTableViewCell.h"
#import "IPIProviderViewHeader.h"
#import "IPIAddToPageViewController.h"
#import "IPISocialShareHelper.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIFont+InsiderPagesiOSAdditions.h"
#import "IPIDisqusTableViewCell.h"
#import "IADisquser.h"

@interface IPIPageDisqusViewController () <IPIProviderMapsCarouselDelegate, TTTAttributedLabelDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@end

@implementation IPIPageDisqusViewController

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
//		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tasks" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.comments = [NSMutableArray array];
    }
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, 300, 480) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    UIView * backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    backgroundView.backgroundColor = [UIColor grayColor];
    self.tableView.backgroundView = backgroundView;
    [self.view addSubview:self.tableView];

    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
    headerView.backgroundColor = [UIColor grayColor];
    self.providerMapsCarousel = [[IPIProviderMapsCarouselViewController alloc] init];
    self.providerMapsCarousel.delegate = self;
    [self addChildViewController:self.providerMapsCarousel];
    self.providerMapsCarousel.view.frame = CGRectMake(0, 10, 320, 115);
    [self.providerMapsCarousel.carousel setUserInteractionEnabled:YES];
    [self.view addSubview:self.providerMapsCarousel.view];
    self.tableView.tableHeaderView = headerView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
//	[SSRateLimit executeBlock:^{
//		[self refresh:nil];
//	} name:[NSString stringWithFormat:@"refresh-list-%@", self.provider.remoteID] limit:30.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

-(void)setPage:(IPKPage *)page{
    _page = page;
    [self.providerMapsCarousel setPage:page];
}

-(void)pageChanged{
//    [self fetchComments];
}

-(void)fetchComments{
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:[self.providerMapsCarousel.currentPage integerValue] inSection:1];
    IPKProvider * provider = nil;

    if (self.providerMapsCarousel.fetchedResultsController.fetchedObjects.count > indexPath.row) {
        provider = [self.providerMapsCarousel.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        NSString * pageName = [self.page.name stringByAddingPercentEscapesUsingEncoding:
                               NSUTF8StringEncoding];
    
        NSString * threadIdentifier = [NSString stringWithFormat:@"http://qa.insiderpages.com/providers/c/%@/detail?page_id=%@&page_name=%@", provider.cached_slug, self.page.remoteID, pageName];
        [IADisquser getCommentsFromThreadLink:threadIdentifier
                                      success:^(NSArray *newComments) {
                                          // get the array of comments, reverse it (oldest comment on top) 
                                          self.comments = [[[newComments reverseObjectEnumerator] allObjects] mutableCopy];
                                          
                                          // start activity indicator
                                          [self.tableView setAlpha:1.0];
                                          
                                          // reload the table
                                          [self.tableView reloadData];
                                      } fail:^(NSError *error) {
                                          // start activity indicator
                                          [self.tableView setAlpha:1.0];
                                          
                                          // alert the error
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Occured" 
                                                                                          message:[error localizedDescription] 
                                                                                         delegate:nil 
                                                                                cancelButtonTitle:@"OK" 
                                                                                otherButtonTitles:nil];
                                          [alert show];
                                      }];
        }

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[IPIDisqusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = ((IADisqusComment*)[self.comments objectAtIndex:indexPath.row]).forumName;
    return cell;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIView * view = [self.providerMapsCarousel.carousel currentItemView];
    CGRect frame = view.frame;
    frame.origin.y = -scrollView.contentOffset.y;
    [view setFrame:frame];
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
