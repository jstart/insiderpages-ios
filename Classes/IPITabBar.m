//
//  IPITabBar.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/16/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPITabBar.h"

@implementation IPITabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITabBarItem * item1 = [[UITabBarItem alloc] initWithTitle:@"Mine" image:[UIImage imageNamed:@"safari-button"] tag:0];
        UITabBarItem * item2 = [[UITabBarItem alloc] initWithTitle:@"Following" image:[UIImage imageNamed:@"safari-button"] tag:1];
        UITabBarItem * item3 = [[UITabBarItem alloc] initWithTitle:@"Popular" image:[UIImage imageNamed:@"safari-button"] tag:2];
        
        [self setItems:@[item1, item2, item3]];
        [self setAlpha:0.85];
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
