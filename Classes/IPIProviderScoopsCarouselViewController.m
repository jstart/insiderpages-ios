//
//  IPIProviderScoopsCarouselViewController
//

#import "IPIProviderScoopsCarouselViewController.h"
#import "TTTAttributedLabel.h"


@interface IPIProviderScoopsCarouselViewController () <iCarouselDelegate, iCarouselDataSource>
@end

@implementation IPIProviderScoopsCarouselViewController

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
        self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
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
    return 50;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        UIView * newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        newView.backgroundColor = [UIColor whiteColor];
        newView.layer.borderColor = [UIColor blackColor].CGColor;
        return newView;
    }
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel{
    return 3;
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
    return 60;
}


//- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
//    
//}


//- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
//    
//}

@end
