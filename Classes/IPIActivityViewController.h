//
//  CDIListsViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//
#import "IPIBookmarkBaseManagedViewController.h"
#import "IPIActivityPageTableViewHeader.h"
#import "IPITabBar.h"

extern NSString *const kIPISelectedListKey;

enum IPKActivityFilterType{
    IPKActivityFilterTypeYou = 0,
    IPKActivityFilterTypeFollowers = 1,
    IPKActivityFilterTypePopular = 2
};

@interface IPIActivityViewController : IPIBookmarkBaseManagedViewController <IPIActivityTableViewHeaderDelegate, UITabBarDelegate>

@property (nonatomic, readwrite) enum IPKActivityFilterType filterType;
@property (nonatomic, strong) IPITabBar * tabBar;

@end
