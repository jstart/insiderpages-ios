//
//  IPIBaseNoNavViewController.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/22/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIBaseNoNavManagedTableViewController.h"
#import "IPIAppDelegate.h"

@interface IPIBaseNoNavManagedTableViewController () <IPIBookmarkViewDelegate>

@end

@implementation IPIBaseNoNavManagedTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization'

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.backButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    CGRect frame = self.backButton.frame;
    frame.origin.x = 5;
    frame.origin.y = 5;
    [self.backButton setFrame:frame];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:self.backButton];
    UIImage * image = [UIImage imageNamed:@"bookmark.png"];
    
    self.bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bookmarkButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.bookmarkButton setAdjustsImageWhenHighlighted:YES];
    
    self.bookmarkButton.frame= CGRectMake(320 - image.size.width - 5, 0.0, image.size.width, image.size.height);
    
    [self.bookmarkButton addTarget:self action:@selector(presentBookmarkViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bookmarkButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self view] bringSubviewToFront:self.backButton];
    [[self view] bringSubviewToFront:self.bookmarkButton];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)presentBookmarkViewController;
{
    IPIBookmarkContainerViewController * bookmarkContainerViewController = [[IPIAppDelegate sharedAppDelegate].bookmarkNavigationController.viewControllers objectAtIndex:0];
    bookmarkContainerViewController.delegate = self;
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
    [[self.bookmarkButton layer] addAnimation:animation forKey:@"pushOut"];
    [self.bookmarkButton setHidden:NO];
}

-(void)hideBookmark{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
    [animation setDuration:0.2f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.bookmarkButton layer] addAnimation:animation forKey:@"pushOut"];
    [self.bookmarkButton setHidden:YES];
}

-(void) bookmarkViewWasDismissed:(int)homePageIndex{
    [self.navigationController dismissSemiModalView];
    [self showBookmark];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
