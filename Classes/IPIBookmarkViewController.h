//
//  IPBookmarkViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPIBookmarkHeaderViewController.h"
//#import "IPNotificationListViewController.h"

@interface IPIBookmarkViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UITableView *bookmarkTableView;
@property (strong, nonatomic) IPIBookmarkHeaderViewController * headerViewController;
//@property (strong, nonatomic) IPINotificationListViewController * notificationViewController;

@end

