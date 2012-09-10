//
//  IPIBaseNoNavViewController.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/22/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "CDIManagedTableViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "IPIBookmarkContainerViewController.h"
@interface IPIBaseNoNavManagedTableViewController : CDIManagedTableViewController
@property UIButton * backButton;
@property UIButton * bookmarkButton;
@end