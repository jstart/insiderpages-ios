//
//  IPIProviderRankTableViewCell
//
//

#import "IPIProviderRankTableViewCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIColor-Expanded.h"

@implementation IPIProviderRankTableViewCell

@synthesize provider = _provider;

- (void)setProvider:(IPKProvider *)provider {
    if (_provider != provider) {
    
        _provider = provider;
        
        self.textLabel.text = [provider full_name];
//        self.detailTextLabel.text = provider.address.address_1;
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
        
        CGRect frame = self.textLabel.frame;
        frame.size.width = 190;
        self.textLabel.frame = frame;

        [self.textLabel setFont:[UIFont fontWithName:@"Myriad Web Pro" size:17]];
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        
        self.rankNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 17, 25, 20)];
        [self.rankNumberLabel setBackgroundColor:[UIColor clearColor]];
        [self.rankNumberLabel setFont:[UIFont fontWithName:@"Myriad Web Pro" size:21]];
        [self.rankNumberLabel setTextColor:[UIColor colorWithHexString:@"9c9c9c"]];
        [self.rankNumberLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.rankNumberLabel];
        
//        UIImage * image = nil;
//        self.providerImageView = [[NINetworkImageView alloc] initWithImage:image];
//        [self.providerImageView setFrame:CGRectMake(self.center.x, 0, 50, 50)];
//        [self addSubview:self.providerImageView];
	}
	return self;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:YES];
    if (editing) {
        self.rankNumberLabel.frame = CGRectMake(30, 17, 25, 20);
    }else{
        CGRect frame = self.textLabel.frame;
        frame.origin.x = frame.origin.x + 15;
        self.textLabel.frame = frame;
        self.rankNumberLabel.frame = CGRectMake(5, 17, 25, 20);
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    if (self.editing) {
        CGRect frame = self.textLabel.frame;
        frame.origin.x = 20;
        frame.origin.y = 17;
        self.textLabel.frame = frame;
    }else{
        CGRect textLabelFrame = self.textLabel.frame;
        textLabelFrame.origin.x = 35;
        textLabelFrame.origin.y = 17;
        self.textLabel.frame = textLabelFrame;
    }
}

@end
