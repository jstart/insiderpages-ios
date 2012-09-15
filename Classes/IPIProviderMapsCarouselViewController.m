//
//  IPIProviderScoopsCarouselViewController.m
//

#import "IPIProviderMapsCarouselViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIProviderMapCarouselView.h"

@implementation IPIProviderMapsCarouselViewController

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
        self.carousel.frame = CGRectMake(0, 0, 320, 115);
        [self.carousel setContentOffset:CGSizeMake(0, 0)];
        [self.carousel setCurrentItemIndex:0];
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
    self.currentPage = @1;
    if (self.loading) {
        return;
    }
    self.loading = YES;
    NSString * pageIDString = [NSString stringWithFormat:@"%@", self.page.remoteID];
    [[IPKHTTPClient sharedClient] getProvidersForPageWithId:pageIDString success:^(AFJSONRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fetchedResultsController = nil;
            [self.carousel reloadData];
            self.loading = NO;
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-page-providers-%@", self.page.remoteID]];
            self.loading = NO;
        });
    }];
}

-(void)setPage:(IPKPage *)page{
    _page = page;
    
    [self.fetchedResultsController performFetch:nil];
    [self refresh];
    [self.carousel reloadData];
}

-(NSString*)entityName{
    return @"IPKProvider";
}

-(BOOL)ascending{
    return NO;
}

- (NSPredicate *)predicate {	
	return [NSPredicate predicateWithFormat:@"(SUBQUERY(pages, $eachPage, $eachPage.remoteID == %@).@count !=0)", self.page.remoteID];
}


-(NSString *)sortDescriptors{
    return @"createdAt,remoteID";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
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

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
//    if (self.fetchedResultsController.fetchedObjects.count == 0 || carousel.numberOfItems > self.fetchedResultsController.fetchedObjects.count){
//        return [self loadingViewWithFrame:CGRectMake(0, 0, 250, 150)];
//    }
    if (view == nil) {
        IPIProviderMapCarouselView * newView = [[IPIProviderMapCarouselView alloc] initWithFrame:CGRectMake(0, 0, 260, 115)];
        [newView setProvider:[self.fetchedResultsController.fetchedObjects objectAtIndex:index]];
        return newView;
    }
    else{
        [((IPIProviderMapCarouselView *)view) setProvider:[self.fetchedResultsController.fetchedObjects objectAtIndex:index]];
    }
    return view;
}

#pragma mark - iCarouselDelegate

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    //override to stop loading cells from being added
    if (self.delegate) {
        [self.delegate pageChanged];
    }
}

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel{
    
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    
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
    return 280;
}


//- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
//    
//}


//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
//    switch (option)
//    {
//        case iCarouselOptionWrap:
//        {
//            return NO;
//        }
//        default:
//        {
//            return value;
//        }
//    }
//
//}

#pragma mark - NSFetchedResultsControllerDelegate


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.carousel reloadData];
}

@end
