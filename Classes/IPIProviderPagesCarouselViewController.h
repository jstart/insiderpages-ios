//
//  IPIProviderPagesCarouselViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "iCarousel.h"

@class IPKProvider;

@interface IPIProviderPagesCarouselViewController : UIViewController

@property (nonatomic, strong) IPKProvider *provider;
@property (nonatomic, strong) iCarousel * carousel;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end
