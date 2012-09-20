//
//  IPIPullOutUserCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/18/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIPullOutUserCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"

@implementation IPIPullOutUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.profileImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(10, 22, 44, 44)];
        self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileImageView.layer.borderWidth = 1;
        [self addSubview:self.profileImageView];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:19];
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
    self.textLabel.center = CGPointMake(0, self.profileImageView.center.y);

    CGRect frame = self.textLabel.frame;
    frame.origin.x = 63;
    frame.origin.y = 36;
    frame.size.width = 320 - 63;
//    frame.size.height = 40;
    [self.textLabel setFrame:frame];
}

+(CGFloat)cellHeight{
    return 90;
}

@end
