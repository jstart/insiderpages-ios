//
//  IPIBookmarkBaseManagedViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkBaseManagedViewController.h"
#import "IPIAppDelegate.h"
#import "UIViewController+KNSemiModal.h"

@interface IPIBookmarkBaseManagedViewController ()

@end

@implementation IPIBookmarkBaseManagedViewController

@synthesize bookmarkNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
    UIView * customBackButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    UIButton * customBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBackButton setImageEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 0)];
    [customBackButton setImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal];
    customBackButton.frame = CGRectMake(0, 0, customBackButtonView.frame.size.width, customBackButtonView.frame.size.height);
    [customBackButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [customBackButtonView addSubview:customBackButton];
    
    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBackButtonView];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotificationNumber)
                                                 name:@"updateNotificationNumber"
                                               object:nil];
    if ( [IPIAppDelegate sharedAppDelegate].bookmarkNavigationController == nil) {
        IPIBookmarkContainerViewController *bookmarkContainerViewController = [[IPIBookmarkContainerViewController alloc] initWithNibName:@"IPIBookmarkContainerViewController" bundle:[NSBundle mainBundle]];
        [IPIAppDelegate sharedAppDelegate].bookmarkNavigationController = [[UINavigationController alloc] initWithRootViewController:bookmarkContainerViewController];
    }
    IPIBookmarkContainerViewController * bookmarkContainerViewController = [IPIAppDelegate sharedAppDelegate].bookmarkNavigationController.topViewController;
    bookmarkContainerViewController.delegate = self;
    
    UIImage * image = [UIImage imageNamed:@"bookmark.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setAdjustsImageWhenHighlighted:YES];
    
    button.frame= CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    
    [button addTarget:self action:@selector(presentBookmarkViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width + 7, image.size.height) ];
    
    [v addSubview:button];
    
    self.notificationCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 11, 20, 20)];
    [self.notificationCountLabel setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:12]];
    [self.notificationCountLabel setTextAlignment:NSTextAlignmentCenter];
    [self.notificationCountLabel setContentMode:UIViewContentModeCenter];
    [self.notificationCountLabel setBackgroundColor:[UIColor clearColor]];
    [self.notificationCountLabel setTextColor:[UIColor whiteColor]];
    [v addSubview:self.notificationCountLabel];
    
    UIBarButtonItem * bookmarkButton = [[UIBarButtonItem alloc] initWithCustomView:v];
    CGRect frame = [[bookmarkButton customView] frame];
    frame.origin.y = frame.origin.y - 17;
    [bookmarkButton customView].frame = frame;
    self.navigationItem.rightBarButtonItem = bookmarkButton;
    IPKUser * currentUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSArray * unreadNotificationsArray = [[currentUser.notifications filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"read == NO"]] allObjects];
    [self.notificationCountLabel setText:[NSString stringWithFormat:@"%d", unreadNotificationsArray.count]];
    
    if ([[self.navigationItem.rightBarButtonItem customView] isHidden]) {
        [self showBookmark];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateNotificationNumber{
    IPKUser * currentUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSArray * unreadNotificationsArray = [[currentUser.notifications filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"read == NO"]] allObjects];
    [self.notificationCountLabel setText:[NSString stringWithFormat:@"%d", unreadNotificationsArray.count]];
}

-(void) bookmarkViewWasDismissed:(int)homePageIndex{
    [self.navigationController dismissSemiModalView];
    [self showBookmark];
}

- (void)presentBookmarkViewController;
{
	// Go to the welcome screen and have them log in or create an account.
    if ([IPIAppDelegate sharedAppDelegate].bookmarkNavigationController == nil) {
        IPIBookmarkContainerViewController * bookmarkContainerViewController = [IPIAppDelegate sharedAppDelegate].bookmarkNavigationController.topViewController;
        bookmarkContainerViewController.delegate = self;
    }
    if ([[self.navigationItem.rightBarButtonItem customView] isHidden]) {
        
    }else{
        [self.navigationController presentSemiViewController:[IPIAppDelegate sharedAppDelegate].bookmarkNavigationController];
        [self hideBookmark];
    }
}

-(void)showBookmark{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    [animation setDuration:0.2f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationItem.rightBarButtonItem.customView layer] addAnimation:animation forKey:@"pushOut"];
    [[self.navigationItem.rightBarButtonItem customView] setHidden:NO];
}

-(void)hideBookmark{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
    [animation setDuration:0.2f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.navigationItem.rightBarButtonItem.customView layer] addAnimation:animation forKey:@"pushOut"];
    [[self.navigationItem.rightBarButtonItem customView] setHidden:YES];
}

@end
