//
//  IPIPageCarouselView.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPIPageCarouselViewDelegate <NSObject>

-(void)followButtonPressed:(IPKPage*)page;

@end

@interface IPIPageCarouselView : UIView

@property (nonatomic, strong) NINetworkImageView * pageCoverImageView;
@property (nonatomic, strong) NINetworkImageView * creatorProfileImageView;

@property (nonatomic, strong) UIView * overlayView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, weak) id<IPIPageCarouselViewDelegate> delegate;

@property (nonatomic, strong) IPKPage * page;

-(void)followButtonPressed;

@end
