//
//  IPIPushNotificationRouter.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/18/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPIPushNotificationRouter : NSObject

+(UIViewController*)viewControllerForPushNotificationResponse:(NSDictionary*)notificationResponse;

+(UIViewController*)viewControllerForTeamID:(NSNumber*)teamID;

+(UIViewController*)viewControllerForTeamID:(NSNumber*)teamID withSortUserID:(NSNumber*)userID;

+(UIViewController*)viewControllerForProviderID:(NSNumber*)providerID listingType:(NSString*)listingType;

+(UIViewController*)viewControllerForUserID:(NSNumber*)userID;

@end
