//
//  IPIProviderPagesCarouselViewController
//

#import "IPIProviderPagesCarouselViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIPageCarouselView.h"

@interface IPIProviderPagesCarouselViewController () <iCarouselDataSource, iCarouselDelegate>
@end

@implementation IPIProviderPagesCarouselViewController

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
        self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 320, 115)];
        [self.carousel setDataSource:self];
        [self.carousel setDelegate:self];
        [[self view] addSubview:self.carousel];
    }
	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

-(void)refresh{
    for (IPKPage* page in self.fetchedResultsController.fetchedObjects) {
        if ([page.owner.id isEqualToNumber:@(0)]) {            
            [page.owner updateWithSuccess:^(void){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.carousel reloadData];
                });
            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-provider-pages-owners-%@", self.provider.remoteID]];
                });
            }];
        }
    }
    
    NSString * providerIDString = [NSString stringWithFormat:@"%@", self.provider.id];
    [[IPKHTTPClient sharedClient] getPagesForProviderWithId:providerIDString withCurrentPage:@1 perPage:@10 success:^(AFJSONRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fetchedResultsController = nil;
            [self.carousel reloadData];
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-provider-pages-%@", self.provider.remoteID]];
        });
    }];
}

-(void)setProvider:(IPKProvider *)provider{
    _provider = provider;
    
    
    [self refresh];
    [self.carousel reloadData];
}

-(NSString*)entityName{
    return @"IPKPage";
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (!_fetchedResultsController){
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread] sectionNameKeyPath:nil cacheName:nil];
;
		_fetchedResultsController.delegate = self;
		[_fetchedResultsController performFetch:nil];
	}
	return _fetchedResultsController;
}

-(NSFetchRequest *)fetchRequest{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSArray* sortKeys = [self.sortDescriptors componentsSeparatedByString:@","];
    for (NSString* sortKey in sortKeys) 
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
        [sortDescriptors addObject:sortDescriptor];
    }
    
	fetchRequest.sortDescriptors = sortDescriptors;
	fetchRequest.predicate = self.predicate;
    return fetchRequest;
}

- (NSPredicate *)predicate {
	return [NSPredicate predicateWithFormat:@"ANY providers.remoteID = %@", self.provider.remoteID];
}

-(NSString *)sortDescriptors{
    return @"createdAt,remoteID";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
//	[SSRateLimit executeBlock:^{
//		[self refresh:nil];
//	} name:[NSString stringWithFormat:@"refresh-list-%@", self.provider.remoteID] limit:30.0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	if ([self showingCoverView]) {
//		[self.addTaskView.textField resignFirstResponder];
//	}
	
//	[super scrollViewDidScroll:scrollView];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}

	if ([keyPath isEqualToString:@"title"]) {
		self.title = [change objectForKey:NSKeyValueChangeNewKey];
	} else if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && [keyPath isEqualToString:@"archivedAt"]) {
		if ([change objectForKey:NSKeyValueChangeNewKey] != [NSNull null]) {
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
	}
}

#pragma mark - iCarouselDataSource

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        IPIPageCarouselView * view = [[IPIPageCarouselView alloc] initWithFrame:CGRectMake(0, 5, 300, 110)];
        [view setPage:[self.fetchedResultsController.fetchedObjects objectAtIndex:index]];
        return view;
    }
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel{
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    UIView * newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    newView.backgroundColor = [UIColor whiteColor];
    return newView;
}

#pragma mark - iCarouselDelegate

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel{
    
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
}


- (void)carouselDidScroll:(iCarousel *)carousel{
    
}


- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    
}


- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    
}


- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate{
    
}


- (void)carouselWillBeginDecelerating:(iCarousel *)carousel{
    
}


- (void)carouselDidEndDecelerating:(iCarousel *)carousel{
    
}



- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index{
    return YES;
}


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
}



- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    return 320;
}


//- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
//    
//}


//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
//    
//}

@end
