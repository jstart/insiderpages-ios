//
//  IPIPageViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//

#import "CDIManagedTableViewController.h"

@class IPKPage;

@interface IPIPageViewController : CDIManagedTableViewController

@property (nonatomic, strong, readonly) IPKPage *page;

@end
