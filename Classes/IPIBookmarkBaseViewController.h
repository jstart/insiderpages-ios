//
//  IPBookmarkBaseViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPIBookmarkWrapperMainViewController.h"
#import "IPIBookmarkContainerViewController.h"
#import "CDIManagedTableViewController.h"

@interface IPIBookmarkBaseViewController : UIViewController <IPIBookmarkViewDelegate>

@property (strong, nonatomic) UINavigationController* bookmarkNavigationController;
@property (strong, nonatomic) UILabel * notificationCountLabel;

-(void)hideBookmark;
-(void)showBookmark;
-(void)presentBookmarkViewController;

@end
