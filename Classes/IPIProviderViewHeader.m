//
//  IPIProviderViewHeader.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0] 

#import "IPIProviderViewHeader.h"

@implementation IPIProviderViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Section margin
        self.backgroundColor = [UIColor clearColor];
        CGRect overlayFrame = frame;
        overlayFrame.size.height = overlayFrame.size.height * .47;
        overlayFrame.origin.x = 0;
        overlayFrame.origin.y = frame.size.height - overlayFrame.size.height;
        self.overlayView = [[UIView alloc] initWithFrame:overlayFrame];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0.6;
        [self addSubview:self.overlayView];
        
        CGRect nameLabelFrame = overlayFrame;
        nameLabelFrame.size.height = nameLabelFrame.size.height * .50;
        nameLabelFrame.origin.x = 10;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.nameLabel];
        
        self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.callButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.callButton setBackgroundColor:[UIColor blackColor]];
        [self.callButton setAlpha:0.7];
        [self.callButton setUserInteractionEnabled:YES];
        [self.callButton setFrame:CGRectMake(10, frame.size.height - 40, 40, 30)];
        [self.callButton setAutoresizingMask:UIViewAutoresizingNone];
        [self.callButton setTitle:@"Call" forState:UIControlStateNormal];
        [self.callButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.callButton addTarget:self action:@selector(callButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.callButton];

        self.directionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.directionsButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.directionsButton setBackgroundColor:[UIColor blackColor]];
        [self.directionsButton setAlpha:0.7];
        [self.directionsButton setUserInteractionEnabled:YES];
        [self.directionsButton setFrame:CGRectMake(60, frame.size.height - 40, 80, 30)];
        [self.directionsButton setAutoresizingMask:UIViewAutoresizingNone];
        [self.directionsButton setTitle:@"Directions" forState:UIControlStateNormal];
        [self.directionsButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.directionsButton addTarget:self action:@selector(directionButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.directionsButton];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.shareButton setBackgroundColor:[UIColor blackColor]];
        [self.shareButton setAlpha:0.7];
        [self.shareButton setUserInteractionEnabled:YES];
        [self.shareButton setFrame:CGRectMake(150, frame.size.height - 40, 50, 30)];
        [self.shareButton setAutoresizingMask:UIViewAutoresizingNone];
        [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
        [self.shareButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.shareButton];
        
        self.addToPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addToPageButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.addToPageButton setBackgroundColor:UIColorFromRGB(0x2f8f8d)];
        [self.addToPageButton setAlpha:0.8];
        [self.addToPageButton setUserInteractionEnabled:YES];
        [self.addToPageButton setFrame:CGRectMake(250, frame.size.height - 40, 50, 30)];
        [self.addToPageButton setAutoresizingMask:UIViewAutoresizingNone];
        [self.addToPageButton setTitle:@"+Page" forState:UIControlStateNormal];
        [self.addToPageButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.addToPageButton addTarget:self action:@selector(addToPageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addToPageButton];
        
        }

    return self;
}

-(void)callButtonPressed{
    [self.delegate callButtonPressed:self.provider];
}

-(void)directionButtonPressed{
    [self.delegate directionButtonPressed:self.provider];
}

-(void)shareButtonPressed{
    [self.delegate shareButtonPressed:self.provider];
}

-(void)addToPageButtonPressed{
    [self.delegate addToPageButtonPressed:self.provider];
}

-(void)setProvider:(IPKProvider *)provider{
//    if (_page != page && ![_page.owner.id isEqualToNumber:page.owner.id]) {
        _provider = provider;
        [self.nameLabel setText:provider.full_name];
        //load image view with URL

//        if ([page.is_following boolValue]) {
//            [self.followButton setSelected:YES];
//        }else{
//            [self.followButton setSelected:NO];
//        }
//        if ([page.is_favorite boolValue]) {
//            [self.favoriteButton setSelected:YES];
//        }else{
//            [self.favoriteButton setSelected:NO];
//        }
//        if (page.owner == [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
//            [self.followButton setHidden:YES];
//            [self.favoriteButton setHidden:YES];
//        }
//    }
}

- (void)setOverlayColor:(UIColor *)overlayColor {
    self.overlayView.backgroundColor = overlayColor;
}

- (void)setNameTextLabelFont:(UIFont *)detailTextLabelFont {
    self.nameLabel.font = detailTextLabelFont;
}

- (void)setNameTextLabelColor:(UIColor *)nameTextLabelColor {
    self.nameLabel.textColor = nameTextLabelColor;
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
