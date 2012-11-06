//
//  IPIPageActivityCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIAbstractActivityCell.h"
#import "NINetworkImageView.h"

@interface IPIPageActivityCell : IPIAbstractActivityCell

@property (nonatomic, strong) IPKPage * page;

@property (strong, nonatomic) NINetworkImageView * coverImageView;
@property (strong, nonatomic) UILabel * nameLabel;
@property (strong, nonatomic) UIImageView * placeIconImageView;
@property (strong, nonatomic) UILabel * placeNumberLabel;
@property (strong, nonatomic) UIImageView * likeIconImageView;
@property (strong, nonatomic) UILabel * likeNumberLabel;
@property (strong, nonatomic) UIImageView * commentIconImageView;
@property (strong, nonatomic) UILabel * commentNumberLabel;

@end
