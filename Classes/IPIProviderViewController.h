//
//  IPIProviderViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "IPIBookmarkBaseManagedViewController.h"
#import "IPICallButton.h"

@class IPKProvider;
@class IPIProviderViewHeader;

@interface IPIProviderViewController : IPIBookmarkBaseManagedViewController

@property (nonatomic, strong) IPKProvider *provider;
@property (nonatomic, strong) MKMapView * mapView;
@property (nonatomic, strong) IPIProviderViewHeader * headerView;
@property (nonatomic, strong) IPICallButton * callButton;

@end
