//
//  IPIActivityCellHelper.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIActivityCellHelper.h"
#import "IPIAbstractActivityCell.h"
#import "IPIPageActivityCell.h"
#import "IPIMiniPageActivityCell.h"
#import "IPIActivityTableViewCell.h"
#import "IPIUserActivityCell.h"
#import "IPIProviderActivityCell.h"
#import "IPIRankPageActivityCell.h"

@implementation IPIActivityCellHelper

+(IPIAbstractActivityCell*)cellForActivity:(IPKActivity*)activity{
    NSString * cellIdentifier = [NSString stringWithFormat:@"%d-%d", [activity activityType], [activity trackableType]];

    UITableViewCell * activityCell;
    if ([activity activityType] == IPKActivityTypeCreate && [activity trackableType] == IPKTrackableTypeTeam) {
        activityCell = [[IPIPageActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else if ([activity activityType] == IPKActivityTypeAdd && [activity trackableType] == IPKTrackableTypeProvider){
        activityCell = [[IPIProviderActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else if ([activity activityType] == IPKActivityTypeAdd && [activity trackableType] == IPKTrackableTypeCgListing){
        activityCell = [[IPIProviderActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else if ([activity activityType] == IPKActivityTypeFavorite && [activity trackableType] == IPKTrackableTypeTeam){
        activityCell = [[IPIPageActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else if ([activity activityType] == IPKActivityTypeRank && [activity trackableType] == IPKTrackableTypeTeam){
        activityCell = [[IPIRankPageActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    
    if (!activityCell) {
        activityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        activityCell.frame = CGRectZero;
        activityCell.backgroundColor = [UIColor clearColor];
        UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        activityCell.backgroundView = backgroundView;
        activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return activityCell;
}

+(CGFloat)heightForActivity:(IPKActivity*)activity{
    
    CGFloat height = 0;
    if ([activity activityType] == IPKActivityTypeCreate && [activity trackableType] == IPKTrackableTypeTeam) {
        height = [IPIPageActivityCell cellHeight];
    }
    else if ([activity activityType] == IPKActivityTypeAdd && [activity trackableType] == IPKTrackableTypeProvider){
        height = [IPIProviderActivityCell cellHeight];;
    }
    else if ([activity activityType] == IPKActivityTypeAdd && [activity trackableType] == IPKTrackableTypeCgListing){
        height = [IPIProviderActivityCell cellHeight];;
    }
    else if ([activity activityType] == IPKActivityTypeFavorite && [activity trackableType] == IPKTrackableTypeTeam){
        height = [IPIPageActivityCell cellHeight];
    }
    else if ([activity activityType] == IPKActivityTypeRank && [activity trackableType] == IPKTrackableTypeTeam){
        height = [IPIRankPageActivityCell cellHeightForActivity:activity];
    }
    else if ([activity activityType] == IPKActivityTypeFollow && [activity trackableType] == IPKTrackableTypeUser){
        height;
    }
    else if ([activity activityType] == IPKActivityTypeFollow && [activity trackableType] == IPKTrackableTypeTeam){
        height;
    }
    else if ([activity activityType] == IPKActivityTypeCollaborate && [activity trackableType] == IPKTrackableTypeUser){
        height;
    }
    else if ([activity activityType] == IPKActivityTypeTeam && [activity trackableType] == IPKTrackableTypeReview){
        height;
    }
    
    return height;
}

+(Class)cellClassForActivity:(IPKActivity*)activity{
    if ([activity trackableType] == IPKTrackableTypeProvider || [activity trackableType] == IPKTrackableTypeCgListing){
        return [IPIMiniPageActivityCell class];
    }else if ([activity trackableType] == IPKTrackableTypeUser){
        return [IPIUserActivityCell class];
    }
    return [IPIActivityTableViewCell class];
}

+(Class)headerViewClassForActivity:(IPKActivity*)activity{
    if ([activity trackableType] == IPKTrackableTypeProvider || [activity trackableType] == IPKTrackableTypeCgListing){
        return [IPIMiniPageActivityCell class];
    }else if ([activity trackableType] == IPKTrackableTypeUser){
        return [IPIUserActivityCell class];
    }
    return [IPIActivityTableViewCell class];
}

@end
