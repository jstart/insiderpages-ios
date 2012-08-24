//
//  IPIAccordionPagesViewController
//

#import "CDIManagedTableViewController.h"
#import "UIExpandableTableView.h"
#import "IIViewDeckController.h"
#import "SVPullToRefresh.h"

@protocol IPIAccordionPagesViewControllerDelegate <NSObject>

-(void)didChoosePage:(IPKPage*)page;

@end

@interface IPIAccordionPagesViewController : CDIManagedTableViewController

@property id <IPIAccordionPagesViewControllerDelegate> delegate;

-(id)initWithSectionHeader:(NSString*)section_header;

@end
