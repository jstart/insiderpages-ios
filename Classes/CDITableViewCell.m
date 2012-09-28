//
//  CDITableViewCell.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/31/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITableViewCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIFont+InsiderPagesiOSAdditions.h"
#import "UIColor-Expanded.h"
#import <objc/runtime.h>

@interface CDITableViewCell () <UIGestureRecognizerDelegate>
@end

@implementation CDITableViewCell

- (void)setAppearanceBackgroundImage:(UIImage *)image {
    self.backgroundView = [[UIImageView alloc] initWithImage:image];
}

- (void)setAppearanceBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
}

- (void)setTextLabelColor:(UIColor *)textLabelColor {
    self.textLabel.textColor = textLabelColor;
}

- (void)setTextLabelFont:(UIFont *)textLabelFont {
    self.textLabel.font = textLabelFont;
}

- (void)setDetailTextLabelColor:(UIColor *)detailTextLabelColor {
    self.detailTextLabel.textColor = detailTextLabelColor;
}

- (void)setDetailTextLabelFont:(UIFont *)detailTextLabelFont {
    self.detailTextLabel.font = detailTextLabelFont;
}

#pragma mark - Class Methods

+ (CGFloat)cellHeight {
	return 44.0f;
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {		
		self.textLabel.textColor = [UIColor cheddarTextColor];
		self.textLabel.font = [UIFont cheddarFontOfSize:20.0f];
				
		SSBorderedView *background = [[SSBorderedView alloc] initWithFrame:CGRectZero];
		background.backgroundColor = [UIColor whiteColor];
		background.bottomBorderColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
		background.contentMode = UIViewContentModeRedraw;
		self.backgroundView = background;		
		self.contentView.clipsToBounds = YES;
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        self.textLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:17];
        self.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        self.detailTextLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:13];
        self.detailTextLabel.textColor = [UIColor colorWithHexString:@"b4b3b4"];

	}
	return self;
}

@end
