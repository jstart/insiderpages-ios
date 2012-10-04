//
//  IPIActivityPageTableViewHeader.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPIPageTableViewHeaderDelegate <NSObject>

-(void)followButtonPressed:(IPKPage*)page;
-(void)favoriteButtonPressed:(IPKPage*)page;
-(void)shareButtonPressed:(IPKPage*)page;

@end

@interface IPIPageTableViewHeader : UIView

@property (nonatomic, strong) NINetworkImageView * pageCoverImageView;
//@property (nonatomic, strong) NINetworkImageView * creatorProfileImageView;

@property (nonatomic, strong) UIView * overlayView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * creatorLabel;
@property (nonatomic, strong) UIButton * followButton;
//@property (nonatomic, strong) UIButton * favoriteButton;
//@property (nonatomic, strong) UIButton * shareButton;
@property (nonatomic, weak) id<IPIPageTableViewHeaderDelegate> delegate;

@property (nonatomic, strong) IPKPage * page;

- (void)setOverlayColor:(UIColor *)overlayColor UI_APPEARANCE_SELECTOR;
- (void)setNameTextLabelFont:(UIFont *)detailTextLabelFont UI_APPEARANCE_SELECTOR;
- (void)setNameTextLabelColor:(UIColor *)nameTextLabelColor UI_APPEARANCE_SELECTOR;

-(void)followButtonPressed;
-(void)favoriteButtonPressed;
-(void)shareButtonPressed;

@end
