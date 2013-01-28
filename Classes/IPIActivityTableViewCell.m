//
//  IPIActivityTableViewCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIActivityTableViewCell.h"
#import "IPKActivity+Formatting.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "NYXImagesKit.h"
#import "UIImageView+Rasterize.h"

@implementation IPIActivityTableViewCell

@synthesize activity = _activity;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        
        self.activityLabel.text = [activity attributedActionText];

        NSString *profileImageViewURLString = [activity.user imageProfilePathForSize:IPKUserProfileImageSizeMedium];
        [self.profileImageView loadURLString:profileImageViewURLString forSize:self.profileImageView.frame.size mode:NYXCropModeCenter];
    }
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.profileImageView = [[NINetworkImageView alloc] initWithImage:[UIImage imageNamed:@"reload-button"]];
        [self.profileImageView setUserInteractionEnabled:YES];
        self.profileImageView.layer.borderWidth = 1;
        self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.profileImageView setFrame:CGRectMake(0, 0, 21, 21)];
        [self.profileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];

        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectUser)];
        [self.profileImageView addGestureRecognizer:tapGestureRecognizer];
        
        UIView * profileView = [[UIView alloc] initWithFrame:self.profileImageView.frame];
        [[profileView layer] setMasksToBounds:NO];
        [[profileView layer] setShadowColor:[UIColor blackColor].CGColor];
        [[profileView layer] setShadowOpacity:0.34f];
        [[profileView layer] setShadowRadius:2.0f];
        [[profileView layer] setShadowOffset:CGSizeMake(0, 2)];
        
        CGRect profileFrame = profileView.frame;
        profileFrame.origin.x = 16;
        profileFrame.origin.y = 28;
        profileView.frame = profileFrame;

        [profileView addSubview:self.profileImageView];
                
        [self addSubview:profileView];
        
        UIImageView * activityMessageView = [[UIImageView alloc] initWithFrame:CGRectMake(48, 0, 264, 69)];
        [activityMessageView setImage:[UIImage imageNamed:@"activity_box"]];
        
        [self addSubview:activityMessageView];
        
        self.activityLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(7, 11, 240, 45)];
        self.activityLabel.backgroundColor = [UIColor standardBackgroundColor];
        self.activityLabel.numberOfLines = 3;
        self.activityLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        self.activityLabel.contentMode = UIViewContentModeBottom;
        [activityMessageView addSubview:self.activityLabel];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 5, 80, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.timeLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        [self addSubview:self.timeLabel];
	}
	return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
//    self.activityLabel.center = CGPointMake(0, self.profileImageView.center.y);
//    CGRect textLabelFrame = self.activityLabel.frame;
//    textLabelFrame.origin.x = 64;
//    self.activityLabel.frame = textLabelFrame;
}

+(CGFloat)heightForCellWithText:(NSString *)text{
    return 55;
}

-(void)addSubview:(UIView *)view{
    if (view.frame.size.width != 1) {
        [super addSubview:view];
    }
}

-(void)didSelectUser{
    if (self.delegate) {
        [self.delegate didSelectUser:self.activity.user];
    }
}

@end
