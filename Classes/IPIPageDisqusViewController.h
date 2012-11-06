//
//  IPIPageDisqusViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "IPIBasePageSegmentViewController.h"
#import "iCarousel.h"
#import "IPIProviderMapsCarouselViewController.h"
#import "IPIDisqusTableViewCell.h"

@class IPKPage;

@interface IPIPageDisqusViewController : IPIBasePageSegmentViewController <IPIDisqusTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) IPKPage *page;
@property (nonatomic, strong) IPKUser * sortUser;
@property (nonatomic, strong) IPIProviderMapsCarouselViewController * providerMapsCarousel;
@property (nonatomic, strong) NSMutableDictionary * commentDictionary;
@property (nonatomic, strong) NSMutableDictionary * threadIDDictionary;
@property (nonatomic, strong) IADisqusComment * commentToReplyTo;
@property (nonatomic, strong) UIButton * hideKeyboardButton;
@property (nonatomic, strong) UITextField * commentField;

-(void)bookmarkTapped;
-(void)bookmarkClosed;

@end
