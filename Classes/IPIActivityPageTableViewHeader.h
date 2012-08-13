//
//  IPIActivityPageTableViewHeader.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPIActivityTableViewHeaderDelegate <NSObject>

-(void)favoriteButtonPressed:(IPKPage*)page;

@end

@interface IPIActivityPageTableViewHeader : UIView

@property (nonatomic, strong) NINetworkImageView * pageCoverImageView;
@property (nonatomic, strong) UIView * overlayView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * favoriteButton;
@property (nonatomic, assign) id<IPIActivityTableViewHeaderDelegate> delegate;

@property (nonatomic, strong) IPKPage * page;

-(void)favoriteButtonPressed;

@end
