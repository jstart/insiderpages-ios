//
//  IPIProviderActivityCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIMiniPageActivityCell.h"
#import "IPKActivity+Formatting.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIImageView+Rasterize.h"

@implementation IPIMiniPageActivityCell
@synthesize activity = _activity, delegate = _delegate;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        
        self.activityLabel.text = [activity attributedActionText];

        NSString *profileImageViewURLString = [activity.user imageProfilePathForSize:IPKUserProfileImageSizeMedium];
        [self.profileImageView loadURLString:profileImageViewURLString forSize:self.profileImageView.frame.size mode:NYXCropModeCenter];
        
        NSString* URLString = @"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg";
        [self.smallPageCoverImageView loadURLString:URLString forSize:self.smallPageCoverImageView.frame.size mode:NYXCropModeCenter];
        
        [self setNeedsDisplay];
    }
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.backgroundColor = [UIColor standardBackgroundColor];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.profileImageView = [[NINetworkImageView alloc] initWithImage:[UIImage imageNamed:@"reload-button"]];
        self.profileImageView.layer.borderWidth = 1;
        self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.profileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
        [self.profileImageView setFrame:CGRectMake(0, 0, 45, 45)];
        [self.profileImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectUser)];
        [self.profileImageView addGestureRecognizer:tapGestureRecognizer];
        
        CGRect profileFrame = self.profileImageView.frame;
        profileFrame.origin.x = 15;
        profileFrame.origin.y = 0;

        UIView * profileView = [[UIView alloc] initWithFrame:profileFrame];
        [[profileView layer] setMasksToBounds:NO];
        [[profileView layer] setShadowColor:[UIColor blackColor].CGColor];
        [[profileView layer] setShadowOpacity:0.34f];
        [[profileView layer] setShadowRadius:2.0f];
        [[profileView layer] setShadowOffset:CGSizeMake(0, 2)];
                
        [profileView addSubview:self.profileImageView];
        
        [self addSubview:profileView];
        
        self.activityLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(64, 0, 170, 45)];
        self.activityLabel.backgroundColor = [UIColor standardBackgroundColor];
        self.activityLabel.numberOfLines = 3;
        self.activityLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
        self.activityLabel.contentMode = UIViewContentModeBottom;
        [self addSubview:self.activityLabel];
        
        self.smallPageCoverImageView = [[NINetworkImageView alloc] initWithImage:[UIImage imageNamed:@"reload-button"]];
        self.smallPageCoverImageView.layer.cornerRadius = 4;
        [self.smallPageCoverImageView.layer setMasksToBounds:YES];
        [self.smallPageCoverImageView setFrame:CGRectMake(0, 0, 69, 45)];
        [self.smallPageCoverImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
        
        UIView * roundedView = [[UIView alloc] initWithFrame:self.smallPageCoverImageView.frame];
        [[roundedView layer] setMasksToBounds:NO];
        [[roundedView layer] setShadowColor:[UIColor blackColor].CGColor];
        [[roundedView layer] setShadowOpacity:0.34f];
        [[roundedView layer] setShadowRadius:2.0f];
        [[roundedView layer] setShadowOffset:CGSizeMake(2, 2)];
        
        CGRect frame = roundedView.frame;
        frame.origin.x = 235;
        roundedView.frame = frame;
        
        [roundedView addSubview:self.smallPageCoverImageView];
        
        [self addSubview:roundedView];
        
        //        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 5, 80, 20)];
        //        self.timeLabel.backgroundColor = [UIColor clearColor];
        //        [self.timeLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        //        [self addSubview:self.timeLabel];
	}
	return self;
}

//- (void) layoutSubviews {
//    [super layoutSubviews];
////    self.activityLabel.center = CGPointMake(0, self.profileImageView.center.y);
////    CGRect textLabelFrame = self.activityLabel.frame;
////    textLabelFrame.origin.x = 64;
////    self.activityLabel.frame = textLabelFrame;
////    
////    [self.smallPageCoverImageView setCenter:CGPointMake(0, self.profileImageView.center.y)];
////    CGRect smallPageCoverFrame = self.smallPageCoverImageView.frame;
////    smallPageCoverFrame.origin.x = 235;
////    self.smallPageCoverImageView.frame = smallPageCoverFrame;
//}

+(CGFloat)heightForCellWithText:(NSString *)text{
    return 55;
}

-(void)didSelectUser{
    if (self.delegate) {
        [self.delegate didSelectUser:self.activity.user];
    }
}

-(void)setDelegate:(id<IPIAbstractActivityCellDelegate>)delegate{
    _delegate = delegate;
}


@end
