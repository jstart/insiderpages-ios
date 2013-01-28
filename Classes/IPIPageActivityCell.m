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
#import "UIColor-Expanded.h"

@implementation IPIPageActivityCell

@synthesize activity = _activity, page = _page;

- (void)setPage:(IPKPage *)page {
    if (_page != page) {
        _page = page;
        self.nameLabel.text = page.name;
        self.descriptionLabel.text = page.description_text;
    }
}

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        self.nameLabel.text = activity.page.name;
        self.descriptionLabel.text = activity.page.description_text;
    }
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page_description_background"]];
        [imageView setFrame:CGRectMake(48, 0, 264, 138)];
        [self addSubview:imageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 254, 25)];
        self.nameLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:20];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [imageView addSubview:self.nameLabel];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 56, 245, 25)];
        self.descriptionLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:20];
        self.descriptionLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.descriptionLabel.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [imageView addSubview:self.descriptionLabel];
        
        self.placeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(153, 101, 19, 19)];
        [self.placeIconImageView setImage:[UIImage imageNamed:@"place_icon"]];
        self.placeIconImageView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [imageView addSubview:self.placeIconImageView];
        
        self.placeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(174, 108, 13, 14)];
        self.placeNumberLabel.text = @"16";
        self.placeNumberLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.placeNumberLabel.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [imageView addSubview:self.placeNumberLabel];
        
        self.followerIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(188, 101, 19, 19)];
        [self.followerIconImageView setImage:[UIImage imageNamed:@"insiders_icon"]];
        self.followerIconImageView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [imageView addSubview:self.followerIconImageView];
        
        self.followerNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(209, 108, 13, 14)];
        self.followerNumberLabel.text = @"16";
        self.followerNumberLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.followerNumberLabel.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [imageView addSubview:self.followerNumberLabel];
        
        self.commentIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(217, 101, 19, 19)];
        [self.commentIconImageView setImage:[UIImage imageNamed:@"comment_icon"]];
        self.commentIconImageView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [imageView addSubview:self.commentIconImageView];
        
        self.commentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(238, 108, 13, 14)];
        self.commentNumberLabel.text = @"16";
        self.commentNumberLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.commentNumberLabel.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [imageView addSubview:self.commentNumberLabel];
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
