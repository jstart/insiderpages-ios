//
//  IPIActivityCellHelper.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIActivityCellHelper.h"

@implementation IPIActivityCellHelper

+(UITableViewCell*)cellForActivity:(IPKActivity*)activity{
    UITableViewCell * activityCell;
    if ([activity activityType] == IPKActivityTypeCreate && [activity trackableType] == IPKTrackableTypeTeam) {
        activityCell = nil;
    }
    else if ([activity activityType] == IPKActivityTypeAdd && [activity trackableType] == IPKTrackableTypeProvider){
        activityCell;
    }
    else if ([activity activityType] == IPKActivityTypeAdd && [activity trackableType] == IPKTrackableTypeCgListing){
        activityCell;
    }
    else if ([activity activityType] == IPKActivityTypeFavorite && [activity trackableType] == IPKTrackableTypeTeam){
        activityCell;
    }
    else if ([activity activityType] == IPKActivityTypeRank && [activity trackableType] == IPKTrackableTypeTeam){
        activityCell;
    }
    else if ([activity activityType] == IPKActivityTypeFollow && [activity trackableType] == IPKTrackableTypeUser){
        activityCell;
    }
    else if ([activity activityType] == IPKActivityTypeFollow && [activity trackableType] == IPKTrackableTypeTeam){
        activityCell;
    }
    else if ([activity activityType] == IPKActivityTypeCollaborate && [activity trackableType] == IPKTrackableTypeUser){
       activityCell;
    }
    else if ([activity activityType] == IPKActivityTypeTeam && [activity trackableType] == IPKTrackableTypeReview){
        activityCell;
    }
    return activityCell;
}

@end
