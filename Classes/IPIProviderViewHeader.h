//
//  IPIProviderViewHeader.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPIProviderViewHeaderDelegate <NSObject>

-(void)addToPageButtonPressed:(IPKProvider*)provider;
-(void)addToDoButtonPressed:(IPKProvider*)provider;

@end

@interface IPIProviderViewHeader : UIView

@property (nonatomic, strong) UIImageView * overlayView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * categoryLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UILabel * address2Label;
@property (nonatomic, strong) UIButton * addToPageButton;
@property (nonatomic, strong) UIButton * addToDoButton;
@property (nonatomic, weak) id<IPIProviderViewHeaderDelegate> delegate;

@property (nonatomic, strong) IPKProvider * provider;

-(void)addToPageButtonPressed;
-(void)addToDoButtonPressed;

@end
