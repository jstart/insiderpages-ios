//
//  CDIListTableViewCell.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "IPIActivityTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"

@implementation IPIActivityTableViewCell

@synthesize activity = _activity;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;
        
        self.textLabel.text = activity.trackable_type;
        self.detailTextLabel.text = [activity actionText];
        [self.profileImageView setPathToNetworkImage:[activity.user imageProfilePathForSize:IPKUserProfileImageSizeMedium]];
        self.timeLabel.text = [activity formattedTimeElapsedSinceUpdated];
        [self setNeedsLayout];
    }
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
//		UIImageView *disclosureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 15.0f)];
//		disclosureImageView.image = [UIImage imageNamed:@"disclosure.png"];
//		self.accessoryView = disclosureImageView;
		
//		disclosureImageView.highlightedImage = [UIImage imageNamed:@"disclosure-highlighted.png"];
		SSGradientView *selectedBackground = [[SSGradientView alloc] initWithFrame:CGRectZero];
		selectedBackground.colors = [[NSArray alloc] initWithObjects:
									 [UIColor colorWithRed:0.0f green:0.722f blue:0.918f alpha:1.0f],
									 [UIColor colorWithRed:0.0f green:0.631f blue:0.835f alpha:1.0f],
									 nil];
		selectedBackground.bottomBorderColor = [UIColor colorWithRed:0.0f green:0.502f blue:0.725f alpha:1.0f];
		selectedBackground.contentMode = UIViewContentModeRedraw;
		self.selectedBackgroundView = selectedBackground;
        
        UIImage * image = nil;
        self.profileImageView = [[NINetworkImageView alloc] initWithImage:image];
        [self.profileImageView setFrame:CGRectMake(15, 6, 40, 40)];
        [self addSubview:self.profileImageView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-40, 5, 40, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 50;
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame.origin.x = 50;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
