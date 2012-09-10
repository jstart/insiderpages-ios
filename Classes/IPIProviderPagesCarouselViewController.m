 //
//  IPIProviderPagesCarouselViewController
//

#import "IPIProviderPagesCarouselViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIPageCarouselView.h"
#import "IPIPageViewController.h"

@implementation IPIProviderPagesCarouselViewController

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
         self.carousel.frame = CGRectMake(0, 0, 320, 115);
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
    NSString * providerIDString = [NSString stringWithFormat:@"%@", self.provider.id];
    [[IPKHTTPClient sharedClient] getPagesForProviderWithId:providerIDString withCurrentPage:self.currentPage perPage:self.perPage success:^(AFJSONRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fetchedResultsController = nil;
            [self.carousel reloadData];
             self.loading = NO;
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-provider-pages-%@", self.provider.remoteID]];
             self.loading = NO;
        });
    }];
}

-(void)nextPage{
    if (self.loading) {
        return;
    }
    self.currentPage = @([self.currentPage intValue] + 1);
    self.loading = YES;
    NSString * providerIDString = [NSString stringWithFormat:@"%@", self.provider.id];
    [[IPKHTTPClient sharedClient] getPagesForProviderWithId:providerIDString withCurrentPage:self.currentPage perPage:self.perPage success:^(AFJSONRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fetchedResultsController = nil;
            [self.carousel reloadData];
            self.loading = NO;
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-provider-pages-%@", self.provider.remoteID]];
            self.loading = NO;
        });
    }];
}

-(void)setProvider:(IPKProvider *)provider{
    _provider = provider;
    self.fetchedResultsController = nil;
    [self refresh];
    [self.carousel reloadData];
}

-(NSString*)entityName{
    return @"IPKPage";
}

-(BOOL)ascending{
    return NO;
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
    if (self.fetchedResultsController.fetchedObjects.count == 0 || carousel.numberOfItems > self.fetchedResultsController.fetchedObjects.count){
        return [self loadingViewWithFrame:CGRectMake(0, 5, 300, 90)];
    }
    if (view == nil) {
        IPIPageCarouselView * newView = [[IPIPageCarouselView alloc] initWithFrame:CGRectMake(0, 5, 300, 90)];
        [newView setPage:[self.fetchedResultsController.fetchedObjects objectAtIndex:index]];
        return newView;
    }
    else{
        [((IPIPageCarouselView *)view) setPage:[self.fetchedResultsController.fetchedObjects objectAtIndex:index]];
    }
    return view;
}

#pragma mark - iCarouselDelegate

- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel{
    
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    
}


- (void)carouselDidScroll:(iCarousel *)carousel{
    
}


//- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
//    
//}


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
    IPKPage * page = [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
    IPIPageViewController * pageVC = [[IPIPageViewController alloc] init];
    pageVC.page = page;
    [self.navigationController pushViewController:pageVC animated:YES];
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

#pragma mark - NSFetchedResultsControllerDelegate


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    for (IPKPage* page in self.fetchedResultsController.fetchedObjects) {
        if (!page.owner.image_profile_path) {
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
    [self.carousel reloadData];
}

@end
