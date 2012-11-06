//
//  IPINotifcationTableViewCell
//
//

#import "CDITableViewCell.h"
#import "NINetworkImageView.h"

@interface IPINotifcationTableViewCell : CDITableViewCell

@property (nonatomic, strong) IPKNotification *notification;
@property (nonatomic, strong) NINetworkImageView * profileImageView;
@property (nonatomic, strong) UILabel * notificationLabel;
@property (nonatomic, strong) NSString * fullMessage;

+(CGFloat)cellHeightForNotification:(IPKNotification*)notification;

@end
