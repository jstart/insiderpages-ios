//
//  CDIPageTableViewCell.h
//
//

#import "CDITableViewCell.h"
#import "NINetworkImageView.h"

@interface IPIPageTableViewCell : CDITableViewCell

@property (nonatomic, strong) IPKPage *page;
@property (nonatomic, strong) NINetworkImageView * pageCoverImageView;
@end
