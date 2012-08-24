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
        UITabBarItem * item1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
        [item1 setTitle:@"Mine"];
        UITabBarItem * item2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
        [item2 setTitle:@"Following"];
        UITabBarItem * item3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
        [item3 setTitle:@"Popular"];

        
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
