//
//  IPIDisqusTableViewCell.h
//

#import "NINetworkImageView.h"
#import "IADisqusComment.h"
#import "IPICommentReplyButton.h"

@protocol IPIDisqusTableViewCellDelegate <NSObject>

-(void)replyToComment:(IADisqusComment*)comment cell:(UITableViewCell*)cell;

@end

@interface IPIDisqusTableViewCell : UITableViewCell

@property (nonatomic, strong) id <IPIDisqusTableViewCellDelegate> delegate;
@property (nonatomic, strong) IADisqusComment *comment;
@property (nonatomic, strong) NINetworkImageView * profileImageView;
@property (nonatomic, strong) IPICommentReplyButton * commentReplyButton;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UILabel * usernameLabel;
@property (nonatomic, strong) UILabel * timeLabel;

+(CGFloat)cellHeightForComment:(IADisqusComment*)comment;

@end
