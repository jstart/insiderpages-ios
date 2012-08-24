//
//  IPISocialShareHelper.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "IPIAppDelegate.h"

@interface IPISocialShareHelper : NSObject

+(void)tweetPage:(IPKPage*)page fromViewController:(UIViewController*)viewController;
+(void)tweetProvider:(IPKProvider*)provider fromViewController:(UIViewController*)viewController;

+(void)facebookPostPage:(IPKPage*)page fromViewController:(UIViewController*)viewController;
+(void)facebookPostProvider:(IPKProvider*)provider fromViewController:(UIViewController*)viewController;

@end
