//
//  CDIListTableViewCell.m
//
//

#import "IPIProviderTableViewCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"

@implementation IPIProviderTableViewCell

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
		SSGradientView *selectedBackground = [[SSGradientView alloc] initWithFrame:CGRectZero];
		selectedBackground.colors = [[NSArray alloc] initWithObjects:
									 [UIColor colorWithRed:0.0f green:0.722f blue:0.918f alpha:1.0f],
									 [UIColor colorWithRed:0.0f green:0.631f blue:0.835f alpha:1.0f],
									 nil];
		selectedBackground.bottomBorderColor = [UIColor colorWithRed:0.0f green:0.502f blue:0.725f alpha:1.0f];
		selectedBackground.contentMode = UIViewContentModeRedraw;
		self.selectedBackgroundView = selectedBackground;
        
//        UIImage * image = nil;
//        self.providerImageView = [[NINetworkImageView alloc] initWithImage:image];
//        [self.providerImageView setFrame:CGRectMake(self.center.x, 0, 50, 50)];
//        [self addSubview:self.providerImageView];
	}
	return self;
}

@end
