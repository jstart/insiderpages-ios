//
//  IPIIconCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/19/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIIconCell.h"

@implementation IPIIconCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:17];
        self.textLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 38;
    [self.textLabel setFrame:frame];
}

+(CGFloat)cellHeight{
    return 44;
}

@end
