//
//  IPIProviderActivityCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/21/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIProviderActivityCell.h"
#import "UIColor-Expanded.h"

@implementation IPIProviderActivityCell

@synthesize activity = _activity;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        
        self.nameLabel.text = [activity.provider full_name];
        //        self.timeLabel.text = [activity formattedTimeElapsedSinceUpdated];
        [self setNeedsLayout];
    }
}

- (id)initWithActivity:(IPKActivity*)activity reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithActivity:activity reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        self.cellView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 290, 40)];
        self.cellView.backgroundColor = [UIColor whiteColor];
        self.cellView.layer.cornerRadius = 3;
        [[self.cellView layer] setMasksToBounds:NO];
        [[self.cellView layer] setShadowColor:[UIColor blackColor].CGColor];
        [[self.cellView layer] setShadowOpacity:0.34f];
        [[self.cellView layer] setShadowRadius:3.0f];
        [[self.cellView layer] setShadowOffset:CGSizeMake(0, 1)];
        self.cellView.layer.shouldRasterize = YES;
        self.cellView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [self addSubview:self.cellView];
        self.placeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 11, 16)];
        self.placeIconImageView.image = [UIImage imageNamed:@"place_icon"];
        [self.placeIconImageView setOpaque:YES];
        [self.cellView addSubview:self.placeIconImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 14, 260, 14)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.nameLabel.text = [activity.provider full_name];
        [self.nameLabel setOpaque:YES];
        [self.cellView addSubview:self.nameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    self.nameLabel.textColor = selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"999999"];
    self.cellView.backgroundColor = selected ? [UIColor grayColor] : [UIColor whiteColor];
    [UIView commitAnimations];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    // Configure the view for the selected state
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    self.nameLabel.textColor = highlighted ? [UIColor whiteColor] : [UIColor colorWithHexString:@"999999"];
    self.cellView.backgroundColor = highlighted ? [UIColor colorWithHexString:@"999999"] : [UIColor whiteColor];
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(CGFloat)cellHeight{
    return 40;
}

@end