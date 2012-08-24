//
//  IPIPageViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//

#import "IPIBaseNoNavManagedTableViewController.h"

@class IPKPage;
@class IPIPageTableViewHeader;

@interface IPIPageViewController : IPIBaseNoNavManagedTableViewController

@property (nonatomic, strong, readonly) IPKPage *page;
@property (nonatomic, strong) IPIPageTableViewHeader * headerView;

@end
