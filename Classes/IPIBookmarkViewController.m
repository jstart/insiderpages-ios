//
//  IPBookmarkViewController.m
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkViewController.h"
//#import "IPIViewController.h"
#import "IPIBookmarkContainerViewController.h"
//#import "IPIBookmarkSearchViewController.h"

@interface IPIBookmarkViewController ()

@end

@implementation IPIBookmarkViewController

@synthesize searchBar;
@synthesize bookmarkTableView;
@synthesize headerViewController;
//@synthesize notificationViewController;

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
    frame.size.height = 308;
    self.navigationController.view.frame = frame;
    // Do any additional setup after loading the view from its nib.
//    self.notificationViewController = [[IPNotificationListViewController alloc] initWithNibName:@"IPINotificationListViewController" bundle:[NSBundle mainBundle]];
//    [self.notificationViewController.navigationController setNavigationBarHidden:NO];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.contentMode = UIViewContentModeScaleToFill;
    self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"One", @"Two", nil];
    self.searchBar.showsScopeBar = YES;
    
    self.headerViewController = [[IPIBookmarkHeaderViewController alloc] initWithNibName:@"IPIBookmarkHeaderViewController" bundle:[NSBundle mainBundle]];

    [self.bookmarkTableView setTableFooterView:self.headerViewController.view];

    if ([IPKUser currentUser]) {
        self.headerViewController.usernameLabel.text = [[IPKUser currentUser] name];
        [self.headerViewController.profileImageView setPathToNetworkImage:[[IPKUser currentUser] imageProfilePathForSize:IPKUserProfileImageSizeMedium]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_currentUserDidChange:) name:kIPKCurrentUserChangedNotificationName object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{

}

- (void)viewDidUnload
{
  [self setBookmarkTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSString* CellIdentifier = @"Cell";
  switch (indexPath.row) {
    case 0:{
      CellIdentifier = @"Search";
    }
      break;
    default:
      CellIdentifier = @"Cell";
      break;
  }

  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    switch (indexPath.row) {
      case 0:{
        [cell addSubview:self.searchBar];
        cell.backgroundColor = UIColor.grayColor;
        break;
      }
      case 1:{
        cell.textLabel.text = @"Create New Page";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        break;
      }
      case 2:{
        cell.textLabel.text = @"My Pages";
        break;
      }
      case 3:{
        cell.textLabel.text = @"Following";
        break;
      }
      case 4:{
        cell.textLabel.text = @"Popular";
        break;
      }
      case 5:{
        cell.textLabel.text = @"Notifications";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        break;
      }
      default:
        cell.textLabel.text = @"Hi";
        break;
    }
  }
   return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        //Search
      case 0:{
        break;
      }
        //Create New Page
      case 1:{
        if (((IPIBookmarkContainerViewController*)self.navigationController.parentViewController).delegate) {
          [((IPIBookmarkContainerViewController*)self.navigationController.parentViewController).delegate bookmarkViewWasDismissed:-1];
        }
        else{
          NSLog(@"No delegate for bookmarkview");
        }
        break;
      }
        //My Pages
      case 2:{
        if (((IPIBookmarkContainerViewController*)self.navigationController.parentViewController).delegate) {
          [((IPIBookmarkContainerViewController*)self.navigationController.parentViewController).delegate bookmarkViewWasDismissed:1];
        }
        else{
          NSLog(@"No delegate for bookmarkview");
        }
        break;
      }
        //Following
      case 3:{
        if (((IPIBookmarkContainerViewController*)self.navigationController.parentViewController).delegate) {
          [((IPIBookmarkContainerViewController*)self.navigationController.parentViewController).delegate bookmarkViewWasDismissed:2];
        }
        else{
          NSLog(@"No delegate for bookmarkview");
        }
        break;
      }
        //Popular
      case 4:{
        if (((IPIBookmarkContainerViewController*)self.navigationController.parentViewController).delegate) {
          [((IPIBookmarkContainerViewController*)self.navigationController.parentViewController).delegate bookmarkViewWasDismissed:0];
        }
        else{
          NSLog(@"No delegate for bookmarkview");
        }
        break;
      }
        //Notifications
      case 5:{
//          [self.navigationController pushViewController:notificationViewController animated:YES];
        break;
      }
      default:
        break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark
#pragma mark UISearchBar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
  [self.searchBar setShowsCancelButton:NO animated:YES];
  [self.searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//  [self.searchBar setShowsCancelButton:YES animated:YES];
//    IPIBookmarkSearchViewController * bookmarkSearchViewController = [[IPIBookmarkSearchViewController alloc] initWithNibName:@"IPIBookmarkSearchViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:bookmarkSearchViewController animated:YES];
  return NO;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
  [self.searchBar setShowsCancelButton:NO animated:YES];
  [self.searchBar resignFirstResponder];
  return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  [self.searchBar setShowsCancelButton:NO animated:YES];
  [self.searchBar resignFirstResponder];
}
@end
