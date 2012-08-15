//
//  IPIAppDelegate.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman on 8/7/12.
//
#import <FacebookSDK/FacebookSDK.h>

@interface IPIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *session;

- (void)applyStylesheet;
+ (IPIAppDelegate *)sharedAppDelegate;
- (void) openSessionCheckCache:(BOOL)check;

-(void)login;
-(void)registerOrLogin;

@end
