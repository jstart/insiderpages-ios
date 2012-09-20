//
//  IPIActivityTableViewCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIActivityTableViewCell.h"
#import "IPKActivity+Formatting.h"

@implementation IPIActivityTableViewCell

@synthesize activity = _activity;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        
        self.activityLabel.text = [activity attributedActionText];
        [self.profileImageView setImage:[UIImage imageNamed:@"reload-button"]];
        [self.profileImageView setPathToNetworkImage:[activity.user imageProfilePathForSize:IPKUserProfileImageSizeMedium] forDisplaySize:self.profileImageView.frame.size contentMode:UIViewContentModeCenter];
//        self.timeLabel.text = [activity formattedTimeElapsedSinceUpdated];
        [self setNeedsLayout];
    }
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.profileImageView = [[NINetworkImageView alloc] initWithImage:[UIImage imageNamed:@"reload-button"]];
        self.profileImageView.layer.borderWidth = 1;
        self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.profileImageView setFrame:CGRectMake(15, 7.5, 40, 40)];
        [self.profileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
        [self addSubview:self.profileImageView];
        
        self.activityLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(60, 15, 240, 50)];
        self.activityLabel.backgroundColor = [UIColor clearColor];
        self.activityLabel.numberOfLines = 3;
        self.activityLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        self.activityLabel.contentMode = UIViewContentModeCenter;
        [self addSubview:self.activityLabel];
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
    textLabelFrame.origin.x = 60;
    self.activityLabel.frame = textLabelFrame;

}

+(CGFloat)heightForCellWithText:(NSString *)text{
    return 55;
}


@end
