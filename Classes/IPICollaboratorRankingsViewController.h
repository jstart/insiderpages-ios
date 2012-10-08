//
//  IPICollaboratorRankingsViewController
//

#import "CDIManagedTableViewController.h"

@protocol IPICollaboratorRankingsDelegate <NSObject>

-(void)didSelectUser:(IPKUser*)sortUser;

@end

@interface IPICollaboratorRankingsViewController : CDIManagedTableViewController

@property (nonatomic, assign) id <IPICollaboratorRankingsDelegate> delegate;
@property (nonatomic, strong) IPKPage * page;

@end
