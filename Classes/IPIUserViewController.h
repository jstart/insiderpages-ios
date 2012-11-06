//
//  IPIUserViewController
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "IPIBookmarkBaseManagedViewController.h"
#import "IPIUserTableViewHeader.h"
#import "IPIUserBar.h"
#import "IPICollaboratorRankingsViewController.h"

@class IPKUser;

@interface IPIUserViewController : IPIBookmarkBaseManagedViewController <IPIUserTableViewHeaderDelegate, IPICollaboratorRankingsDelegate>

@property (nonatomic, strong) IPKUser *user;
@property (nonatomic, strong) IPIUserTableViewHeader * headerView;
@property (nonatomic, strong) IPIUserBar * userBar;

@end
