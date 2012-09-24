//
//  IPIProviderActivityCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/21/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIAbstractActivityCell.h"

@interface IPIProviderActivityCell : IPIAbstractActivityCell

@property (nonatomic, strong) UIView * cellView;

@property (nonatomic, strong) UIImageView * placeIconImageView;

@property (nonatomic, strong) UILabel * nameLabel;

@end
