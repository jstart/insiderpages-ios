//
//  IPINotificationPathRouter.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/26/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPINotificationPathRouter.h"
#import "IPIPushNotificationRouter.h"

@implementation IPINotificationPathRouter

+(UIViewController*)viewControllerForActivityParent:(NSString*)activityParent{
    NSArray * pathComponents = [activityParent componentsSeparatedByString:@":"];
    NSString *trackableType = [pathComponents objectAtIndex:0];
    
    UIViewController * viewController;
    
    if ([trackableType isEqualToString:@"Team"]) {
        NSNumber *trackableID = @([[pathComponents objectAtIndex:1] longLongValue]);
        viewController = [IPIPushNotificationRouter viewControllerForTeamID:trackableID];
    }else if ([trackableType isEqualToString:@"User"]){
        NSNumber *trackableID = @([[pathComponents objectAtIndex:1] longLongValue]);
//        viewController = [IPIPushNotificationRouter viewControllerForTeamID:trackableID];
    }else if([trackableType isEqualToString:@"Provider"]){
        NSNumber *trackableID = @([[pathComponents objectAtIndex:1] longLongValue]);
        viewController = [IPIPushNotificationRouter viewControllerForProviderID:trackableID listingType:@"Provider"];
    }else if([trackableType isEqualToString:@"Cglisting"]){
        NSNumber *trackableID = @([[pathComponents objectAtIndex:1] longLongValue]);
        viewController = [IPIPushNotificationRouter viewControllerForProviderID:trackableID listingType:@"CgListing"];
    }else{
        NSLog(@"%@", trackableType);
    }
    return viewController;
}

@end
