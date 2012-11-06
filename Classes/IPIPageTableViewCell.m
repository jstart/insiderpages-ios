//
//  CDIListTableViewCell.m
//
//

#import "IPIPageTableViewCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"

@implementation IPIPageTableViewCell

@synthesize page = _page;

- (void)setPage :(IPKPage *)page {
    if (_page != page) {
    
        _page = page;
        
        self.textLabel.text = [page name];
        IPKUser * viewingUser = self.user ? self.user : [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        NSSet * filteredSet = [page.following_users filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"remoteID == %@", viewingUser.remoteID]];
        if (filteredSet.count > 0) {
            self.detailTextLabel.text = @"Insider";
        }else if ([page.owner.remoteID isEqualToNumber:viewingUser.remoteID]){
            self.detailTextLabel.text = @"Creator";
        }else{
            self.detailTextLabel.text = @"Other";
        }
        [self.pageCoverImageView setPathToNetworkImage:@"http://gentlemint.com/media/images/2012/04/26/3f31ab05.jpg.650x650_q85.jpg" forDisplaySize:self.pageCoverImageView.frame.size contentMode:UIViewContentModeScaleAspectFill
         ];
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
        self.pageCoverImageView = [[NINetworkImageView alloc] initWithImage:image];
        [self.pageCoverImageView setFrame:CGRectMake(0, 0, 66, 43)];
        [self addSubview:self.pageCoverImageView];
	}
	return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 76;
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame.origin.x = 76;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
