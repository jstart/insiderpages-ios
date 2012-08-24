//
//  IPIBaseNoNavViewController.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/22/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIBaseNoNavManagedTableViewController.h"

@interface IPIBaseNoNavManagedTableViewController ()

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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self view] bringSubviewToFront:self.backButton];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
