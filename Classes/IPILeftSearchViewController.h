//
//  IPILeftPagesViewController
//

#import "CDIManagedTableViewController.h"
#import "IIViewDeckController.h"
#import "IPIPageViewController.h"
#import "IPIPullOutTableViewController.h"

@interface IPILeftSearchViewController : CDIManagedTableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) IPKQueryModel * queryModel;
@property (nonatomic, strong) IPIPullOutTableViewController * pullOutTableViewController;

@end
