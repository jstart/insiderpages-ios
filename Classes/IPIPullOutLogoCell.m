//
//  IPIPullOutLogoCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/19/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIPullOutLogoCell.h"

@implementation IPIPullOutLogoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(51, 35, 163, 46)];
        self.logoImageView.image = [UIImage imageNamed:@"IP_logo"];
        [self addSubview:self.logoImageView];
        self.byImageView = [[UIImageView alloc] initWithFrame:CGRectMake(122, 83, 21, 18)];
        self.byImageView.image = [UIImage imageNamed:@"by"];
        [self addSubview:self.byImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeight{
    return (245/2);
}

@end
