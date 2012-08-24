//
//  CDIListsViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//
#import "IPIBookmarkBaseViewController.h"
#import "IPIActivityPageTableViewHeader.h"

extern NSString *const kIPISelectedListKey;

@interface IPIActivityViewController : IPIBookmarkBaseViewController <IPIActivityTableViewHeaderDelegate, UITabBarDelegate>

@end
