//
//  IPBookmarkBaseViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPIBookmarkViewController.h"
#import "IPIBookmarkContainerViewController.h"
#import "CDIManagedTableViewController.h"

@interface IPIBookmarkBaseViewController : CDIManagedTableViewController <IPIBookmarkViewDelegate>

@property (strong, nonatomic) UINavigationController* bookmarkNavigationController;

-(void)hideBookmark;
-(void)showBookmark;
-(void)presentWelcomeViewController;
-(void)presentBookmarkViewController;

@end
