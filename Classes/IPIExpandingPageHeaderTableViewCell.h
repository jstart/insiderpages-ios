//
//  IPIExpandingPageHeaderTableViewCell
//
//

#import "CDITableViewCell.h"
#import "NINetworkImageView.h"
#import "UIExpandableTableView.h"

@interface IPIExpandingPageHeaderTableViewCell : CDITableViewCell<UIExpandingTableViewCell> {
@private
    BOOL _isSpinning;
    
    UIActivityIndicatorView *_activityIndicatorView;
    UIImageView *_disclosureIndicatorImageView;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, retain) UIImageView *disclosureIndicatorImageView;

- (void)setSpinning:(BOOL)spinning;

@end
