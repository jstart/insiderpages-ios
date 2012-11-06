//
//  IPIPageRankActionViewController
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "IPIBaseManagedPageSegmentViewController.h"

#import "IPICollaboratorRankingsViewController.h"

@class IPKPage, IPKUser;

@interface IPIPageRankActionViewController : IPIBaseManagedPageSegmentViewController

@property (nonatomic, strong) IPKPage *page;
@property (nonatomic, strong) UIButton *addPlaceButton;

@end
