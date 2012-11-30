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
#import "IPICreatePageInitialViewController.h"
#import "CDISignUpViewController.h"
#import "IIViewDeckController.h"
#import "CDIDefines.h"
#import "UIViewController+KNSemiModal.h"
#import "IPISocialShareHelper.h"
#import "UIColor-Expanded.h"
#import "IPIPushNotificationRouter.h"
//#import "iOSHierarchyViewer.h"

#import "SDURLCache.h"
#import "UIResponder+KeyboardCache.h"
#import "UIFont+InsiderPagesiOSAdditions.h"
#import "AFHTTPRequestOperationLogger.h"

#import <Crashlytics/Crashlytics.h>
#if TARGET_IPHONE_SIMULATOR
    #import "DCIntrospect.h"
    #import <PonyDebugger/PonyDebugger.h>
#endif

@interface IPIAppDelegate ()
@end

@implementation IPIAppDelegate

@synthesize window = _window;

+ (IPIAppDelegate *)sharedAppDelegate {
	return (IPIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
	// Configure analytics
	[Crashlytics startWithAPIKey:@"ff6f76d45da103570f8070443d1760ea5199fc81"];
	#ifdef INSIDER_PAGES_LOCALYTICS_KEY
	LLStartSession(CHEDDAR_LOCALYTICS_KEY);
	#endif
    NSString *baseAPIHost = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"baseAPIHost"];
    [IPKHTTPClient setBaseAPIHost:baseAPIHost];
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"InsiderPages.sqlite"];
//    NSLog(@"%@",[[NSManagedObjectContext MR_contextForCurrentThread] persistentStoreCoordinator].managedObjectModel.entities);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[NSManagedObjectContext MR_contextForCurrentThread]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextDidSaveNotification object:[NSManagedObjectContext MR_contextForCurrentThread]];
    [[NSManagedObjectContext MR_contextForCurrentThread] setMergePolicy:NSErrorMergePolicy];
    
#define TESTING 0
#ifdef TESTING
    
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    
    [self reloadCookies];
	[[self class] applyStylesheet];

	// Initialize the window
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor blackColor];
    [self openSessionCheckCache:YES];

    IPIActivityViewController *viewController = [[IPIActivityViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *activityNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    IPILeftSearchViewController * leftSearchViewController = [[IPILeftSearchViewController alloc] initWithNibName:@"IPILeftSearchViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *leftSearchNavigationController = [[UINavigationController alloc] initWithRootViewController:leftSearchViewController];
//    IPIAccordionViewController * accordionViewController = [[IPIAccordionViewController alloc] init];
//    UINavigationController *leftPagesNavigationController = [[UINavigationController alloc] initWithRootViewController:accordionViewController];

    IIViewDeckController * viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:activityNavigationController leftViewController:leftSearchNavigationController];
    [viewDeckController setNavigationControllerBehavior:IIViewDeckNavigationControllerContained];
    [viewDeckController setWantsFullScreenLayout:YES];
    [viewDeckController setPanningMode:IIViewDeckFullViewPanning];
    [viewDeckController setElastic:NO];
    [viewDeckController setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];
    UINavigationController * navControllerWrapper = [[UINavigationController alloc] initWithRootViewController:viewDeckController];
    [navControllerWrapper setNavigationBarHidden:YES];
    [navControllerWrapper setWantsFullScreenLayout:YES];
    self.window.rootViewController = navControllerWrapper;
    [self.window addSubview:[navControllerWrapper view]];
	[self.window makeKeyAndVisible];
    
    #if TARGET_IPHONE_SIMULATOR
        [[DCIntrospect sharedIntrospector] start];
 
        PDDebugger *debugger = [PDDebugger defaultInstance];
        [debugger enableNetworkTrafficDebugging];
        [debugger forwardAllNetworkTraffic];
        [debugger enableCoreDataDebugging];
        [debugger addManagedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        // Enable View Hierarchy debugging. This will swizzle UIView methods to monitor changes in the hierarchy
        // Choose a few UIView key paths to display as attributes of the dom nodes
        [debugger enableViewHierarchyDebugging];
        [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
        [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
    #endif
//    [iOSHierarchyViewer start];
//    [iOSHierarchyViewer addContext:[NSManagedObjectContext MR_contextForCurrentThread] name:@"Root managed context"];
	// Defer some stuff to make launching faster
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [IPISocialShareHelper preloadTweetComposeViewController];
		// Setup status bar network indicator
		[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        [[AFHTTPRequestOperationLogger sharedLogger] startLogging];
        [[AFHTTPRequestOperationLogger sharedLogger] setLevel:AFLoggerLevelError];
		// Add the transaction observer
//		[[SKPaymentQueue defaultQueue] addTransactionObserver:[CDITransactionObserver defaultObserver]];
        [UIResponder cacheKeyboard:YES];
	});
    [self requestLocation];
    
#if INSIDER_PAGES_TESTING_MODE
//    Citysearch
    [TestFlight takeOff:@"e8882c2e107b66d09560e69a3ec1f588_MzY4MzIyMDEyLTAyLTA4IDE3OjQzOjU4Ljg5OTYxNA"];
//    Focus Fox
//    [TestFlight takeOff:@"30d92a896df4ab4b4873886ea58f8b06_NzE0NzIyMDEyLTAzLTE0IDEzOjQ0OjU4Ljk3MDAxOQ"];
#endif
    
    [[IPKHTTPClient sharedClient] getNotificationsWithCurrentPage:@1 perPage:@10 success:^(AFJSONRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationNumber" object:nil userInfo:nil];
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        
    }];
    
	return YES;
}

- (void)handleDataModelChange:(NSNotification *)note
{
    NSSet *updatedObjects = [[note userInfo] objectForKey:NSUpdatedObjectsKey];
    NSSet *deletedObjects = [[note userInfo] objectForKey:NSDeletedObjectsKey];
    NSSet *insertedObjects = [[note userInfo] objectForKey:NSInsertedObjectsKey];
  
  // Do something in response to this
    if (updatedObjects.count > 0){
        NSLog(@"Updated: %d Objects: %@", updatedObjects.count, updatedObjects);
    }
    if (deletedObjects.count > 0){
        NSLog(@"Deleted: %d Objects: %@", deletedObjects.count, deletedObjects);
    }
    if (insertedObjects.count > 0){
        NSLog(@"Inserted: %d Objects: %@", insertedObjects.count, insertedObjects);
    }
    // This ensures no updated object is fault, which would cause the NSFetchedResultsController updates to fail.
    // http://www.mlsite.net/blog/?p=518
    NSArray* updates = [[note.userInfo objectForKey:@"updated"] allObjects];
	for (NSInteger i = [updates count]-1; i >= 0; i--)
	{
		[[[NSManagedObjectContext MR_contextForCurrentThread] objectWithID:[[updates objectAtIndex:i] objectID]] willAccessValueForKey:nil];
	}
    
    [[NSManagedObjectContext MR_contextForCurrentThread] mergeChangesFromContextDidSaveNotification:note];
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveWithErrorCallback:^(NSError *error){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Core Data Error" message:[error description] delegate:nil cancelButtonTitle:@"Tell Chris" otherButtonTitles: nil];
        [alertView show];
        NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
        NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
        if(detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                NSLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
        }
        else {
            NSLog(@"  %@", [error userInfo]);
        }
    }];
}


-(void)showLoginView{
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CDISignUpViewController alloc] init]];
}

-(void)registerOrLogin{
    SSHUDView *hud = [[SSHUDView alloc] initWithTitle:@"Contacting Facebook..." loading:YES];
	[hud show];
    FBRequest *request = [FBRequest requestForMe];
    [request setSession:[FBSession activeSession]];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@ %@", @"Contacting Facebook Failed", error);
//                [hud failAndDismissWithTitle:@"Contacting Facebook Failed"];
//                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Contacting Facebook Failed" message:@"Would you like to try again?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Ok", nil];
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Contacting Facebook Failed" message:[error description] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Ok", nil];
                [alertView show];
            });
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"id"] forKey:@"FBUserId"];
        [[IPKHTTPClient sharedClient] signInWithFacebookUserID:[result objectForKey:@"id"] accessToken:[FBSession activeSession].accessToken facebookMeResponse:result success:^(AFJSONRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"message"] isEqualToString:@"logged in"]) {
                [self storeCookies];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud completeAndDismissWithTitle:@"Successfully Logged In"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logged In" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IPCurrentUserChangedNotification" object:nil];
                    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
                });
            }else{
                [self storeCookies];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud completeAndDismissWithTitle:@"Successfully Registered"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logged In" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IPCurrentUserChangedNotification" object:nil];
                    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
                });
            }
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud failAndDismissWithTitle:@"Contacting QA.InsiderPages Failed"];
                NSLog(@"%@ %@", @"Contacting QA.InsiderPages Failed", error);
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Contacting Facebook Failed" message:@"Would you like to try again?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Ok", nil];
                [alertView show];
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
    [[IPKHTTPClient sharedClient] signInWithFacebookUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBUserId"] accessToken:[FBSession activeSession].accessToken facebookMeResponse:[NSDictionary dictionary] success:^(AFJSONRequestOperation *operation, id responseObject) {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self openSessionCheckCache:YES];
        [self registerOrLogin];
    }
}

#pragma mark - Facebook

- (void)createNewSession
{
    NSArray *permissions = [NSArray arrayWithObjects:@"email", @"user_location", nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      /* handle success + failure in block */
                                      NSLog(@"%@", error);
                                      NSLog(@"%@", session);
                                      if (status == FBSessionStateOpen) {
                                          if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FBUserId"]) {
                                              [self registerOrLogin];
                                          }
                                      }
                                  }];
    
}

- (void)sessionStateChanged:(FBSession *)session 
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            if (![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
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
            break;
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
    if (!check && ![FBSession activeSession].isOpen) {
        NSLog(@"Create new session: %@", [FBSession activeSession]);
        [self createNewSession];
    }
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{
    NSLog(@"OpenURL %@ Session %@", [FBSession activeSession], url);
    if (![[FBSession activeSession] isOpen]) {
        return [[FBSession activeSession] handleOpenURL:url];
    }else{
        [self openSessionCheckCache:YES];
        return YES;
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"application:didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
    NSUUID* uuid = [NSUUID UUID];
    NSString * uuidString = [uuid UUIDString];
    [[IPKHTTPClient sharedClient] registerForNotificationsWithToken:(NSString*)deviceToken uuid:uuidString success:^(AFJSONRequestOperation *operation, id responseObject) {
        
        } failure:^(AFJSONRequestOperation* operation, NSError* error){
        
        }
    ];
    // Register the device token with a webservice
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"application:didReceiveRemoteNotification: %@", userInfo);
    if (application.applicationState != UIApplicationStateActive) {
        UIViewController * pushViewController = [IPIPushNotificationRouter viewControllerForPushNotificationResponse:userInfo];
    //    UINavigationController * navigationControllerWrapper = [[UINavigationController alloc] initWithRootViewController:pushViewController];
    //    [self.window.rootViewController presentModalViewController:navigationControllerWrapper animated:YES];
        [((UINavigationController*)((IIViewDeckController*)((UINavigationController*)self.window.rootViewController).topViewController).centerController) pushViewController:pushViewController animated:YES];
    }else{
        //update notification ribbon
        [[IPKHTTPClient sharedClient] getNotificationsWithCurrentPage:@1 perPage:@10 success:^(AFJSONRequestOperation *operation, id responseObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationNumber" object:nil userInfo:nil];
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [[IPKHTTPClient sharedClient] getNotificationsWithCurrentPage:@1 perPage:@10 success:^(AFJSONRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationNumber" object:nil userInfo:nil];
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

    [MagicalRecord cleanUp];
	#if ANALYTICS_ENABLED
    [[LocalyticsSession sharedLocalyticsSession] close];
	#endif
    // if the app is going away, we close the session object
    [[FBSession activeSession] close];
}


+(void)applyStylesheet {
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
    
    [navigationBar setTitleVerticalPositionAdjustment:7 forBarMetrics:UIBarMetricsDefault];
	[navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
										   [UIFont fontWithName:@"Comfortaa" size:17.5f], UITextAttributeFont,
										   [UIColor colorWithWhite:0.0f alpha:1.0f], UITextAttributeTextShadowColor,
										   [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
										   [UIColor colorWithHexString:@"a2a2a2"], UITextAttributeTextColor,
										   nil]];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"header_background.png"] forBarMetrics:UIBarMetricsDefault];

	// Navigation bar mini
    UINavigationBar *navigationBarActivityFeed = [UINavigationBar appearanceWhenContainedIn:[IIViewDeckController class], nil];
	[navigationBarActivityFeed setBackgroundImage:[UIImage imageNamed:@"header_background.png"] forBarMetrics:UIBarMetricsDefault];
    [navigationBarActivityFeed setTitleVerticalPositionAdjustment:2 forBarMetrics:UIBarMetricsDefault];

	// Navigation button
//	NSDictionary *barButtonTitleTextAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
//												  [UIFont cheddarFontOfSize:14.0f], UITextAttributeFont,
//												  [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
//												  [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)], UITextAttributeTextShadowOffset,
//												  nil];
//	UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
//	[barButton setTitlePositionAdjustment:UIOffsetMake(10.0f, 10.0f) forBarMetrics:UIBarMetricsDefault];
//	[barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateNormal];
//	[barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateHighlighted];
//	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button-highlighted.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
	
	// Navigation back button
//	[barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(-1.0f, -5.0f) forBarMetrics:UIBarMetricsDefault];
//	[barButton setBackButtonBackgroundImage:[UIImage imageNamed:@"backbutton.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//	[barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"nav-back-highlighted.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

	// Navigation button mini
//	[barButton setTitlePositionAdjustment:UIOffsetMake(0.0f, 1.0f) forBarMetrics:UIBarMetricsLandscapePhone];
//	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button-mini.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
//	[barButton setBackgroundImage:[[UIImage imageNamed:@"nav-button-mini-highlighted.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
	
	// Navigation back button mini
//	[barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(1.0f, -2.0f) forBarMetrics:UIBarMetricsLandscapePhone];
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
