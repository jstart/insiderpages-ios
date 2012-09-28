//
//  IPIBookmarkWrapperMainViewController.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/11/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIBookmarkBaseModalViewController.h"
#import "IPIBookmarkNotificationBarViewController.h"
#import "IPIBookmarkMyPagesTableViewController.h"

@interface IPIBookmarkWrapperMainViewController : IPIBookmarkBaseModalViewController

@property (strong, nonatomic) IPIBookmarkMyPagesTableViewController * myPagesTableViewController;

@property (strong, nonatomic) IPIBookmarkNotificationBarViewController * headerViewController;

@end
