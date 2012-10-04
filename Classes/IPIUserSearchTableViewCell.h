//
//  IPIUserSearchTableViewCell
//
//
#import "CDITableViewCell.h"
#import "NINetworkImageView.h"

@interface IPIUserSearchTableViewCell : CDITableViewCell

@property (nonatomic, strong) IPKUser *user;
@property (nonatomic, strong) NINetworkImageView * profileImageView;

@end
