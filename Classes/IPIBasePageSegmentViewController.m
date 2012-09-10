//
//  IPIBasePageSegmentViewController.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIBasePageSegmentViewController.h"

@interface IPIBasePageSegmentViewController ()

@end

@implementation IPIBasePageSegmentViewController

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

@end
