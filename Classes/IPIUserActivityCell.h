//
//  IPIUserActivityCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIAbstractActivityCell.h"
#import "TTTAttributedLabel.h"
#import "NINetworkImageView.h"

@interface IPIUserActivityCell : IPIAbstractActivityCell

@property (nonatomic, strong) IPKActivity *activity;
@property (nonatomic, strong) TTTAttributedLabel *activityLabel;
@property (nonatomic, strong) NINetworkImageView * profileImageView;
@property (nonatomic, strong) NINetworkImageView * otherProfileImageView;

@end
