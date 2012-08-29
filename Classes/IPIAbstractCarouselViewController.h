//
//  IPIAbstractCarouselViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "iCarousel.h"

@interface IPIAbstractCarouselViewController : UIViewController

@property (nonatomic, strong) iCarousel * carousel;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSNumber * currentPage;
@property (nonatomic, strong) NSNumber * perPage;
@property (nonatomic, readwrite) BOOL loading;

-(UIView*)loadingViewWithFrame:(CGRect)frame;

@end
