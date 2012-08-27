//
//  IPILeftPagesViewController
//

#import "CDIManagedTableViewController.h"
#import "IIViewDeckController.h"
#import "IPIPageViewController.h"

@interface IPILeftSearchViewController : CDIManagedTableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) IPKQueryModel * queryModel;

@end
