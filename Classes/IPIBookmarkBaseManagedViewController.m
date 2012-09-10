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
//    IPBookmarkViewController *bookmarkViewController = [[IPBookmarkViewController alloc] initWithNibName:@"IPBookmarkViewController" bundle:[NSBundle mainBundle]];
    IPIBookmarkContainerViewController *bookmarkContainerViewController = [[IPIBookmarkContainerViewController alloc] initWithNibName:@"IPIBookmarkContainerViewController" bundle:[NSBundle mainBundle]];
    self.bookmarkNavigationController = [[UINavigationController alloc] initWithRootViewController:bookmarkContainerViewController];
    
    bookmarkContainerViewController.delegate = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back-button.png"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage * image = [UIImage imageNamed:@"bookmark.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setAdjustsImageWhenHighlighted:YES];
    
    button.frame= CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    
    [button addTarget:self action:@selector(presentBookmarkViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height) ];
    
    [v addSubview:button];
    
    UIBarButtonItem * bookmarkButton = [[UIBarButtonItem alloc] initWithCustomView:v];
    [bookmarkButton setImageInsets:UIEdgeInsetsMake(-100, 0, 0, 0)];
    CGRect frame = [[bookmarkButton customView] frame];
    frame.origin.y = frame.origin.y - 10;
    [bookmarkButton customView].frame = frame;
    self.navigationItem.rightBarButtonItem = bookmarkButton;
    
    if ([[self.navigationItem.rightBarButtonItem customView] isHidden]) {
        [self showBookmark];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) bookmarkViewWasDismissed:(int)homePageIndex{
    [self.navigationController dismissSemiModalView];
    [self showBookmark];
}

- (void)presentBookmarkViewController;
{
	// Go to the welcome screen and have them log in or create an account.
    if ([IPIAppDelegate sharedAppDelegate].bookmarkNavigationController == nil) {
        IPIBookmarkContainerViewController * bookmarkContainerViewController = [[IPIAppDelegate sharedAppDelegate].bookmarkNavigationController.viewControllers objectAtIndex:0];
        bookmarkContainerViewController.delegate = self;
    }
    if ([[self.navigationItem.rightBarButtonItem customView] isHidden]) {
        
    }else{
        [self.navigationController presentSemiViewController:bookmarkNavigationController];
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
