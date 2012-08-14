//
//  CDIListTableViewCell.m
//
//

#import "IPIPageTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"

@implementation IPIPageTableViewCell

@synthesize page = _page;

- (void)setPage :(IPKPage *)page {
    if (_page != page) {
    
        _page = page;
        
        self.textLabel.text = [page name];
        self.detailTextLabel.text = [page description_text];
//        [self.pageCoverImageView setPathToNetworkImage:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg"];
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
        self.pageCoverImageView = [[NINetworkImageView alloc] initWithImage:image];
        [self.pageCoverImageView setFrame:CGRectMake(self.center.x, 0, 50, 50)];
        [self addSubview:self.pageCoverImageView];
	}
	return self;
}

@end
