//
//  IPITabBar.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/16/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPITabBar.h"
#import "UIColor-Expanded.h"

@implementation IPITabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UITabBarItem * item1 = [[UITabBarItem alloc] initWithTitle:@"Mine" image:[UIImage imageNamed:@"safari-button"] tag:0];
        UITabBarItem * item1 = [[UITabBarItem alloc] init];
        [item1 setTitle:@"Mine"];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Myriad Web Pro" size:13], UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Myriad Web Pro" size:13], UITextAttributeFont, [UIColor colorWithHexString:@"a2a2a2"], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
        [item1 setTitlePositionAdjustment:UIOffsetMake(0, -15)];
        [item1 setTag:0];
        [item1 setFinishedSelectedImage:[UIImage imageNamed:@"left_button_active"] withFinishedUnselectedImage:[UIImage imageNamed:@"left_button_inactive"]];
        UITabBarItem * item2 = [[UITabBarItem alloc] init];
        [item2 setTitle:@"Following"];
        [item2 setTag:1];
        [item2 setTitlePositionAdjustment:UIOffsetMake(0, -15)];
        [item2 setFinishedSelectedImage:[UIImage imageNamed:@"center_button_active"] withFinishedUnselectedImage:[UIImage imageNamed:@"center_button_inactive"]];
        UITabBarItem * item3 = [[UITabBarItem alloc] init];
        [item3 setTitle:@"Public"];
        [item3 setTag:2];
        [item3 setTitlePositionAdjustment:UIOffsetMake(0, -15)];
        [item3 setFinishedSelectedImage:[UIImage imageNamed:@"right_button_active"] withFinishedUnselectedImage:[UIImage imageNamed:@"right_button_inactive"]];
        
        [self setItems:@[item1, item2, item3]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
