//
//  IPIUserSeachTableViewCell
//
//

#import "IPIUserSearchTableViewCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIColor-Expanded.h"

@implementation IPIUserSearchTableViewCell

@synthesize user = _user;

- (void)setUser:(IPKUser *)user {
    if (_user != user) {
    
        _user = user;
        
        self.textLabel.text = [user name];
        self.detailTextLabel.text = [user email];
        [self.profileImageView prepareForReuse];
        [self.profileImageView setPathToNetworkImage:[user imageProfilePathForSize:IPKUserProfileImageSizeMedium]];
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
//		SSGradientView *selectedBackground = [[SSGradientView alloc] initWithFrame:CGRectZero];
//		selectedBackground.colors = [[NSArray alloc] initWithObjects:
//									 [UIColor colorWithRed:0.0f green:0.722f blue:0.918f alpha:1.0f],
//									 [UIColor colorWithRed:0.0f green:0.631f blue:0.835f alpha:1.0f],
//									 nil];
//		selectedBackground.bottomBorderColor = [UIColor colorWithRed:0.0f green:0.502f blue:0.725f alpha:1.0f];
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
        
        self.profileImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.profileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
        [self addSubview:self.profileImageView];
	}
	return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 60;
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame.origin.x = 60;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
