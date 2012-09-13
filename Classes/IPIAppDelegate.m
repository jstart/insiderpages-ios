//
//  CDIAppDelegate.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/25/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "IPIAppDelegate.h"
#import "IPISplitViewController.h"
#import "IPIActivityViewController.h"
#import "IPILeftSearchViewController.h"
#import "IPIAccordionViewController.h"
#import "CDISignUpViewController.h"
#import "IIViewDeckController.h"
#import "CDIDefines.h"
#import "UIViewController+KNSemiModal.h"

#import "SDURLCache.h"
#import "UIResponder+KeyboardCache.h"
#import "UIFont+CheddariOSAdditions.h"
#import "LocalyticsUtilities.h"
#import "UISS.h"
#import "UISSStatusWindow.h"

#import <Crashlytics/Crashlytics.h>
 #if TARGET_IPHONE_SIMULATOR
    #import "DCIntrospect.h"
    #import <PonyDebugger/PonyDebugger.h>
#endif

@interface IPIAppDelegate ()

@property (nonatomic, strong) UISS *uiss;
@property (nonatomic, strong) UISSStatusWindow *statusWindow;

@end

@implementation IPIAppDelegate

@synthesize window = _window, uiss, statusWindow;

+ (IPIAppDelegate *)sharedAppDelegate {
	return (IPIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
	// Configure analytics
	// If you don't work at Nothing Magical, you shouldn't turn these on.
	[Crashlytics startWithAPIKey:@"ff6f76d45da103570f8070443d1760ea5199fc81"];

	#ifdef INSIDER_PAGES_LOCALYTICS_KEY
	LLStartSession(CHEDDAR_LOCALYTICS_KEY);
	#endif
    [IPKHTTPClient setDevelopmentModeEnabled:YES];

    [MagicalRecord  setupCoreDataStackWithStoreNamed:@"InsiderPages.sqlite"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[NSManagedObjectContext MR_contextForCurrentThread]];
#define TESTING 0
#ifdef TESTING
    
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    
    [self reloadCookies];

	// Initialize the window
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor blackColor];
	
	[self applyStylesheet];
    [self openSessionCheckCache:YES];
    // To-do, show logged in view

    IPIActivityViewController *viewController = [[IPIActivityViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *activityNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    IPILeftSearchViewController * leftSearchViewController = [[IPILeftSearchViewController alloc] initWithNibName:@"IPILeftSearchViewController" bundle:[NSBundle mainBundle]];
//    IPIAccordionViewController * accordionViewController = [[IPIAccordionViewController alloc] init];
//    UINavigationController *leftPagesNavigationController = [[UINavigationController alloc] initWithRootViewController:accordionViewController];

    IIViewDeckController * viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:activityNavigationController leftViewController:leftSearchViewController];
    [viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [viewDeckController setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];
    UINavigationController * navControllerWrapper = [[UINavigationController alloc] initWithRootViewController:viewDeckController];
    [navControllerWrapper setNavigationBarHidden:YES];
    self.window.rootViewController = navControllerWrapper;
	[self.window makeKeyAndVisible];
    
    #if TARGET_IPHONE_SIMULATOR
        [[DCIntrospect sharedIntrospector] start];
//        dispatch_async(dispatch_get_main_queue(), ^{
            PDDebugger *debugger = [PDDebugger defaultInstance];
            [debugger enableNetworkTrafficDebugging];
            [debugger forwardAllNetworkTraffic];
            [debugger enableCoreDataDebugging];
            [debugger addManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
//        });
    #endif
    
	// Defer some stuff to make launching faster
	dispatch_async(dispatch_get_main_queue(), ^{
        
		// Setup status bar network indicator
		[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
		
		// Add the transaction observer
//		[[SKPaymentQueue defaultQueue] addTransactionObserver:[CDITransactionObserver defaultObserver]];
	});
    
#if INSIDER_PAGES_TESTING_MODE
    [TestFlight takeOff:@"30d92a896df4ab4b4873886ea58f8b06_NzE0NzIyMDEyLTAzLTE0IDEzOjQ0OjU4Ljk3MDAxOQ"];
#endif
    
    [UIResponder cacheKeyboard:YES];
    static const NSUInteger kMemoryCapacity = 0;
    static const NSUInteger kDiskCapacity = 1024*1024*5; // 5MB disk cache
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:kMemoryCapacity
                                                          diskCapacity:kDiskCapacity
                                                              diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:urlCache];
    [self requestLocation];
	return YES;
}

- (void)handleDataModelChange:(NSNotification *)note
{
    NSSet *updatedObjects = [[note userInfo] objectForKey:NSUpdatedObjectsKey];
    NSSet *deletedObjects = [[note userInfo] objectForKey:NSDeletedObjectsKey];
    NSSet *insertedObjects = [[note userInfo] objectForKey:NSInsertedObjectsKey];
    
    // Do something in response to this
    if (updatedObjects)
        NSLog(@"Updated: %d", updatedObjects.count);
    if (deletedObjects)
        NSLog(@"Deleted: %d Objects: %@", deletedObjects.count, deletedObjects);
    if (insertedObjects)
        NSLog(@"Inserted: %d", insertedObjects.count);
}


-(void)showLoginView{
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CDISignUpViewController alloc] init]];
}

-(void)registerOrLogin{
    SSHUDView *hud = [[SSHUDView alloc] initWithTitle:@"Contacting Facebook..." loading:YES];
	[hud show];
    FBRequest *request = [FBRequest requestForMe];
    [request setSession:self.session];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud failAndDismissWithTitle:@"Contacting Facebook Failed"];
                [self registerOrLogin];
            });
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"id"] forKey:@"FBUserId"];
        [[IPKHTTPClient sharedClient] signInWithFacebookUserID:[result objectForKey:@"id"] accessToken:self.session.accessToken facebookMeResponse:result success:^(AFJSONRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"message"] isEqualToString:@"logged in"]) {
                [self storeCookies];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud completeAndDismissWithTitle:@"Successfully Logged In"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logged In" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IPCurrentUserChangedNotification" object:nil];
                });
            }else{
                [self storeCookies];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud completeAndDismissWithTitle:@"Successfully Registered"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IPCurrentUserChangedNotification" object:nil];
                });
            }
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self registerOrLogin];
            });
        }];
    }];
}

-(void)storeCookies{
    NSString * currentAPIHost = [[[[[[IPKHTTPClient sharedClient].baseURL URLByDeletingLastPathComponent] URLByDeletingLastPathComponent] absoluteString] stringByReplacingOccurrencesOfString:@".com/" withString:@".com"] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    NSString * currentAPIKey = [[[[IPKHTTPClient sharedClient].baseURL URLByDeletingLastPathComponent] URLByDeletingLastPathComponent] absoluteString];

    NSLog(@"saved auth cookie %@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    NSLog(@"saved auth cookie for URL %@ %@", currentAPIKey, [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:currentAPIKey]]);

    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:currentAPIKey]];
    if (cookies.count > 0) {
        NSDictionary* cookieDictionary = [[cookies objectAtIndex:0] properties];
        NSDictionary * userDefaultsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:cookieDictionary, currentAPIHost, nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultsDictionary forKey:@"SavedCookies"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

-(void)reloadCookies{
    NSDictionary* cookieDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SavedCookies"];
    NSString * currentAPIHost = [[[[[[IPKHTTPClient sharedClient].baseURL URLByDeletingLastPathComponent] URLByDeletingLastPathComponent] absoluteString] stringByReplacingOccurrencesOfString:@".com/" withString:@".com"] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    NSDictionary* cookieProperties = [cookieDictionary valueForKey:currentAPIHost];
    if (cookieProperties != nil) {
            NSMutableDictionary* mutableCookieProperties = [cookieProperties mutableCopy];
            NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:mutableCookieProperties];
            NSArray* cookieArray = [NSArray arrayWithObject:cookie];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookieArray forURL:[[[IPKHTTPClient sharedClient].baseURL URLByDeletingLastPathComponent] URLByDeletingLastPathComponent] mainDocumentURL:nil];
    }
    NSLog(@"loaded auth cookie %@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
}

-(void)login{
    SSHUDView *hud = [[SSHUDView alloc] initWithTitle:@"Logging in..." loading:YES];
	[hud show];
    [[IPKHTTPClient sharedClient] signInWithFacebookUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBUserId"] accessToken:self.session.accessToken facebookMeResponse:[NSDictionary dictionary] success:^(AFJSONRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"message"] isEqualToString:@"logged in"]) {
            [self storeCookies];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud completeAndDismissWithTitle:@"Successfully Logged In"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Logged In" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IPCurrentUserChangedNotification" object:nil];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud completeAndDismissWithTitle:@"Successfully Registered"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Logged In" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IPCurrentUserChangedNotification" object:nil];
            });
        }
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
}

#pragma mark - Facebook

- (FBSession *)createNewSession
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_likes", 
                            @"read_stream",
                            nil];
    self.session = [[FBSession alloc] initWithPermissions:permissions];
    return self.session;
}

- (void)sessionStateChanged:(FBSession *)session 
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            if (![IPKUser currentUser]) {
                [self registerOrLogin];
                NSLog(@"Register because there is no user id and access token in user defaults.");
            }else{
                NSLog(@"Enter activity screen because there is a user id and access token in user defaults.");
                UIViewController *viewController = [[IPIActivityViewController alloc] initWithStyle:UITableViewStyleGrouped];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                self.window.rootViewController = navigationController;
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:

            [self openSessionCheckCache:NO];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

- (void) openSessionCheckCache:(BOOL)check {
    // Create a new session object
    if (!self.session.isOpen) {
        [self createNewSession];
    }
    // Open the session in two scenarios:
    // - When we are not loading from the cache, e.g. when a login
    //   button is clicked.
    // - When we are checking cache and have an available token,
    //   e.g. when we need to show a logged vs. logged out display.
    if (!check ||
        (self.session.state == FBSessionStateCreatedTokenLoaded)) {
        [self.session openWithCompletionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{
    return [self.session handleOpenURL:url];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
	#if ANALYTICS_ENABLED
    [[LocalyticsSession sharedLocalyticsSession] close];
	#endif
    // if the app is going away, we close the session object
    [self.session close];
}


-(void)applyStylesheet {
//    self.uiss = [[UISS alloc] init];
    
//    [self.uiss registerReloadGestureRecognizerInView:self.window];
    
#if TARGET_IPHONE_SIMULATOR
//    self.uiss.statusWindowEnabled = YES;

//    self.uiss.style.url = [NSURL URLWithString:@"file://localhost/Users/trumanc/Desktop/insiderpages-ios/Resources/Stylesheets/style.json"];
//    [self.uiss load];
//    [self.uiss enableAutoReloadWithTimeInterval:3];
#endif
//    [UISS configureWithDefaultJSONFile];

    
	// Navigation bar
	UINavigationBar *navigationBar = [UINavigationBar appearance];
//	[navigationBar setBackgroundColor:[UIColor grayColor]];
	[navigationBar setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];
	[navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
										   [UIFont cheddarFontOfSize:20.0f], UITextAttributeFont,
										   [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
										   [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
										   [UIColor whiteColor], UITextAttributeTextColor,
										   nil]];
	
	// Navigation bar mini
	[navigationBar setTitleVerticalPositionAdjustment:-2.0f forBarMetrics:UIBarMetricsLandscapePhone];
//	[navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background-mini.png"] forBarMetrics:UIBarMetricsLandscapePhone];
	
	// Navigation button
	NSDictionary *barButtonTitleTextAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
												  [UIFont cheddarFontOfSize:14.0f], UITextAttributeFont,
												  [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
												  [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
												  nil];
	UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
	[barButton setTitlePositionAdjustment:UIOffsetMake(0.0f, 1.0f) forBarMetrics:UIBarMetricsDefault];
	[barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateNormal];
	[barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateHighlighted];
//	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button-highlighted.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
	
	// Navigation back button
	[barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(1.0f, -2.0f) forBarMetrics:UIBarMetricsDefault];
//	[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav-back.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//	[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav-back-highlighted.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

	// Navigation button mini
	[barButton setTitlePositionAdjustment:UIOffsetMake(0.0f, 1.0f) forBarMetrics:UIBarMetricsLandscapePhone];
//	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button-mini.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
//	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button-mini-highlighted.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
	
	// Navigation back button mini
	[barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(1.0f, -2.0f) forBarMetrics:UIBarMetricsLandscapePhone];
//	[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav-back-mini.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
//	[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav-back-mini-highlighted.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
	
	// Toolbar
//	UIToolbar *toolbar = [UIToolbar appearance];
//	[toolbar setBackgroundImage:[UIImage imageNamed:@"navigation-background.png"] forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
//	[toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar-background.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	
	// Toolbar mini
//	[toolbar setBackgroundImage:[UIImage imageNamed:@"navigation-background-mini.png"] forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsLandscapePhone];
//	[toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar-background-mini.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsLandscapePhone];
}

-(void)requestLocation{
    if (!self.locationManager) {
        self.locationManager = [[RCLocationManager alloc] initWithUserDistanceFilter:kCLLocationAccuracyHundredMeters userDesiredAccuracy:kCLLocationAccuracyBest purpose:@"InsiderPages would like to show you nearby businesses and activities." delegate:self];
        [self.locationManager startUpdatingLocation];
    }
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
}

#pragma mark - RCLocationManagerDelegate

- (void)locationManager:(RCLocationManager *)manager didFailWithError:(NSError *)error{
    
}

- (void)locationManager:(RCLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    #warning post notification to update location views
//    [self.geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:
//     
//     ^(NSArray *placemarks, NSError *error) {
//         //Get nearby address
//         CLPlacemark *placemark = [placemarks objectAtIndex:0];
//
//         //String to hold address
//         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//
//         //Print the location to console
//         NSLog(@"I am currently at %@",locatedAt);
//     }];
}

- (void)locationManager:(RCLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
}

- (void)locationManager:(RCLocationManager *)manager didExitRegion:(CLRegion *)region{
    
}

- (void)locationManager:(RCLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    
}

@end
