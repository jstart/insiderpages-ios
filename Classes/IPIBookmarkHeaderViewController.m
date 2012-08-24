//
//  IPBookmarkHeaderViewControllerViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkHeaderViewController.h"

@interface IPIBookmarkHeaderViewController ()

@end

@implementation IPIBookmarkHeaderViewController
@synthesize profileImageView;
@synthesize usernameLabel;
@synthesize settingsButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.profileImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.profileImageView setImage:[UIImage imageNamed:@"bookmark.png"]];
        [[self view] addSubview:self.profileImageView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setProfileImageView:nil];
    [self setUsernameLabel:nil];
    [self setSettingsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
