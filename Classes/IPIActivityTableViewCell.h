//
//  CDIListTableViewCell.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITableViewCell.h"
#import "NINetworkImageView.h"

@interface IPIActivityTableViewCell : CDITableViewCell

@property (nonatomic, strong) IPKActivity *activity;
@property (nonatomic, strong) NINetworkImageView * profileImageView;
@property (nonatomic, strong) UILabel * timeLabel;

@end
