//
//  IPIUserBar
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/1/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPIUserBarDelegate <NSObject>

-(void)didSelectFollowers;

-(void)didSelectFollowing;

@end

@interface IPIUserBar : UIView

@property (nonatomic, assign) id <IPIUserBarDelegate> delegate;

@property (nonatomic, strong) UIImageView * backgroundView;
@property (nonatomic, strong) UILabel * pagesLabel;
@property (nonatomic, strong) UILabel * followersLabel;
@property (nonatomic, strong) UILabel * followersCountLabel;
@property (nonatomic, strong) UILabel * followingLabel;
@property (nonatomic, strong) UILabel * followingCountLabel;

@property (nonatomic, strong) IPKUser * user;

@end
