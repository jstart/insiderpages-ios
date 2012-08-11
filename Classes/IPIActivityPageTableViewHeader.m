//
//  IPIActivityPageTableViewHeader.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIActivityPageTableViewHeader.h"

@implementation IPIActivityPageTableViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Section margin
        frame.origin.y = frame.origin.y + 10;
        self.pageCoverImageView = [[NINetworkImageView alloc] initWithFrame:frame];
        [self addSubview:self.pageCoverImageView];
        
        CGRect overlayFrame = frame;
        overlayFrame.size.height = overlayFrame.size.height * .40;
        overlayFrame.origin.x = 0;
        overlayFrame.origin.y = frame.size.height - overlayFrame.size.height;
        self.overlayView = [[UIView alloc] initWithFrame:overlayFrame];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0.6;
        [self.pageCoverImageView addSubview:self.overlayView];
        
        CGRect nameLabelFrame = overlayFrame;
        nameLabelFrame.origin.x = 10;
        nameLabelFrame.size.width = nameLabelFrame.size.width - 10;
        self.nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.pageCoverImageView addSubview:self.nameLabel];
        
        //hacky way to draw an arrow
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,60.0,frame.size.height + 25);
        CGPathAddLineToPoint(path, NULL, 70.0f, frame.size.height + 10);
        CGPathAddLineToPoint(path, NULL, 80.0f, frame.size.height + 25);
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setPath:path];
        [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
        [shapeLayer setBounds:frame];
        [shapeLayer setAnchorPoint:CGPointMake(0.0f, 0.0f)];
        [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
        [[self layer] addSublayer:shapeLayer];
    }

    return self;
}

-(void)setPage:(IPKPage *)page{
    if (_page != page) {
        _page = page;
        [self.nameLabel setText:page.name];
        //load image view with URL
        [self.pageCoverImageView setPathToNetworkImage:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg" forDisplaySize:self.pageCoverImageView.frame.size contentMode:UIViewContentModeCenter];
    }
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
