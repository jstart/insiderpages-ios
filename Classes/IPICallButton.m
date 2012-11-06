//
//  IPICallButton.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 11/2/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPICallButton.h"
#import "UIColor-Expanded.h"

@implementation IPICallButton

@synthesize phoneNumber = _phoneNumber;

-(void)setPhoneNumber:(NSString *)phoneNumber{
    _phoneNumber = phoneNumber;
    self.phoneNumberLabel.text = phoneNumber;
}

+(IPICallButton*)standardCallButton{
    return [[IPICallButton alloc] initWithFrame:CGRectMake(0, 0, 211, 47)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundImage:[UIImage imageNamed:@"call_button"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [[self titleLabel] setTextColor:[UIColor colorWithHexString:@"999999"]];
        [[self titleLabel] setFont:[UIFont fontWithName:@"Myriad Web Pro" size:13]];
        [self setTitle:@"Call Now" forState:UIControlStateNormal];
        
        self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 60, 47)];
        [self.phoneNumberLabel setBackgroundColor:[UIColor clearColor]];
        [[self phoneNumberLabel] setTextColor:[UIColor colorWithHexString:@"999999"]];
        [[self phoneNumberLabel] setFont:[UIFont fontWithName:@"Myriad Web Pro" size:13]];
        [[self phoneNumberLabel] setContentMode:UIViewContentModeCenter];
        [self addSubview:self.phoneNumberLabel];
        
        self.phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 15, 11, 15)];
        [self.phoneImageView setImage:[UIImage imageNamed:@"call_icon"]];
        [self addSubview:self.phoneImageView];
        
        UIImageView * keylineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 12, 1, 21)];
        [keylineImageView setImage:[UIImage imageNamed:@"call_button_keyline"]];
        [self addSubview:keylineImageView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.titleLabel.frame;
    frame.origin.x = 131;
    self.titleLabel.frame = frame;
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
