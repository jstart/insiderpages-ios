//
//  IPIBookmarkWrapperMainViewController.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/11/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIBookmarkWrapperMainViewController.h"
#import "IPICreatePageInitialViewController.h"
#import "IPIAppDelegate.h"
#import "IIViewDeckController.h"

@interface IPIBookmarkWrapperMainViewController ()

@end

@implementation IPIBookmarkWrapperMainViewController

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
    
    self.parentViewController.parentViewController.title = @"My Pages";
    
    self.parentViewController.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createPage)];

    self.headerViewController = [[IPIBookmarkHeaderViewController alloc] initWithNibName:@"IPIBookmarkHeaderViewController" bundle:[NSBundle mainBundle]];
    CGRect headerFrame = self.headerViewController.view.frame;
    
    self.myPagesTableViewController = [[IPIBookmarkMyPagesTableViewController alloc] initWithNibName:@"IPIBookmarkMyPagesTableViewController" bundle:[NSBundle mainBundle]];
    [self addChildViewController:self.myPagesTableViewController];
        
    [self.myPagesTableViewController.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - headerFrame.size.height)];
    [[self view] addSubview:self.myPagesTableViewController.view];
    
    headerFrame.origin.y = self.parentViewController.view.frame.size.height - headerFrame.size.height;
    [self.headerViewController.view setFrame:headerFrame];
    [[self view] addSubview:self.headerViewController.view];
    
    if ([IPKUser currentUser]) {
        self.headerViewController.usernameLabel.text = [[IPKUser currentUser] name];
        [self.headerViewController.profileImageView setPathToNetworkImage:[[IPKUser currentUser] imageProfilePathForSize:IPKUserProfileImageSizeMedium]];
    }
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

-(void)createPage{
    [[self containerViewController].delegate bookmarkViewWasDismissed:-1];
    IPICreatePageInitialViewController * createPageInitialViewController = [[IPICreatePageInitialViewController alloc] initWithNibName:@"IPICreatePageInitialViewController" bundle:[NSBundle mainBundle]];
    UINavigationController * navigationCreatePageViewController = [[UINavigationController alloc] initWithRootViewController:createPageInitialViewController];
    
    UINavigationController * navWrapperController = (UINavigationController *)[[[IPIAppDelegate sharedAppDelegate] window] rootViewController];
    IIViewDeckController * viewDeckController = (IIViewDeckController *)[navWrapperController topViewController];
    [viewDeckController.centerController presentModalViewController:navigationCreatePageViewController animated:YES];
}

@end
