//
//  IPISearchBar.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/1/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPISearchBar.h"

@implementation IPISearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) addSubview:(UIView *)view {
    [super addSubview:view];
    
    if ([view isKindOfClass:UIButton.class]) {
        UIButton *cancelButton = (UIButton *)view;
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateHighlighted];
    }
}

@end
