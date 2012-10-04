//
//  IPIPageViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "IPIBaseManagedPageSegmentViewController.h"
#import "IPIPageTableViewHeader.h"

@class IPKPage, IPKUser;

@interface IPIPageViewController : IPIBaseManagedPageSegmentViewController <IPIPageTableViewHeaderDelegate>

@property (nonatomic, strong) IPKPage *page;
@property (nonatomic, strong) IPKUser *sortUser;
@property (nonatomic, strong) IPIPageTableViewHeader * headerView;

@end
