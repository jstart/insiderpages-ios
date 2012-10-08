//
//  IPIRankBar.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/1/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIRankBar.h"

@implementation IPIRankBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_nav_background"]];
        CGRect backgroundViewFrame = self.backgroundView.frame;
        backgroundViewFrame.origin.y = 2;
        [self.backgroundView setFrame:backgroundViewFrame];
        [self.backgroundView setUserInteractionEnabled:YES];
        [self addSubview:self.backgroundView];
        
        self.profileImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(1, 4, 44, 44)];
        [self.backgroundView addSubview:self.profileImageView];
        
        self.rankButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rankButton.frame = CGRectMake(46, 4, 168, frame.size.height);
        [self.rankButton setBackgroundColor:[UIColor clearColor]];
        [self.rankButton addTarget:self action:@selector(didSelectRankSwitchButton) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.rankButton];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(56-44, 10, 130, 15)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:13];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.rankButton addSubview:self.nameLabel];
        
        self.rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(56-44, 25, 130, 15)];
        self.rankingLabel.backgroundColor = [UIColor clearColor];
        self.rankingLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:9];
        self.rankingLabel.textColor = [UIColor whiteColor];
        [self.rankButton addSubview:self.rankingLabel];
        
        self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop_down"]];
        CGRect arrowViewFrame = self.arrowView.frame;
        arrowViewFrame.origin.y = 20;
        arrowViewFrame.origin.x = 188-44;
        [self.arrowView setFrame:arrowViewFrame];
        [self.rankButton addSubview:self.arrowView];
        
        UIImageView * dividerView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider"]];
        CGRect dividerView1Frame = dividerView1.frame;
        dividerView1Frame.origin.y = 4;
        dividerView1Frame.origin.x = 45;
        [dividerView1 setFrame:dividerView1Frame];
        [self.backgroundView addSubview:dividerView1];
        
        UIImageView * dividerView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider"]];
        CGRect dividerView2Frame = dividerView2.frame;
        dividerView2Frame.origin.y = 4;
        dividerView2Frame.origin.x = 214;
        [dividerView2 setFrame:dividerView2Frame];
        [self.backgroundView addSubview:dividerView2];
        
        UIImageView * dividerView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider"]];
        CGRect dividerView3Frame = dividerView3.frame;
        dividerView3Frame.origin.y = 4;
        dividerView3Frame.origin.x = 267;
        [dividerView3 setFrame:dividerView3Frame];
        [self.backgroundView addSubview:dividerView3];
        
        self.likeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like_icon"]];
        CGRect likeViewFrame = self.likeView.frame;
        likeViewFrame.origin.y = 11;
        likeViewFrame.origin.x = 233;
        [self.likeView setFrame:likeViewFrame];
        [self.backgroundView addSubview:self.likeView];
        
        self.dislikeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dislike_icon"]];
        CGRect dislikeViewFrame = self.dislikeView.frame;
        dislikeViewFrame.origin.y = 11;
        dislikeViewFrame.origin.x = 286;
        [self.dislikeView setFrame:dislikeViewFrame];
        [self.backgroundView addSubview:self.dislikeView];
        
        self.likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(231, 31, 130, 15)];
        self.likeLabel.backgroundColor = [UIColor clearColor];
        self.likeLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:9];
        self.likeLabel.textColor = [UIColor whiteColor];
        [self.backgroundView addSubview:self.likeLabel];
        
        self.dislikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(285, 31, 130, 15)];
        self.dislikeLabel.backgroundColor = [UIColor clearColor];
        self.dislikeLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:9];
        self.dislikeLabel.textColor = [UIColor whiteColor];
        [self.backgroundView addSubview:self.dislikeLabel];
    }
    return self;
}

-(void)setSortUser:(IPKUser *)sortUser{
    _sortUser = sortUser;
    self.nameLabel.text = sortUser.name ? [NSString stringWithFormat:@"%@'s", sortUser.name] : @"Global Average";
    self.rankingLabel.text = @"Ranking";
    self.likeLabel.text = @"(456)";
    self.dislikeLabel.text = @"(105)";
    [self.profileImageView prepareForReuse];
    [self.profileImageView setPathToNetworkImage:[sortUser imageProfilePathForSize:IPKUserProfileImageSizeMedium] forDisplaySize:self.profileImageView.frame.size contentMode:UIViewContentModeScaleToFill];
}

-(void)didSelectRankSwitchButton{
    [self.delegate didSelectRankingSwitch];
}

@end
