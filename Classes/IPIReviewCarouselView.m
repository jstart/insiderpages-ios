//
//  IPIReviewCarouselView.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIReviewCarouselView.h"

@implementation IPIReviewCarouselView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect profileFrame = CGRectMake(7.5, frame.size.height*0.84, 22, 22);
        self.creatorProfileImageView = [[NINetworkImageView alloc] initWithFrame:profileFrame];
        [self.creatorProfileImageView.layer setBorderWidth:1];
        [self.creatorProfileImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self addSubview:self.creatorProfileImageView];
        
        float paddingForNameLabel = profileFrame.origin.x + profileFrame.size.width + 10;
        CGRect nameLabelFrame = CGRectMake(paddingForNameLabel + 10, profileFrame.origin.y, frame.size.height-(paddingForNameLabel + 10), 22);
        
        self.nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.nameLabel];
        
        UIView * dividerView = [[UIView alloc] initWithFrame:CGRectMake(10, frame.size.height*0.82, frame.size.width-20, 1)];
        dividerView.layer.shadowOffset = CGSizeMake(1, 1);
        dividerView.layer.shadowColor = [UIColor blackColor].CGColor;
        dividerView.layer.shadowOpacity = 0.5;
        [dividerView setBackgroundColor:[UIColor grayColor]];
        [self addSubview:dividerView];
        
        CGRect reviewLabelFrame = CGRectMake(14, 18, frame.size.width-28, frame.size.height*0.84-36);
        self.reviewLabel = [[UILabel alloc] initWithFrame:reviewLabelFrame];
        [self.reviewLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.reviewLabel setNumberOfLines:0];
        self.reviewLabel.textColor = [UIColor grayColor];
        [self.reviewLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.reviewLabel];
    }

    return self;
}

-(void)followButtonPressed{
    [self.delegate followButtonPressed:self.review];
}

-(void)setReview:(IPKReview *)review{
        _review = review;
        [self.nameLabel setText:review.reviewer.name];
        [self.reviewLabel setText:review.why_recommended];
        //load image view with URL
    if (self.review.reviewer.image_profile_path) {
        [self.creatorProfileImageView setPathToNetworkImage:[self.review.reviewer imageProfilePathForSize:IPKUserProfileImageSizeMedium] forDisplaySize:self.creatorProfileImageView.frame.size contentMode:UIViewContentModeCenter];
    }else{
        [self.creatorProfileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
    }
        
}

-(void)dealloc{
    self.delegate = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
