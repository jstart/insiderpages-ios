//
//  IPIProviderViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import <MapKit/MapKit.h>

@class IPKProvider;

@interface IPIProviderViewController : UITableViewController

@property (nonatomic, strong) IPKProvider *provider;
@property (nonatomic, strong) MKMapView * mapView;

@end
