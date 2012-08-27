//
//  IPIProviderViewHeader.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPIProviderViewHeaderDelegate <NSObject>

-(void)callButtonPressed:(IPKProvider*)provider;
-(void)directionButtonPressed:(IPKProvider*)provider;
-(void)shareButtonPressed:(IPKProvider*)provider;
-(void)addToPageButtonPressed:(IPKProvider*)provider;

@end

@interface IPIProviderViewHeader : UIView

@property (nonatomic, strong) UIView * overlayView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * callButton;
@property (nonatomic, strong) UIButton * directionsButton;
@property (nonatomic, strong) UIButton * shareButton;
@property (nonatomic, strong) UIButton * addToPageButton;
@property (nonatomic, weak) id<IPIProviderViewHeaderDelegate> delegate;

@property (nonatomic, strong) IPKProvider * provider;

-(void)callButtonPressed;
-(void)directionButtonPressed;
-(void)shareButtonPressed;
-(void)addToPageButtonPressed;

@end
