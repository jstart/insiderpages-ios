//
//  UISplitViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@class IPIListsViewController;
@class IPIListViewController;

@interface IPISplitViewController : UISplitViewController

+ (IPISplitViewController *)sharedSplitViewController;

@property (nonatomic, strong, readonly) IPIListsViewController *listsViewController;
@property (nonatomic, strong, readonly) IPIListViewController *listViewController;

@end
