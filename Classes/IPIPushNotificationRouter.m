//
//  IPIPushNotificationRouter.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/18/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIPushNotificationRouter.h"
#import "IPISegmentContainerViewController.h"
#import "IPIProviderViewController.h"


@implementation IPIPushNotificationRouter

+(UIViewController*)viewControllerForPushNotificationResponse:(NSDictionary*)notificationResponse{
    NSNumber * userID = [notificationResponse objectForKey:@"user_id"];
    NSString * trackable_type = [notificationResponse objectForKey:@"trackable_type"];
    NSNumber * trackable_id = [notificationResponse objectForKey:@"trackable_id"];
    
    if ([trackable_type isEqualToString:@"Provider"] || [trackable_type isEqualToString:@"CgListing"]) {
        return [IPIPushNotificationRouter viewControllerForProviderID:trackable_id listingType:trackable_type];
    }else if ([trackable_type isEqualToString:@"User"]){
        return [IPIPushNotificationRouter viewControllerForUserID:trackable_id];
    }else if([trackable_type isEqualToString:@"Team"]){
        return [IPIPushNotificationRouter viewControllerForTeamID:trackable_id];
    }
    return nil;
}

+(UIViewController*)viewControllerForTeamID:(NSNumber*)teamID{
    IPISegmentContainerViewController * segmentContainerViewController = [[IPISegmentContainerViewController alloc] init];
    IPKPage *page = [IPKPage objectWithRemoteID:teamID];
    [segmentContainerViewController setPage:page];
    return segmentContainerViewController;
}

+(UIViewController*)viewControllerForTeamID:(NSNumber*)teamID withSortUserID:(NSNumber*)userID{
    IPISegmentContainerViewController * segmentContainerViewController = [[IPISegmentContainerViewController alloc] init];
    IPKPage *page = [IPKPage objectWithRemoteID:teamID];
    [segmentContainerViewController setPage:page];
    IPKUser *user = [IPKUser objectWithRemoteID:userID];
    [segmentContainerViewController setSortUser:user];
    return segmentContainerViewController;
}

+(UIViewController*)viewControllerForProviderID:(NSNumber*)providerID listingType:(NSString*)listingType{
    IPIProviderViewController * providerViewController = [[IPIProviderViewController alloc] init];
    IPKProvider *provider = [IPKProvider objectWithRemoteID:providerID];
    [provider setListing_type:listingType];
    [providerViewController setProvider:provider];
    return providerViewController;
}

+(UIViewController*)viewControllerForUserID:(NSNumber*)userID{
    //TBD
//    IPIUserViewController * userViewController = [[IPIUserViewController alloc] init];
//    IPKUser *user = [IPKUser objectWithRemoteID:userID];
//    [userViewController setUser:user];
//    return userViewController;
    return nil;
}

@end
