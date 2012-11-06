//
//  IPIUserBar.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/1/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIUserBar.h"

@implementation IPIUserBar

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
        
        self.pagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 18+4, 130, 15)];
        self.pagesLabel.backgroundColor = [UIColor clearColor];
        self.pagesLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:13];
        self.pagesLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.pagesLabel];
        
        self.followersLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 28+4, 70, 15)];
        self.followersLabel.textAlignment = NSTextAlignmentCenter;
        self.followersLabel.backgroundColor = [UIColor clearColor];
        self.followersLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:9];
        self.followersLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.followersLabel];
        
        self.followersCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 12+4, 70, 15)];
        self.followersCountLabel.backgroundColor = [UIColor clearColor];
        self.followersCountLabel.textAlignment = NSTextAlignmentCenter;
        self.followersCountLabel.font = [UIFont fontWithName:@"MyriadWebPro-Bold" size:13];
        self.followersCountLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.followersCountLabel];
        
        UIImageView * dividerView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider"]];
        CGRect dividerView2Frame = dividerView2.frame;
        dividerView2Frame.origin.y = 4;
        dividerView2Frame.origin.x = 180;
        [dividerView2 setFrame:dividerView2Frame];
        [self.backgroundView addSubview:dividerView2];
        
        UIImageView * dividerView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider"]];
        CGRect dividerView3Frame = dividerView3.frame;
        dividerView3Frame.origin.y = 4;
        dividerView3Frame.origin.x = 250;
        [dividerView3 setFrame:dividerView3Frame];
        [self.backgroundView addSubview:dividerView3];
        
        self.followingLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 28+4, 70, 15)];
        self.followingLabel.backgroundColor = [UIColor clearColor];
        [self.followingLabel setTextAlignment:NSTextAlignmentCenter];
        self.followingLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:9];
        self.followingLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.followingLabel];
        
        self.followingCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 12+4, 70, 15)];
        [self.followingCountLabel setTextAlignment:NSTextAlignmentCenter];
        self.followingCountLabel.backgroundColor = [UIColor clearColor];
        self.followingCountLabel.font = [UIFont fontWithName:@"MyriadWebPro-Bold" size:13];
        self.followingCountLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.followingCountLabel];
    }
    return self;
}

-(void)setUser:(IPKUser *)user{
    _user = user;
    self.pagesLabel.text = user.pages ? [NSString stringWithFormat:@"%d Pages", user.pages.count] : @"0 Pages";
    self.followersLabel.text = @"Followers";
    self.followersCountLabel.text = user.followers ? [NSString stringWithFormat:@"%d", user.followers.count] : @"0";
    self.followingLabel.text = @"Following";
    self.followingCountLabel.text = user.followedUsers ? [NSString stringWithFormat:@"%d", user.followedUsers.count] : @"0";
}

@end
