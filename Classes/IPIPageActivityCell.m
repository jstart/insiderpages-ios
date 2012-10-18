//
//  IPIPageActivityCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIPageActivityCell.h"
#import "NINetworkImageView.h"
#import "NYXImagesKit.h"
#import "UIImageView+Rasterize.h"

@implementation IPIPageActivityCell

@synthesize activity = _activity;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        self.nameLabel.text = activity.page.name;
        NSString *URLString = @"http://studentaffairs.duke.edu/sites/default/files/u60/coffee%20pic.jpeg";
        UIImageView * shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_shadow"]];
        CGRect shadowFrame = shadowImageView.frame;
        shadowFrame.origin.y = 2;
        [shadowImageView setFrame:shadowFrame];
        NSArray * subviews = @[shadowImageView, self.nameLabel];
        [self.coverImageView loadURLString:URLString forSize:self.coverImageView.frame.size withSubviews:subviews mode:NYXCropModeCenter];
    }
}

- (id)initWithActivity:(IPKActivity*)activity reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithActivity:activity reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        int leftPadding = 15;
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_unit_background"]];
        [[imageView layer] setMasksToBounds:YES];
        [imageView setFrame:CGRectMake(leftPadding, 0, 297, 157)];
        [self addSubview:imageView];
        
        UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(3, 2, 290, 150)];
        containerView.backgroundColor = [UIColor whiteColor];
        containerView.layer.cornerRadius = 4;
        [[containerView layer] setMasksToBounds:YES];
        [imageView addSubview:containerView];

        self.coverImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 110)];
        [containerView addSubview:self.coverImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 80, 270, 25)];
        self.nameLabel.text = activity.page.name;
        self.nameLabel.font = [UIFont fontWithName:@"Comfortaa" size:17];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
//        [containerView addSubview:self.nameLabel];]
        
        UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 290, 40)];
        [whiteView setBackgroundColor:[UIColor whiteColor]];
        [containerView addSubview:whiteView];
        
        self.placeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 120-110, 11, 16)];
        [self.placeIconImageView setImage:[UIImage imageNamed:@"places_icon_white"]];
        [whiteView addSubview:self.placeIconImageView];
        
        self.placeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 123-110, 130, 14)];
        self.placeNumberLabel.text = @"16 places";
        self.placeNumberLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.placeNumberLabel.backgroundColor = [UIColor whiteColor];
        [whiteView addSubview:self.placeNumberLabel];
        
        self.likeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(208, 124-110, 13, 12)];
        [self.likeIconImageView setImage:[UIImage imageNamed:@"insiders_icon_white"]];
        self.likeIconImageView.backgroundColor = [UIColor whiteColor];
        [whiteView addSubview:self.likeIconImageView];
        
        self.likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 124-110, 13, 14)];
        self.likeNumberLabel.text = @"16";
        self.likeNumberLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.likeNumberLabel.backgroundColor = [UIColor whiteColor];
        [whiteView addSubview:self.likeNumberLabel];
        
        self.commentIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 125-110, 13, 11)];
        [self.commentIconImageView setImage:[UIImage imageNamed:@"discus_icon_white"]];
        self.commentIconImageView.backgroundColor = [UIColor whiteColor];
        [whiteView addSubview:self.commentIconImageView];
        
        self.commentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(268, 124-110, 13, 14)];
        self.commentNumberLabel.text = @"16";
        self.commentNumberLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.commentNumberLabel.backgroundColor = [UIColor whiteColor];
        [whiteView addSubview:self.commentNumberLabel];
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


+(CGFloat)cellHeight{
    return 150;
}

@end
