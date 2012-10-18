//
//  IPIProviderViewController
//

#import "IPIProviderViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIProviderTableViewCell.h"
#import "IPIProviderHeaderTableViewCell.h"
#import "IPIProviderViewHeader.h"
#import "IPIAddToPageViewController.h"
#import "IPISocialShareHelper.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIFont+InsiderPagesiOSAdditions.h"

@interface IPIProviderViewController () <IPIProviderViewHeaderDelegate, TTTAttributedLabelDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@end

@implementation IPIProviderViewController

@synthesize provider = _provider;

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
//		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tasks" style:UIBarButtonItemStyleBordered target:nil action:nil];
    }
	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setProvider:(IPKProvider *)provider{
    _provider = provider;
    [self.pagesCarousel setProvider:provider];
    self.title = self.provider.full_name;
    [self.headerView setProvider:self.provider];
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.provider.address.lat doubleValue], [self.provider.address.lng doubleValue]);
    [point setCoordinate:coordinate];
    [self.mapView addAnnotation:point];
    
    MKMapRect mapRect = MKMapRectMake(coordinate.latitude, coordinate.longitude, 100, 100);
    [self.mapView setVisibleMapRect:mapRect animated:YES];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.provider.address.lat doubleValue], [self.provider.address.lng doubleValue]) animated:YES];
    if (provider.full_name == nil) {
        [provider updateWithSuccess:^(){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pagesCarousel setProvider:provider];
                self.title = self.provider.full_name;
                [self.headerView setProvider:self.provider];
                MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.provider.address.lat doubleValue], [self.provider.address.lng doubleValue]);
                [point setCoordinate:coordinate];
                [self.mapView addAnnotation:point];
                
                MKMapRect mapRect = MKMapRectMake(coordinate.latitude, coordinate.longitude, 100, 100);
                [self.mapView setVisibleMapRect:mapRect animated:YES];
                [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.provider.address.lat doubleValue], [self.provider.address.lng doubleValue]) animated:YES];
            });
        } failure:^(AFJSONRequestOperation * op, NSError * err){
            
        }];
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor grayColor];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    [[self view] addSubview:self.mapView];

    self.headerView = [[IPIProviderViewHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    [self.headerView setDelegate:self];
    [self.view addSubview:self.headerView];
    
    self.pagesCarousel = [[IPIProviderPagesCarouselViewController alloc] init];
    [self addChildViewController:self.pagesCarousel];
    self.pagesCarousel.view.frame = CGRectMake(0, 180, 320, 115);
    [[self view] addSubview:self.pagesCarousel.view];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:7 forBarMetrics:UIBarMetricsDefault];

//    self.scoopsCarousel = [[IPIProviderScoopsCarouselViewController alloc] init];
//    [self.scoopsCarousel setProvider:self.provider];
//    [self addChildViewController:self.scoopsCarousel];
//    self.scoopsCarousel.view.frame = CGRectMake(0, 295, 320, 160);
//    [[self view] addSubview:self.scoopsCarousel.view];
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
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
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

#pragma mark - IPIProviderHeaderViewDelegate
-(void)callButtonPressed:(IPKProvider*)provider{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString * phoneNumberFormatted = [NSString stringWithFormat:@"tel:%@",self.provider.address.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberFormatted]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

-(void)directionButtonPressed:(IPKProvider*)provider{
    NSString * locationFormatted = [NSString stringWithFormat:@"%@ %@",self.provider.address.address_1, self.provider.address.zip_code];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.provider.address.lat doubleValue], [self.provider.address.lng doubleValue]);
    NSString * mapsURLFormatted = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",coord.latitude, coord.longitude, locationFormatted];
    if ([NSClassFromString(@"MKMapItem") instancesRespondToSelector:@selector(isCurrentLocation)]){
        NSDictionary * addressDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.provider.address.address_1, kABPersonAddressStreetKey, self.provider.address.city, kABPersonAddressCityKey, self.provider.address.zip_code, kABPersonAddressZIPKey, nil];
        MKPlacemark * placemark = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:addressDictionary];
        MKMapItem * mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [MKMapItem openMapsWithItems:@[ mapItem ] launchOptions:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapsURLFormatted]];
    }
}

-(void)shareButtonPressed:(IPKProvider*)provider{
    [IPISocialShareHelper tweetProvider:provider fromViewController:self];
}

-(void)addToPageButtonPressed:(IPKProvider*)provider{
    IPIAddToPageViewController * addToPageViewController = [[IPIAddToPageViewController alloc] initWithStyle:UITableViewStylePlain];
    addToPageViewController.provider = self.provider;
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:addToPageViewController];
    [self presentModalViewController:navController animated:YES];
}

@end
