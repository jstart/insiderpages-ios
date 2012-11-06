//
//  IPICommentReplyButton.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/22/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPICommentReplyButton.h"
#import "UIColor-Expanded.h"

@implementation IPICommentReplyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithHexString:@"009999"]];
        [self setAlpha:0.63];
        [[self titleLabel] setTextColor:[UIColor whiteColor]];
        [[self titleLabel] setFont:[UIFont fontWithName:@"Myriad Web Pro" size:13]];
        [self setTitle:@"Reply" forState:UIControlStateNormal];
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        [self setAlpha:1.0];
    }else{
        [self setAlpha:0.63];
    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setAlpha:1.0];
    }else{
        [self setAlpha:0.63];
    }
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
