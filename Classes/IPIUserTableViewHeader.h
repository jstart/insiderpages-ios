//
//  IPIUserTableViewHeader
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//


@protocol IPIUserTableViewHeaderDelegate <NSObject>

-(void)followButtonPressed:(IPKUser*)user;

@end

@interface IPIUserTableViewHeader : UIView

@property (nonatomic, strong) NINetworkImageView * pageCoverImageView;
@property (nonatomic, strong) NINetworkImageView * creatorProfileImageView;

@property (nonatomic, strong) UIView * overlayView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * creatorLabel;
@property (nonatomic, strong) UIButton * followButton;
@property (nonatomic, weak) id<IPIUserTableViewHeaderDelegate> delegate;

@property (nonatomic, strong) IPKUser * user;

- (void)setOverlayColor:(UIColor *)overlayColor UI_APPEARANCE_SELECTOR;
- (void)setNameTextLabelFont:(UIFont *)detailTextLabelFont UI_APPEARANCE_SELECTOR;
- (void)setNameTextLabelColor:(UIColor *)nameTextLabelColor UI_APPEARANCE_SELECTOR;

-(void)followButtonPressed;

@end
