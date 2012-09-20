//
//  IPIPageTableViewHeader.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIPageTableViewHeader.h"

@implementation IPIPageTableViewHeader

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
        overlayFrame.size.height = overlayFrame.size.height * .47;
        overlayFrame.origin.x = 0;
        overlayFrame.origin.y = frame.size.height - overlayFrame.size.height;
        self.overlayView = [[UIView alloc] initWithFrame:overlayFrame];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0.6;
        [self.pageCoverImageView addSubview:self.overlayView];
        
        CGRect nameLabelFrame = overlayFrame;
        nameLabelFrame.size.height = nameLabelFrame.size.height * .50;
        nameLabelFrame.origin.x = 10;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.pageCoverImageView addSubview:self.nameLabel];
        
        //hacky way to draw an arrow
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathMoveToPoint(path,NULL,60.0,frame.size.height + 21);
//        CGPathAddLineToPoint(path, NULL, 70.0f, frame.size.height + 10);
//        CGPathAddLineToPoint(path, NULL, 80.0f, frame.size.height + 21);
//        
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        [shapeLayer setPath:path];
//        [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
//        [shapeLayer setBounds:frame];
//        [shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
//        [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
//        [[self layer] addSublayer:shapeLayer];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.followButton setUserInteractionEnabled:YES];
        [self.followButton setFrame:CGRectMake(10, frame.size.height - 50, 80, 40)];
        [self.followButton setAutoresizingMask:UIViewAutoresizingNone];
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
        [self.followButton setTitle:@"Unfollow" forState:UIControlStateSelected];
        [self.followButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.followButton addTarget:self action:@selector(followButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.followButton];

        self.favoriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.favoriteButton setUserInteractionEnabled:YES];
        [self.favoriteButton setFrame:CGRectMake(110, frame.size.height - 50, 80, 40)];
        [self.favoriteButton setAutoresizingMask:UIViewAutoresizingNone];
        [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
        [self.favoriteButton setTitle:@"Unfavorite" forState:UIControlStateSelected];
        [self.favoriteButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.favoriteButton addTarget:self action:@selector(favoriteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.favoriteButton];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.shareButton setUserInteractionEnabled:YES];
        [self.shareButton setFrame:CGRectMake(210, frame.size.height - 50, 80, 40)];
        [self.shareButton setAutoresizingMask:UIViewAutoresizingNone];
        [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
        [self.shareButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        [self.shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.shareButton];

        
        //hacky way to draw favorites corner overlay
//        frame.origin.x = frame.origin.x - 10;
//        CGMutablePathRef cornerPath = CGPathCreateMutable();
//        CGPathMoveToPoint(cornerPath,NULL,frame.size.width - 42.5,10);
//        CGPathAddLineToPoint(cornerPath, NULL, frame.size.width, 10);
//        CGPathAddLineToPoint(cornerPath, NULL, frame.size.width, 42.5);
//        
//        CAShapeLayer *cornerShapeLayer = [CAShapeLayer layer];
//        [cornerShapeLayer setPath:cornerPath];
//        [cornerShapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
//        [cornerShapeLayer setBounds:frame];
//        [cornerShapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
//        [cornerShapeLayer setPosition:CGPointMake(10.0f, 10.0f)];
//        [cornerShapeLayer setOpacity:0.85];
//        [[self layer] addSublayer:cornerShapeLayer];
        
        }

    return self;
}

-(void)followButtonPressed{
    [self.delegate followButtonPressed:self.page];
    if (!self.followButton.selected) {
        [self.followButton setSelected:YES];
    }
    else if (self.followButton.selected) {
        [self.followButton setSelected:NO];
    }
}

-(void)favoriteButtonPressed{
    [self.delegate favoriteButtonPressed:self.page];
    if (!self.favoriteButton.selected) {
        [self.favoriteButton setSelected:YES];
    }
    else if (self.favoriteButton.selected) {
        [self.favoriteButton setSelected:NO];
    }
}

-(void)shareButtonPressed{
    [self.delegate shareButtonPressed:self.page];
}

-(void)setPage:(IPKPage *)page{
//    if (_page != page && ![_page.owner.id isEqualToNumber:page.owner.id]) {
        _page = page;
        [self.nameLabel setText:page.name];
        //load image view with URL
        [self.pageCoverImageView setPathToNetworkImage:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg" forDisplaySize:self.pageCoverImageView.frame.size contentMode:UIViewContentModeCenter];
        [self.creatorProfileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];

        [self.creatorProfileImageView setPathToNetworkImage:[self.page.owner imageProfilePathForSize:IPKUserProfileImageSizeMedium] forDisplaySize:self.creatorProfileImageView.frame.size contentMode:UIViewContentModeCenter];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([page.is_following boolValue]) {
            [self.followButton setSelected:YES];
        }else{
            [self.followButton setSelected:NO];
        }
        if ([page.is_favorite boolValue]) {
            [self.favoriteButton setSelected:YES];
        }else{
            [self.favoriteButton setSelected:NO];
        }
        if (page.owner == [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
            [self.followButton setHidden:YES];
            [self.favoriteButton setHidden:YES];
        }
        [self.followButton setNeedsDisplay];
        [self.favoriteButton setNeedsDisplay];
    });
//    }
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
