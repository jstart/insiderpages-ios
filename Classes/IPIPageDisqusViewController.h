//
//  IPIPageDisqusViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "IPIBasePageSegmentViewController.h"
#import "iCarousel.h"
#import "IPIProviderMapsCarouselViewController.h"

@class IPKPage;

@interface IPIPageDisqusViewController : IPIBasePageSegmentViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) IPKPage *page;
@property (nonatomic, strong) IPIProviderMapsCarouselViewController * providerMapsCarousel;
@property (nonatomic, strong) NSMutableArray * comments;

@end
