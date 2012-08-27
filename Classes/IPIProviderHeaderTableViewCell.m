//
//  IPIProviderHeaderTableViewCell
//

#import "IPIProviderHeaderTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"

@implementation IPIProviderHeaderTableViewCell

@synthesize provider = _provider;

- (void)setProvider :(IPKProvider *)provider {
    if (_provider != provider) {
    
        _provider = provider;
        
        self.textLabel.text = [provider full_name];
        self.rankLabel.text = [NSString stringWithFormat:@"%d", arc4random() % 15];
        [self setNeedsLayout];
    }
}


#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        
        self.frame = CGRectMake(0, 0, 320, [IPIProviderHeaderTableViewCell cellHeight]);
        CGRect overlayFrame = self.frame;
        overlayFrame.size.height = overlayFrame.size.height * .30;
        overlayFrame.origin.x = 0;
        overlayFrame.origin.y = self.frame.size.height - overlayFrame.size.height;
        self.overlayView = [[UIView alloc] initWithFrame:overlayFrame];
        self.overlayView.alpha = 0.6;
        [self.overlayView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:self.overlayView];
        
        self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 30, 30)];
        self.rankLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.rankLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setUserInteractionEnabled:NO];
	}
	return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(30, 70, 320, 30);
    [self addSubview:self.textLabel];
}

+ (CGFloat)cellHeight {
	return 100.0f;
}

@end
