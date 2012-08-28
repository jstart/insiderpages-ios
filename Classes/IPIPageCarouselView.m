//
//  IPIPageCarouselView,m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIPageCarouselView.h"

@implementation IPIPageCarouselView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Section margin
        self.pageCoverImageView = [[NINetworkImageView alloc] initWithFrame:frame];
        [self addSubview:self.pageCoverImageView];
        
        CGRect profileFrame = CGRectMake(5, 5, 44, 44);
        self.creatorProfileImageView = [[NINetworkImageView alloc] initWithFrame:profileFrame];
        [self.creatorProfileImageView.layer setBorderWidth:1];
        [self.creatorProfileImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.pageCoverImageView addSubview:self.creatorProfileImageView];
        
        CGRect overlayFrame = frame;
        overlayFrame.size.height = overlayFrame.size.height * .44;
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
    }

    return self;
}

-(void)followButtonPressed{
    [self.delegate followButtonPressed:self.page];
}

-(void)setPage:(IPKPage *)page{
        _page = page;
        [self.nameLabel setText:page.name];
        //load image view with URL
        [self.pageCoverImageView setPathToNetworkImage:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg" forDisplaySize:self.pageCoverImageView.frame.size contentMode:UIViewContentModeCenter];
        [self.creatorProfileImageView setPathToNetworkImage:[self.page.owner imageProfilePathForSize:IPKUserProfileImageSizeMedium] forDisplaySize:self.creatorProfileImageView.frame.size contentMode:UIViewContentModeCenter];
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
