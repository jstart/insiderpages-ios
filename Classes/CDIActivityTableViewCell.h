//
//  CDIListTableViewCell.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITableViewCell.h"
#import "NINetworkImageView.h"

@interface CDIActivityTableViewCell : CDITableViewCell

@property (nonatomic, strong) IPKActivity *activity;
@property (nonatomic, strong) NINetworkImageView * profileImageView;
@end
