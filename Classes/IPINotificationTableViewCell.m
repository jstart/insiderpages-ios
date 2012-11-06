//
//  IPINotifcationTableViewCell
//
//

#import "IPINotifcationTableViewCell.h"
#import "UIColor-Expanded.h"
#import "NSString+HTML.h"
#import "NYXImagesKit.h"
#import "UIImageView+Rasterize.h"

@implementation IPINotifcationTableViewCell

@synthesize notification = _notification;

- (void)setNotification:(IPKNotification *)notification {
    if (_notification != notification) {
    
        _notification = notification;
        IPKUser * actionUser = [[[notification mentioned_users] allObjects] objectAtIndex:0];
        _fullMessage = [[[actionUser name] stringByAppendingString:@" "] stringByAppendingString:[[notification action_text] stringByStrippingHTML]];
        self.notificationLabel.text = _fullMessage;
        //        self.detailTextLabel.text = [notification section_header];
        NSString *profileImageViewURLString = [actionUser imageProfilePathForSize:IPKUserProfileImageSizeMedium];
        [self.profileImageView prepareForReuse];
        [self.profileImageView loadURLString:profileImageViewURLString forSize:self.profileImageView.frame.size mode:NYXCropModeCenter];
        [self layoutSubviews];
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
        
        self.notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, 245, 60)];
        self.notificationLabel.numberOfLines = 0;
        self.notificationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.notificationLabel.font = [UIFont fontWithName:@"MyriadWebPro" size:13];
        self.notificationLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.notificationLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.notificationLabel];
        
        UIImage * image = nil;
        self.profileImageView = [[NINetworkImageView alloc] initWithImage:image];
        [self.profileImageView setFrame:CGRectMake(10, 12, 44, 44)];
        [self addSubview:self.profileImageView];
	}
	return self;
}

+(CGFloat)cellHeightForNotification:(IPKNotification*)notification{
    IPKUser * actionUser = [[[notification mentioned_users] allObjects] objectAtIndex:0];
    NSString * message = [[[actionUser name] stringByAppendingString:@" "] stringByAppendingString:[[notification action_text] stringByStrippingHTML]];
    return [message sizeWithFont:[UIFont fontWithName:@"Myriad Web Pro" size:13] constrainedToSize:CGSizeMake(245, 9999) lineBreakMode:NSLineBreakByWordWrapping].height + 40;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect notificationLabelFrame = self.notificationLabel.frame;
    notificationLabelFrame.origin.x = 65;
    notificationLabelFrame.size.width = 245;
    notificationLabelFrame.size.height = [_fullMessage sizeWithFont:[UIFont fontWithName:@"Myriad Web Pro" size:13] constrainedToSize:CGSizeMake(245, 9999) lineBreakMode:NSLineBreakByWordWrapping].height;
    self.notificationLabel.frame = notificationLabelFrame;
    
//    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
//    detailTextLabelFrame.origin.x = 76;
//    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
