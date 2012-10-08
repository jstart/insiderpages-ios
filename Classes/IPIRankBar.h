//
//  IPIRankBar
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/1/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPIRankBarDelegate <NSObject>

-(void)didSelectRankingSwitch;

@end

@interface IPIRankBar : UIView

@property (nonatomic, assign) id <IPIRankBarDelegate> delegate;

@property (nonatomic, strong) UIImageView * backgroundView;
@property (nonatomic, strong) NINetworkImageView * profileImageView;

@property (nonatomic, strong) UIButton * rankButton;

@property (nonatomic, strong) UIImageView * arrowView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * rankingLabel;
@property (nonatomic, strong) UIImageView * likeView;
@property (nonatomic, strong) UIImageView * dislikeView;
@property (nonatomic, strong) UILabel * likeLabel;
@property (nonatomic, strong) UILabel * dislikeLabel;

@property (nonatomic, strong) IPKUser * sortUser;

@end
