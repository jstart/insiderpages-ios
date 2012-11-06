//
//  IPINotificationPathRouter.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/26/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPINotificationPathRouter : NSObject

+(UIViewController*)viewControllerForActivityParent:(NSString*)activityParent;

@end
