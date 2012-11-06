//
//  IPIPageViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "IPIBaseManagedPageSegmentViewController.h"
#import "IPIPageTableViewHeader.h"
#import "IPIRankBar.h"
#import "IPICollaboratorRankingsViewController.h"

@class IPKPage, IPKUser;

@interface IPIPageViewController : IPIBaseManagedPageSegmentViewController <IPIPageTableViewHeaderDelegate, IPICollaboratorRankingsDelegate>

@property (nonatomic, strong) IPKPage *page;
@property (nonatomic, strong) IPKUser *sortUser;
@property (nonatomic, strong) IPIPageTableViewHeader * headerView;
@property (nonatomic, strong) IPIRankBar * rankBar;
@property (nonatomic, strong) UIButton * tabButton;

-(void)tabSelected;

@end
