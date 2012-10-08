//
//  IPISearchTableViewController
//
//  Created by Truman, Christopher on 7/3/12.
//

#import "CDIManagedTableViewController.h"

@interface IPISearchTableViewController : CDIManagedTableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchDisplayController * customSearchDisplayController;

@end

