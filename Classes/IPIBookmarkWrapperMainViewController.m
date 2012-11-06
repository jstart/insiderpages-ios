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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotificationNumber)
                                                 name:@"updateNotificationNumber"
                                               object:nil];
    self.footerViewController = [[IPIBookmarkNotificationBarViewController alloc] initWithNibName:@"IPIBookmarkNotificationBarViewController" bundle:[NSBundle mainBundle]];
    [self addChildViewController:self.footerViewController];
    CGRect headerFrame = self.footerViewController.view.frame;
    
    self.myPagesTableViewController = [[IPIBookmarkMyPagesTableViewController alloc] initWithNibName:@"IPIBookmarkMyPagesTableViewController" bundle:[NSBundle mainBundle]];
    [self addChildViewController:self.myPagesTableViewController];
        
    [self.myPagesTableViewController.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - headerFrame.size.height)];
    [[self view] addSubview:self.myPagesTableViewController.view];
    
    headerFrame.origin.y = self.parentViewController.view.frame.size.height - headerFrame.size.height;
    [self.footerViewController.view setFrame:headerFrame];
    [[self view] addSubview:self.footerViewController.view];
    IPKUser * currentUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSArray * unreadNotificationsArray = [[currentUser.notifications filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"read == NO"]] allObjects];
    if (currentUser) {
        [self.footerViewController.notificationsButton setTitle:(unreadNotificationsArray.count > 1 || unreadNotificationsArray.count == 0) ? [NSString stringWithFormat:@"%d Notifications", unreadNotificationsArray.count] : [NSString stringWithFormat:@"%d Notification", unreadNotificationsArray.count] forState:UIControlStateNormal];
        [self.footerViewController.notificationsButton setTitle:(unreadNotificationsArray.count > 1 || unreadNotificationsArray.count == 0) ? [NSString stringWithFormat:@"%d Notifications", unreadNotificationsArray.count] : [NSString stringWithFormat:@"%d Notification", unreadNotificationsArray.count] forState:UIControlStateSelected];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.parentViewController.parentViewController.title = @"My Pages";
    
    UIView * addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton * addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addButton setImage:[UIImage imageNamed:@"add_page_button"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(createPage) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addButton];
    UIBarButtonItem * addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addView];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    self.parentViewController.parentViewController.navigationItem.rightBarButtonItem = addButtonItem;
    self.parentViewController.parentViewController.navigationItem.leftBarButtonItem = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^(){
        IPKUser * currentUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        NSArray * unreadNotificationsArray = [[currentUser.notifications filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"read == NO"]] allObjects];
    
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            [self.footerViewController.notificationsButton setTitle:(unreadNotificationsArray.count > 1 || unreadNotificationsArray.count == 0) ? [NSString stringWithFormat:@"%d Notifications", unreadNotificationsArray.count] : [NSString stringWithFormat:@"%d Notification", unreadNotificationsArray.count] forState:UIControlStateNormal];
            [self.footerViewController.notificationsButton setTitle:(unreadNotificationsArray.count > 1 || unreadNotificationsArray.count == 0) ? [NSString stringWithFormat:@"%d Notifications", unreadNotificationsArray.count] : [NSString stringWithFormat:@"%d Notification", unreadNotificationsArray.count] forState:UIControlStateSelected];
        });
    });
    
    [[IPKHTTPClient sharedClient] getNotificationsWithCurrentPage:@1 perPage:@10 success:^(AFJSONRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationNumber" object:nil userInfo:nil];
            IPKUser * currentUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            NSArray * unreadNotificationsArray = [[currentUser.notifications filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"read == NO"]] allObjects];
            [self.footerViewController.notificationsButton setTitle:(unreadNotificationsArray.count > 1 || unreadNotificationsArray.count == 0) ? [NSString stringWithFormat:@"%d Notifications", unreadNotificationsArray.count] : [NSString stringWithFormat:@"%d Notification", unreadNotificationsArray.count] forState:UIControlStateNormal];
            [self.footerViewController.notificationsButton setTitle:(unreadNotificationsArray.count > 1 || unreadNotificationsArray.count == 0) ? [NSString stringWithFormat:@"%d Notifications", unreadNotificationsArray.count] : [NSString stringWithFormat:@"%d Notification", unreadNotificationsArray.count] forState:UIControlStateSelected];
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
    }];

}

-(void)updateNotificationNumber{
    IPKUser * currentUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSArray * unreadNotificationsArray = [[currentUser.notifications filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"read == NO"]] allObjects];

    dispatch_async(dispatch_get_main_queue(), ^(){

        [self.footerViewController.notificationsButton setTitle:(unreadNotificationsArray.count > 1 || unreadNotificationsArray.count == 0) ? [NSString stringWithFormat:@"%d Notifications", unreadNotificationsArray.count] : [NSString stringWithFormat:@"%d Notification", unreadNotificationsArray.count] forState:UIControlStateNormal];
        [self.footerViewController.notificationsButton setTitle:(unreadNotificationsArray.count > 1 || unreadNotificationsArray.count == 0) ? [NSString stringWithFormat:@"%d Notifications", unreadNotificationsArray.count] : [NSString stringWithFormat:@"%d Notification", unreadNotificationsArray.count] forState:UIControlStateSelected];
    });
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
