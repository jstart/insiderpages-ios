//
//  IPIRankPageActivityCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 11/5/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//
#import "IPIAbstractActivityCell.h"

@interface IPIRankPageActivityCell : IPIAbstractActivityCell

@property (nonatomic, strong) IPKActivity * activity;
@property (nonatomic, strong) NSMutableArray * providerCellArray;

+(CGFloat)cellHeightForActivity:(IPKActivity *)activity;

@end
