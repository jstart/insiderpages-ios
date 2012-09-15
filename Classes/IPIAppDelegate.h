//
//  IPIAppDelegate.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman on 8/7/12.
//
#import <FacebookSDK/FacebookSDK.h>
#import "RCLocationManager.h"
#import "IPIBookmarkContainerViewController.h"

@interface IPIAppDelegate : UIResponder <UIApplicationDelegate, RCLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) RCLocationManager * locationManager;
@property (strong, nonatomic) CLGeocoder * geocoder;
@property (strong, nonatomic) UINavigationController * bookmarkNavigationController;

+ (void)applyStylesheet;
+ (IPIAppDelegate *)sharedAppDelegate;
- (void) openSessionCheckCache:(BOOL)check;

-(void)login;
-(void)registerOrLogin;
-(void)requestLocation;

@end
