//
//  IPBookmarkContainerViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkContainerViewController.h"
#import "IPiBookmarkViewController.h"

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    CGRect frame = self.navigationController.view.frame;
//    frame.origin.y = 20;
    frame.size.height = 345;
    self.navigationController.view.frame = frame;
    // Do any additional setup after loading the view from its nib.
    
    IPIBookmarkViewController *bookmarkViewController = [[IPIBookmarkViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:bookmarkViewController];
    [self addChildViewController:navController];
    [[self view] addSubview:navController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
//    CGRect frame = self.navigationController.view.frame;
//    frame.origin.y = 20;
//    self.navigationController.view.frame = frame;
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
