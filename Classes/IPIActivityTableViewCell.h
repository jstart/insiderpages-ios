//
//  IPIActivityTableViewCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "TTTAttributedLabel.h"

@interface IPIActivityTableViewCell : UITableViewCell
@property (nonatomic, strong) IPKActivity *activity;
@property (nonatomic, strong) TTTAttributedLabel *activityLabel;
@property (nonatomic, strong) NINetworkImageView * profileImageView;
//@property (nonatomic, strong) UILabel * timeLabel;

+(CGFloat)heightForCellWithText:(NSString *)text;

@end
