//
//  IPIProviderSearchTableViewCell
//
//

#import "IPIProviderSearchTableViewCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIColor-Expanded.h"

@implementation IPIProviderSearchTableViewCell

@synthesize provider = _provider;

- (void)setProvider:(IPKProvider *)provider {
    if (_provider != provider) {
    
        _provider = provider;
        
        self.textLabel.text = [provider full_name];
        self.detailTextLabel.text = provider.address.address_1;
//        [self.profileImageView setPathToNetworkImage:[activity.user imageProfilePathForSize:IPKUserProfileImageSizeMedium]];
        [self setNeedsLayout];
    }
}


#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
//		UIImageView *disclosureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 15.0f)];
//		disclosureImageView.image = [UIImage imageNamed:@"disclosure.png"];
//		self.accessoryView = disclosureImageView;
//		
//		disclosureImageView.highlightedImage = [UIImage imageNamed:@"disclosure-highlighted.png"];
//		SSGradientView *selectedBackground = [[SSGradientView alloc] initWithFrame:CGRectZero];
//		selectedBackground.colors = [[NSArray alloc] initWithObjects:
//									 [UIColor colorWithRed:0.0f green:0.722f blue:0.918f alpha:1.0f],
//									 [UIColor colorWithRed:0.0f green:0.631f blue:0.835f alpha:1.0f],
//									 nil];
//		selectedBackground.bottomBorderColor = [UIColor colorWithHexString:@"000000"];
//        selectedBackground.topBorderColor = [UIColor colorWithHexString:@"bfbfbf"];
//		selectedBackground.contentMode = UIViewContentModeRedraw;
//		self.selectedBackgroundView = selectedBackground;
        
		SSBorderedView *background = [[SSBorderedView alloc] initWithFrame:CGRectZero];
		background.backgroundColor = [UIColor pulloutBackgroundColor];
        background.topBorderColor = [[UIColor colorWithHexString:@"bfbfbf"] colorWithAlphaComponent:0.3];
		background.bottomBorderColor = [[UIColor colorWithHexString:@"000000"] colorWithAlphaComponent:0.3];
		background.contentMode = UIViewContentModeRedraw;
		self.backgroundView = background;
		self.contentView.clipsToBounds = YES;
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        self.textLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:17];
        self.textLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        self.detailTextLabel.font = [UIFont fontWithName:@"Myriad Web Pro" size:13];
        self.detailTextLabel.textColor = [UIColor colorWithHexString:@"b4b3b4"];
	}
	return self;
}

@end
