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
        overlayFrame.size.height = 96;
        overlayFrame.origin.x = 0;
        overlayFrame.origin.y = frame.size.height - overlayFrame.size.height;
        self.overlayView = [[UIImageView alloc] initWithFrame:overlayFrame];
        self.overlayView.image = [UIImage imageNamed:@"header_shadow"];
        [self addSubview:self.overlayView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 69, 234, 20)];
        self.nameLabel.font = [UIFont fontWithName:@"Comfortaa" size:17];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.nameLabel];
        
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 88, 234, 20)];
        self.categoryLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:13];
        self.categoryLabel.textColor = [UIColor whiteColor];
        [self.categoryLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.categoryLabel];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 111, 234, 20)];
        self.addressLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:13];
        self.addressLabel.textColor = [UIColor whiteColor];
        [self.addressLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.addressLabel];
        
        self.address2Label = [[UILabel alloc] initWithFrame:CGRectMake(16, 125, 234, 20)];
        self.address2Label.font = [UIFont fontWithName:@"Myriad Web Pro" size:13];
        self.address2Label.textColor = [UIColor whiteColor];
        [self.address2Label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.address2Label];
        
        self.addToPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addToPageButton.titleLabel setFont:[UIFont fontWithName:@"Myriad Web Pro" size:13]];
        [self.addToPageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addToPageButton setBackgroundColor:UIColorFromRGB(0x2f8f8d)];
        [self.addToPageButton setAlpha:0.8];
        [self.addToPageButton setUserInteractionEnabled:YES];
        [self.addToPageButton setFrame:CGRectMake(235, 73, 70, 29)];
        [self.addToPageButton setAutoresizingMask:UIViewAutoresizingNone];
        [self.addToPageButton setTitle:@"+Page" forState:UIControlStateNormal];
        [self.addToPageButton addTarget:self action:@selector(addToPageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addToPageButton];
        
        self.addToDoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addToDoButton.titleLabel setFont:[UIFont fontWithName:@"Myriad Web Pro" size:13]];
        [self.addToDoButton setBackgroundColor:UIColorFromRGB(0x2f8f8d)];
        [self.addToDoButton setAlpha:0.8];
        [self.addToDoButton setUserInteractionEnabled:YES];
        [self.addToDoButton setFrame:CGRectMake(235, 107, 70, 29)];
        [self.addToDoButton setAutoresizingMask:UIViewAutoresizingNone];
        [self.addToDoButton setTitle:@"+ToDo" forState:UIControlStateNormal];
        [self.addToDoButton addTarget:self action:@selector(addToDoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addToDoButton];
    }

    return self;
}

-(void)addToPageButtonPressed{
    [self.delegate addToPageButtonPressed:self.provider];
}

-(void)addToDoButtonPressed{
    [self.delegate addToDoButtonPressed:self.provider];
}

-(void)setProvider:(IPKProvider *)provider{
    _provider = provider;
    [self.nameLabel setText:provider.full_name];
//        [self.categoryLabel setText:provider]
    [self.addressLabel setText:provider.address.address_1];
    NSString * address2String = [provider.address.city stringByAppendingString:[NSString stringWithFormat:@", %@ ", provider.address.zip_code]];
    [self.address2Label setText:address2String];
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
