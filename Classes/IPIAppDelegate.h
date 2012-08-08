//
//  IPIAppDelegate.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman on 8/7/12.
//

@interface IPIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)applyStylesheet;
+ (IPIAppDelegate *)sharedAppDelegate;

@end
