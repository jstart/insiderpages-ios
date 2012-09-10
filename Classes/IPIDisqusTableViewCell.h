//
//  IPIDisqusTableViewCell.h
//

#import "NINetworkImageView.h"

@interface IPIDisqusTableViewCell : UITableViewCell

@property (nonatomic, strong) IPKActivity *activity;
@property (nonatomic, strong) NINetworkImageView * profileImageView;
@property (nonatomic, strong) UILabel * timeLabel;

@end
