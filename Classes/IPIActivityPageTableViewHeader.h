//
//  IPIActivityPageTableViewHeader.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPIActivityPageTableViewHeader : UIView

@property (nonatomic, strong) NINetworkImageView * pageCoverImageView;
@property (nonatomic, strong) UIView * overlayView;
@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) IPKPage * page;

@end
