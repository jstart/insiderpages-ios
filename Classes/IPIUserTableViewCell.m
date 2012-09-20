//
//  IPIUserTableViewCell
//
//

#import "IPIUserTableViewCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"

@implementation IPIUserTableViewCell

@synthesize user = _user;

- (void)setUser:(IPKUser *)user {
    if (_user != user) {
    
        _user = user;
        
        self.textLabel.text = [user name];
        self.detailTextLabel.text = [user email];
        [self.profileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
        [self.profileImageView setPathToNetworkImage:[user imageProfilePathForSize:IPKUserProfileImageSizeMedium]];
        [self setNeedsLayout];
    }
}


#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		UIImageView *disclosureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 15.0f)];
		disclosureImageView.image = [UIImage imageNamed:@"disclosure.png"];
		self.accessoryView = disclosureImageView;
		
		disclosureImageView.highlightedImage = [UIImage imageNamed:@"disclosure-highlighted.png"];
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
        [self.profileImageView setFrame:CGRectMake(0, 0, 50, 50)];
        [self addSubview:self.profileImageView];
	}
	return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 60;
    textLabelFrame.size.width = textLabelFrame.size.width - 100;
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame.origin.x = 60;
    detailTextLabelFrame.size.width = detailTextLabelFrame.size.width - 100;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
