//
//  IPIPullOutLogoCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/19/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPIPullOutLogoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *byImageView;

+(CGFloat)cellHeight;

@end
