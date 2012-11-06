//
//  IPIUserTableViewHeader
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIUserTableViewHeader.h"
#import "UIColor-Expanded.h"

@implementation IPIUserTableViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Section margin
        self.pageCoverImageView = [[NINetworkImageView alloc] initWithFrame:frame];
        [self addSubview:self.pageCoverImageView];
        
        CGRect profileFrame = CGRectMake(10, 43, 44, 44);
        self.creatorProfileImageView = [[NINetworkImageView alloc] initWithFrame:profileFrame];
        [self.creatorProfileImageView.layer setBorderWidth:1];
        [self.creatorProfileImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self addSubview:self.creatorProfileImageView];
        
        CGRect overlayFrame = frame;
        overlayFrame.size.height = 93;
        overlayFrame.origin.x = 0;
        overlayFrame.origin.y = frame.size.height - 93;
        
        self.overlayView = [[UIView alloc] initWithFrame:overlayFrame];
        self.overlayView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"shadow_piece"]];
        [self.pageCoverImageView addSubview:self.overlayView];
        
        CGRect nameLabelFrame;
        nameLabelFrame.size.height = 22;
        nameLabelFrame.size.width = 230;
        nameLabelFrame.origin.y = self.pageCoverImageView.frame.size.height * .68;
        nameLabelFrame.origin.x = 10;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
        self.nameLabel.font = [UIFont fontWithName:@"Comfortaa" size:18];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.nameLabel];
        
        CGRect creatorLabelFrame = nameLabelFrame;
        creatorLabelFrame.origin.y = creatorLabelFrame.origin.y + 18;
        
        self.creatorLabel = [[UILabel alloc] initWithFrame:creatorLabelFrame];
        self.creatorLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:13];
        self.creatorLabel.textColor = [UIColor whiteColor];
        [self.creatorLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.creatorLabel];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.followButton setAdjustsImageWhenHighlighted:YES];
        [self.followButton setUserInteractionEnabled:YES];
        [self.followButton setFrame:CGRectMake(240, frame.size.height - 45, 65, 28)];
        [self.followButton setBackgroundColor:[[UIColor colorWithHexString:@"009999"] colorWithAlphaComponent:0.63]];
        [self.followButton setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
        [self.followButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.followButton.titleLabel setFont:[UIFont fontWithName:@"Myriad Web Pro" size:12]];
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        [self.followButton setTitle:@"Following" forState:UIControlStateSelected];
        [self.followButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.followButton addTarget:self action:@selector(followButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.followButton];
        
        }

    return self;
}

-(void)followButtonPressed{
    [self.delegate followButtonPressed:self.user];
    if (!self.followButton.selected) {
        [self.followButton setSelected:YES];
    }
    else if (self.followButton.selected) {
        [self.followButton setSelected:NO];
    }
}

-(void)setUser:(IPKUser *)user{
    _user = user;
    [self.nameLabel setText:user.name];
    [self.creatorLabel setText:user.about_me];
    //load image view with URL
    [self.pageCoverImageView setPathToNetworkImage:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg" forDisplaySize:self.pageCoverImageView.frame.size contentMode:UIViewContentModeCenter];
    [self.creatorProfileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
    [self.creatorProfileImageView setPathToNetworkImage:[self.user imageProfilePathForSize:IPKUserProfileImageSizeMedium] forDisplaySize:self.creatorProfileImageView.frame.size contentMode:UIViewContentModeCenter];
    IPKUser * currentUser = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSSet * filteredSet = [_user.followers filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"remoteID == %@", currentUser.remoteID]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (filteredSet.count > 0) {
            [self.followButton setSelected:YES];
        }else{
            [self.followButton setSelected:NO];
        }

        if (_user == [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
            [self.followButton setHidden:YES];
        }
        [self.followButton setNeedsDisplay];
    });
}

- (void)setOverlayColor:(UIColor *)overlayColor {
    self.overlayView.backgroundColor = overlayColor;
}

- (void)setNameTextLabelFont:(UIFont *)detailTextLabelFont {
    self.nameLabel.font = detailTextLabelFont;
}

- (void)setNameTextLabelColor:(UIColor *)nameTextLabelColor {
    self.nameLabel.textColor = nameTextLabelColor;
}

-(void)dealloc{
    self.delegate = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
