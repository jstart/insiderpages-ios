//
//  IPIDisqusTableViewCell.m
//

#import "IPIDisqusTableViewCell.h"
#import "UIColor-Expanded.h"
#import "UIColor+InsiderPagesiOSAdditions.h"

@implementation IPIDisqusTableViewCell

@synthesize comment = _comment;
static CGFloat messageLabelHeight = 0;

- (void)setComment:(IADisqusComment *)comment {
    if (_comment != comment) {
        _comment = comment;
        self.messageLabel.text = comment.rawMessage;
        self.usernameLabel.text = comment.authorName;
//        self.detailTextLabel.text = [activity actionText];
        if (comment.parent != nil) {
            messageLabelHeight = [comment.rawMessage sizeWithFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping].height;
        }else{
            messageLabelHeight = [comment.rawMessage sizeWithFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] constrainedToSize:CGSizeMake(230, 9999) lineBreakMode:NSLineBreakByWordWrapping].height;
        }
        [self.profileImageView setInitialImage:[UIImage imageNamed:@"reload-button"]];
        [self.profileImageView setPathToNetworkImage:_comment.authorAvatar];
//        self.timeLabel.text = [comment formattedTimeElapsedSinceUpdated];
        [self layoutSubviews];
    }
}

+(CGFloat)cellHeightForComment:(IADisqusComment*)comment{
    if (comment.parent != nil) {
        return [comment.rawMessage sizeWithFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping].height + 40 + 28;
    }else{
        return [comment.rawMessage sizeWithFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] constrainedToSize:CGSizeMake(230, 9999) lineBreakMode:NSLineBreakByWordWrapping].height + 40 + 28;
    }
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;      
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        CGRect contentViewFrame = self.frame;
        self.contentView.frame = contentViewFrame;
        
        self.backgroundView = [[UIView alloc] init];
        [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
        
        UIImage * image = nil;
        self.profileImageView = [[NINetworkImageView alloc] initWithImage:image];
        [self.profileImageView setFrame:CGRectMake(20, 15, 23, 23)];
        [self addSubview:self.profileImageView];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 30, 220, 20)];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font = [UIFont fontWithName:@"MyriadWebPro" size:13];
        self.messageLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:self.messageLabel];
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 15, 150, 20)];
        self.usernameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.usernameLabel.backgroundColor = [UIColor clearColor];
        [self.usernameLabel setFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13]];
        [self addSubview:self.usernameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 5, 80, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [self.timeLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
        [self addSubview:self.timeLabel];
        
        self.commentReplyButton = [[IPICommentReplyButton alloc] initWithFrame:CGRectMake(225, 0, 55, 28)];
        [self.commentReplyButton addTarget:self action:@selector(replyButtonSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.commentReplyButton];
	}
	return self;
}

-(void)replyButtonSelected{
    [self.commentReplyButton setSelected:YES];
    if (self.delegate) {
        [self.delegate replyToComment:self.comment cell:self];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    if (self.comment.parent != nil) {
        CGRect profileImageViewFrame = self.profileImageView.frame;
        profileImageViewFrame.origin.x = 47;
        self.profileImageView.frame = profileImageViewFrame;
        
        
        CGRect usernameLabelFrame = self.usernameLabel.frame;
        usernameLabelFrame.origin.x = 75;
        self.usernameLabel.frame = usernameLabelFrame;
        
        CGRect textLabelFrame = self.messageLabel.frame;
        textLabelFrame.origin.x = 75;
        textLabelFrame.size.height = [self.comment.rawMessage sizeWithFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping].height;
        textLabelFrame.size.width = 200;
        textLabelFrame.origin.y = 30;
        self.messageLabel.frame = textLabelFrame;
        
        CGRect detailTextLabelFrame = self.detailTextLabel.frame;
        detailTextLabelFrame.origin.x = 75;
        self.detailTextLabel.frame = detailTextLabelFrame;
        
        CGRect commentReplyButtonFrame = self.commentReplyButton.frame;
        commentReplyButtonFrame.origin.y = [self.comment.rawMessage sizeWithFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping].height + 40 - 10;
        self.commentReplyButton.frame = commentReplyButtonFrame;
    }else{
        CGRect profileImageViewFrame = self.profileImageView.frame;
        profileImageViewFrame.origin.x = 20;
        self.profileImageView.frame = profileImageViewFrame;
        
        
        CGRect usernameLabelFrame = self.usernameLabel.frame;
        usernameLabelFrame.origin.x = 47;
        self.usernameLabel.frame = usernameLabelFrame;
        
        CGRect textLabelFrame = self.messageLabel.frame;
        textLabelFrame.origin.x = 47;
        textLabelFrame.size.height = [self.comment.rawMessage sizeWithFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] constrainedToSize:CGSizeMake(230, 9999) lineBreakMode:NSLineBreakByWordWrapping].height;
        textLabelFrame.size.width = 230;
        textLabelFrame.origin.y = 30;
        self.messageLabel.frame = textLabelFrame;

        CGRect detailTextLabelFrame = self.detailTextLabel.frame;
        detailTextLabelFrame.origin.x = 50;
        self.detailTextLabel.frame = detailTextLabelFrame;
        
        CGRect commentReplyButtonFrame = self.commentReplyButton.frame;
        commentReplyButtonFrame.origin.y = [self.comment.rawMessage sizeWithFont:[UIFont fontWithName:@"MyriadWebPro-Bold" size:13] constrainedToSize:CGSizeMake(230, 9999) lineBreakMode:NSLineBreakByWordWrapping].height + 40 - 10;
        self.commentReplyButton.frame = commentReplyButtonFrame;
    }
}

@end
