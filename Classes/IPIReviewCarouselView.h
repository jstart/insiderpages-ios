//
//  IPIReviewCarouselView.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPIReviewCarouselViewDelegate <NSObject>

-(void)followButtonPressed:(IPKReview*)review;

@end

@interface IPIReviewCarouselView : UIView

@property (nonatomic, strong) NINetworkImageView * creatorProfileImageView;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * reviewLabel;
@property (nonatomic, weak) id<IPIReviewCarouselViewDelegate> delegate;

@property (nonatomic, strong) IPKReview * review;

-(void)followButtonPressed;

@end
