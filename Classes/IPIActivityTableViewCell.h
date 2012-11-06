//
//  IPIActivityTableViewCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//
#import "IPIAbstractActivityCell.h"
#import "TTTAttributedLabel.h"

@interface IPIActivityTableViewCell : IPIAbstractActivityCell

@property (nonatomic, strong) IPKActivity *activity;
@property (nonatomic, strong) TTTAttributedLabel *activityLabel;
@property (nonatomic, strong) NINetworkImageView * profileImageView;
//@property (nonatomic, strong) UILabel * timeLabel;

+(CGFloat)heightForCellWithText:(NSString *)text;

@end
