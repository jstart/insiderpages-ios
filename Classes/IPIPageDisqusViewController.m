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
#import "IADisquser.h"

@interface IPIPageDisqusViewController () <IPIProviderMapsCarouselDelegate, TTTAttributedLabelDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@end

@implementation IPIPageDisqusViewController

@synthesize commentField;

#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
//		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tasks" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.commentDictionary = [NSMutableDictionary dictionary];
	self.threadIDDictionary = [NSMutableDictionary dictionary];

	self.providerMapsCarousel = [[IPIProviderMapsCarouselViewController alloc] init];
	self.providerMapsCarousel.delegate = self;

	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 0, 290, [UIScreen mainScreen].bounds.size.height - 20 - 44) style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    [self.tableView setShowsVerticalScrollIndicator:NO];

	self.commentField = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-20-30-44, 320, 30)];
	[self.commentField setDelegate:self];
	self.commentField.placeholder = @"Post comment";
	[self.commentField setBorderStyle:UITextBorderStyleRoundedRect];
	[self.commentField setReturnKeyType:UIReturnKeySend];
	[self.commentField setClearButtonMode:UITextFieldViewModeAlways];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor standardBackgroundColor];

    UIView * backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    backgroundView.backgroundColor = [UIColor standardBackgroundColor];
    self.tableView.backgroundView = backgroundView;
    [self.view addSubview:self.tableView];

    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 110)];
    headerView.backgroundColor = [UIColor standardBackgroundColor];

    [self addChildViewController:self.providerMapsCarousel];
    self.providerMapsCarousel.view.frame = CGRectMake(0, 10, 320, 90); //[UIScreen mainScreen].bounds.size.height);
    [self.providerMapsCarousel.carousel setUserInteractionEnabled:YES];
    [self.view addSubview:self.providerMapsCarousel.view];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 240)];
    self.tableView.layer.cornerRadius = 4;
    [self.tableView setClipsToBounds:YES];
    [self.view addSubview:self.commentField];
    
    self.hideKeyboardButton = [[UIButton alloc] initWithFrame:self.view.frame];
    [self.hideKeyboardButton setBackgroundColor:[UIColor clearColor]];
    [self.hideKeyboardButton addTarget:self.commentField action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchDown];
    [self.hideKeyboardButton setUserInteractionEnabled:NO];
    [self.view addSubview:self.hideKeyboardButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.commentField resignFirstResponder];
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

- (void)setPage:(IPKPage *)page {
    _page = page;
    [self.providerMapsCarousel setPage:page];
}

- (void)setSortUser:(IPKUser *)sortUser {
    _sortUser = sortUser;
    [self.providerMapsCarousel setSortUser:sortUser];
    [self fetchComments];
}

-(void)bookmarkTapped{
    if ([self.commentField isFirstResponder]) {
        [self.hideKeyboardButton setUserInteractionEnabled:NO];
        self.commentField.frame = CGRectMake (self.commentField.frame.origin.x, [UIScreen mainScreen].bounds.size.height-20-30-44, self.commentField.frame.size.width, self.commentField.frame.size.height); //resize
        [self.commentField resignFirstResponder];
    }
}

-(void)bookmarkClosed{
}

- (void)pageChanged {
    [self.commentField resignFirstResponder];
    [self fetchComments];
}

- (void)fetchComments {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.providerMapsCarousel.carousel.currentItemIndex inSection:1];
    IPKProvider * provider = nil;

    if (self.providerMapsCarousel.fetchedResultsController.fetchedObjects.count > indexPath.row) {
	provider = ((IPKTeamMembership*)[self.providerMapsCarousel.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row]).listing;
//        NSString * pageName = [self.page.name stringByAddingPercentEscapesUsingEncoding:
//                               NSUTF8StringEncoding];
	NSString * providerType = [provider.listing_type isEqualToString:@"CgListing"] ? @"c" : @"p";
	NSString * threadIdentifier = [NSString stringWithFormat:@"/providers/%@/%@/detail/page_id=%@/page_name=%@",providerType, provider.cached_slug, self.page.remoteID, self.page.name];
    NSString * url = [NSString stringWithFormat:@"http://qa.insiderpages.com/providers/%@/%@/detail/page_id=%@/page_name=%@",providerType, provider.cached_slug, self.page.remoteID, self.page.name];
	dispatch_async(dispatch_get_main_queue(), ^(){
	                   [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
		       });
        NSLog(@"%@", threadIdentifier);
	[IADisquser getCommentsFromThreadIdentifier:threadIdentifier success:^(NSArray *newComments)
	 {
	     // get the array of comments, reverse it (oldest comment on top)
	     if (newComments) {
	         [self.commentDictionary setObject:[newComments mutableCopy] forKey:threadIdentifier];
	     }
	     // reload the table
	     dispatch_async (dispatch_get_main_queue (), ^(){
	                         [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
			     });

	     [IADisquser getThreadIdWithIdentifier:threadIdentifier success:^(NSNumber* number){
	      [self.threadIDDictionary setObject:number forKey:threadIdentifier];
	  } fail:^(NSError *error) {
	  }];
	 } fail:^(NSError *error) {
	     // start activity indicator
	     [IADisquser getThreadIdWithIdentifier:threadIdentifier success:^(NSNumber* number){
	      [self.threadIDDictionary setObject:number forKey:threadIdentifier];
	  } fail:^(NSError *error) {
	      NSString * title = [NSString stringWithFormat:@"%@ discussing %@", self.page.name, provider.name];
          NSLog(@"new thread title %@ %@", title, threadIdentifier);
	      [IADisquser createThreadWithIdentifier:threadIdentifier Title:title URL:url success:^(NSNumber * number){
	         [self.threadIDDictionary setObject:number forKey:threadIdentifier];
	     } fail:^(NSError* error) {
	     }];
	  }];

	     dispatch_async (dispatch_get_main_queue (), ^(){
	                         [self.tableView reloadData];
			     });
	     // alert the error
	     //                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Occured"
	     //                                                                                          message:[error localizedDescription]
	     //                                                                                         delegate:nil
	     //                                                                                cancelButtonTitle:@"OK"
	     //                                                                                otherButtonTitles:nil];
	     //                                          [alert show];
	 }];
    }
}

- (void)replyToComment:(IADisqusComment *)comment cell:(UITableViewCell *)cell{
    self.commentToReplyTo = comment;
    [self.commentField becomeFirstResponder];
    
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField { //Keyboard becomes visible
    [self.hideKeyboardButton setUserInteractionEnabled:YES];
    self.commentField.frame = CGRectMake (self.commentField.frame.origin.x, self.commentField.frame.origin.y - 217,
                                          self.commentField.frame.size.width, self.commentField.frame.size.height); //resize
}

- (void)textFieldDidEndEditing:(UITextField *)textField { //keyboard will hide
    [self.hideKeyboardButton setUserInteractionEnabled:NO];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.commentField.frame = CGRectMake (self.commentField.frame.origin.x, [UIScreen mainScreen].bounds.size.height-20-30-44,
                                          self.commentField.frame.size.width, self.commentField.frame.size.height); //resize
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
	return NO;
    }
    NSIndexPath * carouselIndexPath = [NSIndexPath indexPathForRow:self.providerMapsCarousel.carousel.currentItemIndex inSection:1];
    IPKProvider *provider = ((IPKTeamMembership*)[self.providerMapsCarousel.fetchedResultsController.fetchedObjects objectAtIndex : carouselIndexPath.row]).listing;
    NSString *providerType = [provider.listing_type isEqualToString:@"CgListing"] ? @"c" : @"p";
    NSString *threadIdentifier = [NSString stringWithFormat:@"/providers/%@/%@/detail/page_id=%@/page_name=%@",providerType, provider.cached_slug, self.page.remoteID, self.page.name];
    NSLog(@"%@", threadIdentifier);
    __block IADisqusComment * comment = [[IADisqusComment alloc] init];
    comment.rawMessage = [textField text];
    IPKUser * currentUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    comment.authorName = currentUser.name;
    comment.authorEmail = currentUser.email;
    comment.threadID = [self.threadIDDictionary objectForKey:threadIdentifier];
    if (self.commentToReplyTo) {
        comment.parent = self.commentToReplyTo;
        self.commentToReplyTo = nil;
    }

    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Submitting comment"];
    [hud show];
    [IADisquser postComment:comment success:^() {
        [textField setText:@""];
        [hud completeAndDismissWithTitle:@"Comment submitted"];

        NSMutableArray * commentArray = [self.commentDictionary objectForKey:threadIdentifier];
        if (comment.parent){
            for (int i = 0; i < commentArray.count; i++) {
                IADisqusComment * parentComment = [commentArray objectAtIndex:i];
                if ([parentComment isEqual:comment.parent]) {
                    [commentArray insertObject:comment atIndex:i+1];
                }
            }
        }else{
            [commentArray addObject:comment];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
     } fail:^(NSError *error) {
         [hud failAndDismissWithTitle:[error description]];;
     }];
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSIndexPath * indexPath;
    if (self.providerMapsCarousel.carousel.currentItemIndex < 0) {
	indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    } else{
	indexPath = [NSIndexPath indexPathForRow:self.providerMapsCarousel.carousel.currentItemIndex inSection:section];
    }
    IPKProvider * provider = nil;
    if (self.providerMapsCarousel.fetchedResultsController.fetchedObjects.count > 0) {
	provider = ((IPKTeamMembership*)[self.providerMapsCarousel.fetchedResultsController.fetchedObjects objectAtIndex : indexPath.row]).listing;
	NSString * providerType = [provider.listing_type isEqualToString:@"CgListing"] ? @"c" : @"p";
	NSString * threadIdentifier = [NSString stringWithFormat:@"/providers/%@/%@/detail/page_id=%@/page_name=%@",providerType, provider.cached_slug, self.page.remoteID, self.page.name];

	return [[[self commentDictionary] objectForKey:threadIdentifier] count];
    } else{
	return 0;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IPIDisqusTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IPIDisqusTableViewCell"];
    if (!cell) {
	cell = [[IPIDisqusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IPIDisqusTableViewCell"];
    }
    NSIndexPath * carouselIndexPath = [NSIndexPath indexPathForRow:self.providerMapsCarousel.carousel.currentItemIndex inSection:1];
    IPKProvider * provider = nil;
    provider = ((IPKTeamMembership*)[self.providerMapsCarousel.fetchedResultsController.fetchedObjects objectAtIndex : carouselIndexPath.row]).listing;
    NSString * providerType = [provider.listing_type isEqualToString:@"CgListing"] ? @"c" : @"p";
    NSString * threadIdentifier = [NSString stringWithFormat:@"/providers/%@/%@/detail/page_id=%@/page_name=%@",providerType, provider.cached_slug, self.page.remoteID, self.page.name];
    IADisqusComment * comment = ((IADisqusComment*)[[[self commentDictionary] objectForKey:threadIdentifier] objectAtIndex : indexPath.row]);
    [cell setComment:comment];
    [cell setDelegate:self];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath * carouselIndexPath = [NSIndexPath indexPathForRow:self.providerMapsCarousel.carousel.currentItemIndex inSection:1];
    IPKProvider * provider = nil;
    provider = ((IPKTeamMembership*)[self.providerMapsCarousel.fetchedResultsController.fetchedObjects objectAtIndex : carouselIndexPath.row]).listing;
    NSString * providerType = [provider.listing_type isEqualToString:@"CgListing"] ? @"c" : @"p";
    NSString * threadIdentifier = [NSString stringWithFormat:@"/providers/%@/%@/detail/page_id=%@/page_name=%@",providerType, provider.cached_slug, self.page.remoteID, self.page.name];
    IADisqusComment * comment = ((IADisqusComment*)[[[self commentDictionary] objectForKey:threadIdentifier] objectAtIndex : indexPath.row]);

    return [IPIDisqusTableViewCell cellHeightForComment:comment];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView * view = [self.providerMapsCarousel.carousel currentItemView];
    if (scrollView.contentOffset.y > 0) {
        CGRect frame = view.frame;
        frame.origin.y = -scrollView.contentOffset.y;
        [view setFrame:frame];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y == -0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        UIView * view = [self.providerMapsCarousel.carousel currentItemView];
        CGRect frame = view.frame;
        frame.origin.y = -scrollView.contentOffset.y;
        [view setFrame:frame];
        [UIView commitAnimations];
    }
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != (__bridge void *)self) {
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	return;
    }

    if ([keyPath isEqualToString:@"title"]) {
	self.title = [change objectForKey:NSKeyValueChangeNewKey];
    } else if (UI_USER_INTERFACE_IDIOM () != UIUserInterfaceIdiomPad && [keyPath isEqualToString:@"archivedAt"]) {
	if ([change objectForKey:NSKeyValueChangeNewKey] != [NSNull null]) {
	    [self.navigationController popToRootViewControllerAnimated:YES];
	}
    }
}

@end
