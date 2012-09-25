//
//  IPKActivity+Formatting.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/17/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPKActivity+Formatting.h"
#import "NSAttributedString+Attributes.h"
#import "UIColor-Expanded.h"

@implementation IPKActivity (Formatting)

-(NSMutableAttributedString *)attributedActionText{
    NSString * fullActionText = [[[[self user] name] stringByAppendingString:[self actionText]] copy];

    if ([self nounText]) {
        fullActionText = [fullActionText stringByAppendingString:[self nounText]];
    }
    
    NSMutableAttributedString * fullActionTextAttributedString;
    if (fullActionText) {
        fullActionTextAttributedString = [[NSMutableAttributedString alloc] initWithString:fullActionText];
        
        if ([[self user] name]){
            NSRange usernameRange = [fullActionText rangeOfString:[[self user] name]];
            [fullActionTextAttributedString setFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] range:usernameRange];
            [fullActionTextAttributedString setTextColor:[UIColor colorWithHexString:@"333333"] range:usernameRange];
        }
        
        if ([self actionText]) {
            NSRange actionRange = [fullActionText rangeOfString:[self actionText]];
            [fullActionTextAttributedString setFont:[UIFont fontWithName:@"Myriad Web Pro" size:13] range:actionRange];
            [fullActionTextAttributedString setTextColor:[UIColor colorWithHexString:@"999999"] range:actionRange];
        }
        
        if ([self nounText]) {
            NSRange nounRange = [fullActionText rangeOfString:[self nounText]];
            [fullActionTextAttributedString setFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] range:nounRange];
            [fullActionTextAttributedString setTextColor:[UIColor colorWithHexString:@"333333"] range:nounRange];
        }
    }
    
    return fullActionTextAttributedString;
}

-(NSString *)actionText{
    NSString * actionText;
    
    switch ([self activityType]) {
        case IPKActivityTypeCreate:
            actionText = [NSString stringWithFormat:@" created a page"];
            break;
        case IPKActivityTypeAdd:
            actionText = [NSString stringWithFormat:@" added a place to "];
            break;
        case IPKActivityTypeUpdate:
            actionText = [NSString stringWithFormat:@" updated "];
            break;
        case IPKActivityTypeTeam:
            actionText = [NSString stringWithFormat:@" posted a review for "];
            break;
        case IPKActivityTypeView:
            actionText = [NSString stringWithFormat:@" viewed "];
            break;
        case IPKActivityTypeFollow:
            actionText = [NSString stringWithFormat:@" started following "];
            break;
        case IPKActivityTypeCollaborate:
            actionText = [NSString stringWithFormat:@" invited a collaborator named "];
            break;
        case IPKActivityTypeFavorite:
            actionText = [NSString stringWithFormat:@" favorited a page"];
            break;
        case IPKActivityTypeRank:
            actionText = [NSString stringWithFormat:@" reranked "];
            break;
        case IPKActivityTypeAccept:
            actionText = [NSString stringWithFormat:@" accepted invite from "];
            break;
        case IPKActivityTypeAll:
            actionText = [NSString stringWithFormat:@" activity "];
            break;
            
        default:
            actionText = [NSString stringWithFormat:@" activity "];
            break;
    }
    
    return actionText;
}

-(NSString *)nounText{
    NSString * nounText;
    
    if ([self activityType] == IPKActivityTypeCreate && [self trackableType] == IPKTrackableTypeTeam) {
        nounText = nil;
    }
    else if ([self activityType] == IPKActivityTypeAdd && [self trackableType] == IPKTrackableTypeProvider){
        nounText = self.page.name;
    }
    else if ([self activityType] == IPKActivityTypeAdd && [self trackableType] == IPKTrackableTypeCgListing){
        nounText = self.page.name;
    }
    else if ([self activityType] == IPKActivityTypeFavorite && [self trackableType] == IPKTrackableTypeTeam){
        nounText = nil;
    }
    else if ([self activityType] == IPKActivityTypeRank && [self trackableType] == IPKTrackableTypeTeam){
        nounText = self.page.name;
    }
    else if ([self activityType] == IPKActivityTypeFollow && [self trackableType] == IPKTrackableTypeUser){
        nounText = self.user2.name;
    }
    else if ([self activityType] == IPKActivityTypeFollow && [self trackableType] == IPKTrackableTypeTeam){
        nounText = self.page.name;
    }
    else if ([self activityType] == IPKActivityTypeCollaborate && [self trackableType] == IPKTrackableTypeUser){
        nounText = self.user2.name;
    }
    else if ([self activityType] == IPKActivityTypeAccept && [self trackableType] == IPKTrackableTypeUser){
        nounText = self.user2.name;
    }
    else if ([self activityType] == IPKActivityTypeTeam && [self trackableType] == IPKTrackableTypeReview){
        nounText = self.review.page.name;
    }
    return nounText;
}

@end
