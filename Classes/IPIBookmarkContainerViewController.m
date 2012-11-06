//
//  IPBookmarkContainerViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkContainerViewController.h"
#import "IPIBookmarkWrapperMainViewController.h"

@interface IPIBookmarkContainerViewController ()

@end

@implementation IPIBookmarkContainerViewController

@synthesize delegate;

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
    IPIBookmarkWrapperMainViewController *bookmarkWrapperViewController = [[IPIBookmarkWrapperMainViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:bookmarkWrapperViewController];
    [self addChildViewController:navController];
    [[self view] addSubview:navController.view];
    
    CGRect frame = self.bookmarkButton.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 120;
    self.bookmarkButton.frame = frame;
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    CGRect frame = self.navigationController.navigationBar.frame;
//    frame.origin.y = 0;
//    frame.size.height = 436;
//    self.navigationController.view.frame = frame;
}

- (void)viewDidUnload
{
    [self setBookmarkButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    CGRect frame = self.navigationController.navigationBar.frame;
//    if (frame.origin.y != 0) {
//        frame.origin.y = 0;
//        frame.size.height = 400;
//        self.navigationController.view.frame = frame;
//    }
//    if (frame.origin.y != 0) {
//        frame.size.height = 400;
//        self.navigationController.view.frame = frame;
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeButton:(id)sender {
    if (self.delegate) {
        [self.delegate bookmarkViewWasDismissed:-1];
    }
    else{
        NSLog(@"No delegate for bookmarkview");
    }
}

@end
