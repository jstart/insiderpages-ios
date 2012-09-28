//
//  IPIUserTableViewCell
//
//
#import "CDITableViewCell.h"
#import "NINetworkImageView.h"

@interface IPIUserTableViewCell : CDITableViewCell

@property (nonatomic, strong) IPKUser *user;
@property (nonatomic, strong) NINetworkImageView * profileImageView;

@end
