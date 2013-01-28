//
//  IPIProviderActivityCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/21/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIAbstractActivityCell.h"

@interface IPIProviderActivityCell : IPIAbstractActivityCell

@property (nonatomic, strong) UIImageView * cellView;

@property (nonatomic, strong) UILabel * rankLabel;

@property (nonatomic, strong) UILabel * nameLabel;

@end
