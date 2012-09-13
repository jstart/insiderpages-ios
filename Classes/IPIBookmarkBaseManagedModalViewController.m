//
//  IPIBookmarkBaseManagedModalViewController.,
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkBaseManagedModalViewController.h"

@interface IPIBookmarkBaseManagedModalViewController ()

@end

@implementation IPIBookmarkBaseManagedModalViewController

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
//    self.wantsFullScreenLayout = YES;
    CGRect frame = self.navigationController.view.frame;
    frame.size.height = 372;
    self.navigationController.view.frame = frame;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IPIBookmarkContainerViewController*)containerViewController{
    return ((IPIBookmarkContainerViewController*)self.navigationController.parentViewController);
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
