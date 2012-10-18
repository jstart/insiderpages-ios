//
//  IPIDisqusTableViewCell.h
//

#import "NINetworkImageView.h"
#import "IADisqusComment.h"

@interface IPIDisqusTableViewCell : UITableViewCell

@property (nonatomic, strong) IADisqusComment *comment;
@property (nonatomic, strong) NINetworkImageView * profileImageView;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UILabel * usernameLabel;
@property (nonatomic, strong) UILabel * timeLabel;

+(CGFloat)cellHeightForComment:(IADisqusComment*)comment;

@end
