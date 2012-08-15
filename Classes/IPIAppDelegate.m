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
//#import "IPILeftPagesViewController.h"
#import "IPIAccordionViewController.h"
#import "CDISignUpViewController.h"
#import "IIViewDeckController.h"
#import "CDIDefines.h"
#import "UIFont+CheddariOSAdditions.h"
#import "LocalyticsUtilities.h"
#import "UISS.h"
#import "UISSStatusWindow.h"

//#import <Crashlytics/Crashlytics.h>
#ifdef INSIDER_PAGES_API_DEVELOPMENT_MODE
    #import "DCIntrospect.h"
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
#if INSIDER_PAGES_PRODUCTION_MODE
	#ifdef INSIDER_PAGES_CRASHLYTICS_KEY
	[Crashlytics startWithAPIKey:CHEDDAR_CRASHLYTICS_KEY];
	#endif

	#ifdef INSIDER_PAGES_LOCALYTICS_KEY
	LLStartSession(CHEDDAR_LOCALYTICS_KEY);
	#endif
#endif
	
	// Optionally enable development mode
	// If you don't work at Nothing Magical, you shouldn't turn this on.
#ifdef INSIDER_PAGES_API_DEVELOPMENT_MODE
	[IPKHTTPClient setDevelopmentModeEnabled:YES];
//	[CDKPushController setDevelopmentModeEnabled:YES];
#endif
    
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
//    IPILeftPagesViewController * leftPagesViewController = [[IPILeftPagesViewController alloc] init];
    IPIAccordionViewController * accordionViewController = [[IPIAccordionViewController alloc] init];
    UINavigationController *leftPagesNavigationController = [[UINavigationController alloc] initWithRootViewController:accordionViewController];

    IIViewDeckController * viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:activityNavigationController leftViewController:accordionViewController];
    [viewDeckController setPanningMode:IIViewDeckPanningViewPanning];
    self.window.rootViewController = viewDeckController;
	[self.window makeKeyAndVisible];
    
    #if TARGET_IPHONE_SIMULATOR
        [[DCIntrospect sharedIntrospector] start];
    #endif

	// Defer some stuff to make launching faster
	dispatch_async(dispatch_get_main_queue(), ^{
		// Setup status bar network indicator
		[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
				
		// Initialize the connection to Pusher		
//		[CDKPushController sharedController];
		
		// Add the transaction observer
//		[[SKPaymentQueue defaultQueue] addTransactionObserver:[CDITransactionObserver defaultObserver]];
	});
    
#if INSIDER_PAGES_TESTING_MODE
    [TestFlight takeOff:@"30d92a896df4ab4b4873886ea58f8b06_NzE0NzIyMDEyLTAzLTE0IDEzOjQ0OjU4Ljk3MDAxOQ"];
#endif
    
	return YES;
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
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        [[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"id"] forKey:@"FBUserId"];
        [[IPKHTTPClient sharedClient] signInWithFacebookUserID:[result objectForKey:@"id"] accessToken:self.session.accessToken facebookMeResponse:result success:^(AFJSONRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"message"] isEqualToString:@"logged in"]) {
                [self storeCookies];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud completeAndDismissWithTitle:@"Successfully Logged In"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logged In" object:nil];
                });
            }else{
                [self storeCookies];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud completeAndDismissWithTitle:@"Successfully Registered"];
                });
            }
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }];
    }];
}

-(void)storeCookies{
    NSHTTPCookie *cookie = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] objectAtIndex:0];
    NSMutableDictionary* cookieDictionary = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SavedCookies"]];
    [cookieDictionary setValue:cookie.properties forKey:@"http://local.insiderpages.com"];
    [[NSUserDefaults standardUserDefaults] setObject:cookieDictionary forKey:@"SavedCookies"];
}

-(void)reloadCookies{
    NSDictionary* cookieDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SavedCookies"];
    NSDictionary* cookieProperties = [cookieDictionary valueForKey:@"http://local.insiderpages.com"];
        if (cookieProperties != nil) {
            NSMutableDictionary* mutableCookieProperties = [cookieProperties mutableCopy];
            [mutableCookieProperties setObject:@"local.insiderpages.com" forKey:@"Domain"];

            NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:mutableCookieProperties];
            NSArray* cookieArray = [NSArray arrayWithObject:cookie];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookieArray forURL:[NSURL URLWithString:@"http://local.insiderpages.com"] mainDocumentURL:nil];
    }
}

-(void)login{
    SSHUDView *hud = [[SSHUDView alloc] initWithTitle:@"Logging in..." loading:YES];
	[hud show];
    [[IPKHTTPClient sharedClient] signInWithFacebookUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBUserId"] accessToken:self.session.accessToken facebookMeResponse:[NSDictionary dictionary] success:^(AFJSONRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"message"] isEqualToString:@"logged in"]) {
            [self storeCookies];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud completeAndDismissWithTitle:@"Successfully Logged In"];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud completeAndDismissWithTitle:@"Successfully Registered"];
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
            }else{
                UIViewController *viewController = [[IPIActivityViewController alloc] initWithStyle:UITableViewStyleGrouped];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                self.window.rootViewController = navigationController;
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to 
            // be looking at the root view.
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

#if ANALYTICS_ENABLED
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}
#endif


- (void)applicationWillTerminate:(UIApplication *)application {
	[[SSManagedObject mainContext] save:nil];
	#if ANALYTICS_ENABLED
    [[LocalyticsSession sharedLocalyticsSession] close];
	#endif
    // if the app is going away, we close the session object
}


-(void)applyStylesheet {
    self.uiss = [[UISS alloc] init];
    self.uiss.style.url = [NSURL URLWithString:@"file://localhost/Users/trumanc/Desktop/insiderpages-ios/Resources/Stylesheets/style.json"];
    self.uiss.statusWindowEnabled = YES;
    [self.uiss registerReloadGestureRecognizerInView:self.window];
  
    [self.uiss load];
#if TARGET_IPHONE_SIMULATOR
    [self.uiss enableAutoReloadWithTimeInterval:3];
#endif
    
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

@end
