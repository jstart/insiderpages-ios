//
//  IPIProviderActivityCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/21/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIProviderActivityCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIColor-Expanded.h"

@implementation IPIProviderActivityCell

@synthesize activity = _activity;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        
        self.nameLabel.text = [activity.provider full_name];
        //        self.timeLabel.text = [activity formattedTimeElapsedSinceUpdated];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        self.cellView = [[UIImageView alloc] initWithFrame:CGRectMake(48, 0, 264, 46)];
        [self.cellView setImage:[UIImage imageNamed:@"list_item_background"]];
        [self addSubview:self.cellView];
        
        self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, 21, 21)];
        self.rankLabel.backgroundColor = [UIColor colorWithHexString:@"666666"];
        self.rankLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:21];
        self.rankLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        [self.cellView addSubview:self.rankLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 15, 264-35, 14)];
        self.nameLabel.backgroundColor = [UIColor colorWithHexString:@"666666"];
        self.nameLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:13];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        [self.cellView addSubview:self.nameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.1];
//    self.nameLabel.textColor = selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"999999"];
//    self.cellView.backgroundColor = selected ? [UIColor grayColor] : [UIColor whiteColor];
//    [UIView commitAnimations];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    // Configure the view for the selected state
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.1];
//    self.nameLabel.textColor = highlighted ? [UIColor whiteColor] : [UIColor colorWithHexString:@"999999"];
//    self.cellView.backgroundColor = highlighted ? [UIColor colorWithHexString:@"999999"] : [UIColor whiteColor];
//    [UIView commitAnimations];
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
