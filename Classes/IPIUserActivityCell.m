//
//  IPIUserActivityCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIUserActivityCell.h"
#import "IPKActivity+Formatting.h"

@implementation IPIUserActivityCell

@synthesize activity = _activity;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        
        self.activityLabel.text = [activity attributedActionText];
        [self.profileImageView prepareForReuse];
        [self.profileImageView setPathToNetworkImage:[activity.user imageProfilePathForSize:IPKUserProfileImageSizeMedium] forDisplaySize:self.profileImageView.frame.size contentMode:UIViewContentModeScaleToFill];
        [self.otherProfileImageView prepareForReuse];
        [self.otherProfileImageView setPathToNetworkImage:[activity.user2 imageProfilePathForSize:IPKUserProfileImageSizeMedium] forDisplaySize:self.profileImageView.frame.size contentMode:UIViewContentModeScaleToFill];
        //        self.timeLabel.text = [activity formattedTimeElapsedSinceUpdated];
        [self setNeedsLayout];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.profileImageView = [[NINetworkImageView alloc] initWithImage:[UIImage imageNamed:@"reload-button"]];
        self.profileImageView.layer.borderWidth = 1;
        self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.profileImageView setFrame:CGRectMake(0, 7.5, 45, 45)];
        [self.profileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
        
        UIView * profileView = [[UIView alloc] initWithFrame:self.profileImageView.frame];
        [[profileView layer] setMasksToBounds:NO];
        [[profileView layer] setShadowColor:[UIColor blackColor].CGColor];
        [[profileView layer] setShadowOpacity:0.34f];
        [[profileView layer] setShadowRadius:2.0f];
        [[profileView layer] setShadowOffset:CGSizeMake(0, 2)];
        
        CGRect profileFrame = profileView.frame;
        profileFrame.origin.x = 15;
        profileFrame.origin.y = 0;
        profileView.frame = profileFrame;
        
        [profileView addSubview:self.profileImageView];
        [self addSubview:profileView];
        
        self.activityLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(64, 15, 170, 45)];
        self.activityLabel.backgroundColor = [UIColor clearColor];
        self.activityLabel.numberOfLines = 3;
        self.activityLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
        self.activityLabel.contentMode = UIViewContentModeBottom;
        [self addSubview:self.activityLabel];
        
        self.otherProfileImageView = [[NINetworkImageView alloc] initWithImage:[UIImage imageNamed:@"reload-button"]];
        self.otherProfileImageView.layer.borderWidth = 1;
        self.otherProfileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.otherProfileImageView setFrame:CGRectMake(0, 0, 45, 45)];
        [self.otherProfileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
        
        UIView * otherProfileView = [[UIView alloc] initWithFrame:self.otherProfileImageView.frame];
        [[otherProfileView layer] setMasksToBounds:NO];
        [[otherProfileView layer] setShadowColor:[UIColor blackColor].CGColor];
        [[otherProfileView layer] setShadowOpacity:0.34f];
        [[otherProfileView layer] setShadowRadius:2.0f];
        [[otherProfileView layer] setShadowOffset:CGSizeMake(2, 2)];
        
        CGRect otherProfileViewFrame = otherProfileView.frame;
        otherProfileViewFrame.origin.x = 259;
        otherProfileViewFrame.origin.y = 0;
        otherProfileView.frame = otherProfileViewFrame;
        
        [otherProfileView addSubview:self.otherProfileImageView];
        [self addSubview:otherProfileView];
        
        //        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 5, 80, 20)];
        //        self.timeLabel.backgroundColor = [UIColor clearColor];
        //        [self.timeLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        //        [self addSubview:self.timeLabel];
	}
	return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.activityLabel.center = CGPointMake(0, self.profileImageView.center.y);
    CGRect textLabelFrame = self.activityLabel.frame;
    textLabelFrame.origin.x = 64;
    self.activityLabel.frame = textLabelFrame;
    
    [self.otherProfileImageView setCenter:CGPointMake(0, self.profileImageView.center.y)];
    CGRect smallPageCoverFrame = self.otherProfileImageView.frame;
    smallPageCoverFrame.origin.x = 259;
    self.otherProfileImageView.frame = smallPageCoverFrame;
}

+(CGFloat)heightForCellWithText:(NSString *)text{
    return 55;
}

@end
