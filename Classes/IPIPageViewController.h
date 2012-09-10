//
//  IPIPageViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "IPIBaseManagedPageSegmentViewController.h"
#import "IPIPageTableViewHeader.h"

@class IPKPage;

@interface IPIPageViewController : IPIBaseManagedPageSegmentViewController <IPIPageTableViewHeaderDelegate>

@property (nonatomic, strong) IPKPage *page;
@property (nonatomic, strong) IPIPageTableViewHeader * headerView;

@end
