//
//  IPIPageActivityCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIPageActivityCell.h"
#import "NINetworkImageView.h"

@implementation IPIPageActivityCell

@synthesize activity = _activity;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        
        [self.coverImageView prepareForReuse];
        [self.coverImageView setPathToNetworkImage:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg" forDisplaySize:self.coverImageView.frame.size contentMode:UIViewContentModeScaleToFill];
        
//        NSURL *URL = [NSURL URLWithString:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg"];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//            self.coverImageView.image = [UIImage imageWithData:data];
//        }];
    }
}

- (id)initWithActivity:(IPKActivity*)activity reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithActivity:activity reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        int leftPadding = 15;
        
        UIView * containerView = [[UIView alloc] initWithFrame:CGRectMake(leftPadding, 0, 290, 150)];
        containerView.backgroundColor = [UIColor whiteColor];
        containerView.layer.cornerRadius = 5;
        [[containerView layer] setMasksToBounds:NO];
        [[containerView layer] setShadowColor:[UIColor blackColor].CGColor];
        [[containerView layer] setShadowOpacity:0.34f];
        [[containerView layer] setShadowRadius:2.0f];
        [[containerView layer] setShadowOffset:CGSizeMake(0, 2)];
        [self addSubview:containerView];

        self.coverImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 110)];
        [self.coverImageView setOpaque:YES];
//        [[self.coverImageView layer] setMasksToBounds:YES
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.frame = self.coverImageView.bounds;
//        UIBezierPath *roundedPath =
//        [UIBezierPath bezierPathWithRoundedRect:maskLayer.bounds
//                              byRoundingCorners:UIRectCornerTopLeft |
//         UIRectCornerTopRight
//                                    cornerRadii:CGSizeMake(8.0f, 8.0f)];
//        maskLayer.backgroundColor = [UIColor clearColor].CGColor;
//        maskLayer.path = [roundedPath CGPath];
//        self.coverImageView.layer.mask = maskLayer;

        
        [self.coverImageView setPathToNetworkImage:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg" forDisplaySize:self.coverImageView.frame.size contentMode:UIViewContentModeCenter];
//        NSURL *URL = [NSURL URLWithString:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg"];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//            self.coverImageView.image = [UIImage imageWithData:data];
//        }];
        [containerView addSubview:self.coverImageView];
        
        UIView * overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 290, 51)];
        overlayView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"module_shadow"]];
        [self.coverImageView addSubview:overlayView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 80, 270, 20)];
        self.nameLabel.text = activity.page.name;
        self.nameLabel.font = [UIFont fontWithName:@"Comfortaa" size:17];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.nameLabel];
        
        self.placeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 120, 11, 16)];
        [self.placeIconImageView setImage:[UIImage imageNamed:@"place_icon"]];
        [containerView addSubview:self.placeIconImageView];
        
        self.placeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 123, 130, 14)];
        self.placeNumberLabel.text = @"16 places";
        self.placeNumberLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.placeNumberLabel.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.placeNumberLabel];
        
        self.likeIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(208, 124, 13, 12)];
        [self.likeIconImageView setImage:[UIImage imageNamed:@"likes_icon"]];
        [containerView addSubview:self.likeIconImageView];
        
        self.likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 124, 13, 14)];
        self.likeNumberLabel.text = @"16";
        self.likeNumberLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.likeNumberLabel.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.likeNumberLabel];
        
        self.commentIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 125, 13, 11)];
        [self.commentIconImageView setImage:[UIImage imageNamed:@"comments_icon"]];
        [containerView addSubview:self.commentIconImageView];
        
        self.commentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(268, 124, 13, 14)];
        self.commentNumberLabel.text = @"16";
        self.commentNumberLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:12];
        self.commentNumberLabel.backgroundColor = [UIColor clearColor];
        [containerView addSubview:self.commentNumberLabel];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


+(CGFloat)cellHeight{
    return 150;
}

@end
