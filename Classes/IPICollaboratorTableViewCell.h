//
//  IPICollaboratorTableViewCell
//
//
#import "CDITableViewCell.h"
#import "NINetworkImageView.h"

@interface IPICollaboratorTableViewCell : CDITableViewCell

@property (nonatomic, strong) IPKUser *user;
@property (nonatomic, strong) IPKPage *page;
@property (nonatomic, strong) NINetworkImageView * profileImageView;

@end
