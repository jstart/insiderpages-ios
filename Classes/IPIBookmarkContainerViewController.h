//
//  IPBookmarkContainerViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPIBookmarkViewDelegate <NSObject>

-(void)bookmarkViewWasDismissed:(int)homePageIndex;

@end

@interface IPIBookmarkContainerViewController : UIViewController

@property (strong, nonatomic) id <IPIBookmarkViewDelegate> delegate;

@end
