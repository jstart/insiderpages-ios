//
//  IPIAbstractCarouselViewController.m
//

#import "IPIAbstractCarouselViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIReviewCarouselView.h"

@interface IPIAbstractCarouselViewController () <iCarouselDelegate, iCarouselDataSource, NSFetchedResultsControllerDelegate>
@end

@implementation IPIAbstractCarouselViewController

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
        
        [[self view] addSubview:self.carousel];
        
        self.currentPage = @1;
        self.perPage = @5;
        self.loading = NO;
    }
	return self;
}

-(iCarousel*)carousel{
    if (_carousel == nil){
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
        [_carousel setBounceDistance:.5f];
        [_carousel setDataSource:self];
        [_carousel setContentOffset:CGSizeMake(-15, 0)];
        [_carousel setDelegate:self];
        [_carousel setClipsToBounds:YES];
    }
    return _carousel;
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
}

-(void)nextPage{
    if (self.loading) {
        return;
    }
    self.currentPage = @([self.currentPage intValue] + 1);
}

-(NSString*)entityName{
    return nil;
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:self.ascending];
        [sortDescriptors addObject:sortDescriptor];
    }
    
	fetchRequest.sortDescriptors = sortDescriptors;
	fetchRequest.predicate = self.predicate;
    return fetchRequest;
}

- (BOOL)ascending {
	return YES;
}

- (NSPredicate *)predicate {
	return nil;
}

-(NSString *)sortDescriptors{
    return @"createdAt,remoteID";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.carousel scrollByOffset:-40 duration:0.3];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

-(UIView*)loadingViewWithFrame:(CGRect)frame{
    UIView * loadingView = [[UIView alloc] initWithFrame:frame];
    loadingView.backgroundColor = [UIColor whiteColor];
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    [activityIndicator setCenter:loadingView.center];
    [loadingView addSubview:activityIndicator];
    UILabel * loadingReviewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingView.frame.size.width, 20)];
    [loadingReviewsLabel setTextColor:[UIColor grayColor]];
    [loadingReviewsLabel setTextAlignment:NSTextAlignmentCenter];
    CGPoint loadingLabelCenter = loadingView.center;
    loadingLabelCenter.y = loadingLabelCenter.y+activityIndicator.frame.size.height + 5;
    [loadingReviewsLabel setCenter:loadingLabelCenter];
    [loadingReviewsLabel setText:@"Loading..."];
    [loadingView addSubview:loadingReviewsLabel];
    return loadingView;
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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
//    return [sectionInfo numberOfObjects] == 0 ? 1 : [sectionInfo numberOfObjects];
    return [sectionInfo numberOfObjects];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    if ((self.fetchedResultsController.fetchedObjects.count == 0 || carousel.numberOfItems > self.fetchedResultsController.fetchedObjects.count) && ![self.fetchedResultsController.fetchedObjects objectAtIndex:index]) {
        
        return [self loadingViewWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return nil;
}


#pragma mark - iCarouselDelegate

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel{
    
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    if (carousel.currentItemIndex == self.fetchedResultsController.fetchedObjects.count - 1 && !self.loading) {
        [carousel insertItemAtIndex:carousel.currentItemIndex+1 animated:YES];
        [self nextPage];
    }
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
    return 100;
}


//- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
//    
//}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
        default:
        {
            return value;
        }
    }

}

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
