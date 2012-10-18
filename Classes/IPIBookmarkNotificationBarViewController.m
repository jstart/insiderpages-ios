//
//  IPBookmarkHeaderViewControllerViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkNotificationBarViewController.h"
#import "IPIBookmarkNotificationsViewController.h"

@interface IPIBookmarkNotificationBarViewController ()

@end

@implementation IPIBookmarkNotificationBarViewController
@synthesize notificationsButton;

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
    // Do any additional setup after loading the view from its nib.
    self.notificationsButton.titleLabel.font = [UIFont fontWithName:@"Comfortaa" size:17];
    [self.notificationsButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [self setNotificationsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)buttonClicked{
    IPIBookmarkNotificationsViewController * bookmarkNotificationsViewController = [[IPIBookmarkNotificationsViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:bookmarkNotificationsViewController animated:YES];
}

@end
