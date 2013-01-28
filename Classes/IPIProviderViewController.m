//
//  IPIProviderViewController
//

#import "IPIProviderViewController.h"
#import "TTTAttributedLabel.h"
#import "IPIPageActivityCell.h"
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
    self.title = self.provider.full_name;
    [self.headerView setProvider:self.provider];
    MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.provider.address.lat doubleValue], [self.provider.address.lng doubleValue]);
    [point setCoordinate:coordinate];
    [self.mapView addAnnotation:point];
    
    MKMapRect mapRect = MKMapRectMake(coordinate.latitude, coordinate.longitude, 100, 100);
    [self.mapView setVisibleMapRect:mapRect animated:YES];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.provider.address.lat doubleValue], [self.provider.address.lng doubleValue]) animated:YES];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
    [self.callButton setPhoneNumber:_provider.address.phone];
    if (_provider.full_name == nil) {
        [_provider updateWithSuccess:^(){
            dispatch_async(dispatch_get_main_queue(), ^{
                _provider = [IPKProvider objectWithRemoteID:_provider.remoteID];
                self.title = _provider.full_name;
                [self.headerView setProvider:_provider];
                [self.callButton setPhoneNumber:_provider.address.phone];
                MKPointAnnotation * point = [[MKPointAnnotation alloc] init];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_provider.address.lat doubleValue], [_provider.address.lng doubleValue]);
                [point setCoordinate:coordinate];
                [self.mapView addAnnotation:point];
                
                MKMapRect mapRect = MKMapRectMake(coordinate.latitude, coordinate.longitude, 100, 100);
                [self.mapView setVisibleMapRect:mapRect animated:YES];
                [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([_provider.address.lat doubleValue], [_provider.address.lng doubleValue]) animated:YES];
            });
        } failure:^(AFJSONRequestOperation * op, NSError * err){
            
        }];
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [self.view setBackgroundColor:[UIColor standardBackgroundColor]];
    [self.tableView setBackgroundColor:[UIColor standardBackgroundColor]];

    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 148)];
    [[self view] addSubview:self.mapView];

    self.headerView = [[IPIProviderViewHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 148)];
    [self.headerView setDelegate:self];
    [self.view addSubview:self.headerView];
    
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    self.callButton = [IPICallButton standardCallButton];
    CGRect frame = self.callButton.frame;
    frame.origin.x = 55;
    frame.origin.y = 20;
    [self.callButton setFrame:frame];
    [tableHeaderView addSubview:self.callButton];
    [self.tableView setTableHeaderView:tableHeaderView];
    
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:7 forBarMetrics:UIBarMetricsDefault];
    [self.tableView setFrame:CGRectMake(0, 148, 320, [UIScreen mainScreen].bounds.size.height-200+32)];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
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

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void (^)(void))refresh{
    return ^(void){
        self.currentPage = @1;
        if (self.loading) {
            return ;
        }
        self.loading = YES;
        NSString * providerIDString = [NSString stringWithFormat:@"%@", self.provider.remoteID];
        [[IPKHTTPClient sharedClient] getPagesForProviderWithId:providerIDString withCurrentPage:self.currentPage perPage:self.perPage success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.fetchedResultsController = nil;
                [self.tableView reloadData];
                self.loading = NO;
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:[NSString stringWithFormat:@"refresh-provider-pages-%@", self.provider.remoteID]];
                self.loading = NO;
            });
        }];
    };
}

#pragma mark - SSManagedTableViewController

- (NSFetchRequest *)fetchRequest {
	NSFetchRequest * fetchRequest = [super fetchRequest];
    [fetchRequest setReturnsDistinctResults:YES];
	return fetchRequest;
}

- (Class)entityClass {
    return [IPKPage class];
}

- (NSPredicate *)predicate {
//	return [NSPredicate predicateWithFormat:@"ANY teamMemberships.listing == %@", ];
    return [NSPredicate predicateWithFormat:@"(0 != SUBQUERY(teamMemberships, $teamMembership, $teamMembership.listing == %@).@count)", self.provider];
}

-(NSArray *)sortDescriptors{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	IPIPageActivityCell *pageCell = (IPIPageActivityCell *)cell;
	pageCell.page = ((IPKPage*)[self objectForViewIndexPath:indexPath]);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
	
	IPIPageActivityCell *cell = (IPIPageActivityCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPIPageActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.editing = NO;
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	return self.addTaskView;
//}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [IPIPageActivityCell cellHeight] + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
//    NSLog(@"%@", controller.fetchedObjects);
}

@end
