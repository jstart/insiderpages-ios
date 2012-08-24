//
//  IPISocialShareHelper.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPISocialShareHelper.h"

@class IPKPage, IPKProvider;

@implementation IPISocialShareHelper

+(void)tweetPage:(IPKPage*)page fromViewController:(UIViewController*)viewController{
    TWTweetComposeViewController *tweetComposeViewController = [[TWTweetComposeViewController alloc] init];
    // Optional: set an image, url and initial text
    [tweetComposeViewController addImage:[UIImage imageNamed:@"bookmark.png"]];
    [tweetComposeViewController addURL:[NSURL URLWithString:@"http://qa.insiderpages.com/"]];
    
    NSString * formattedTweet = [NSString stringWithFormat:@"%@ just found %@ on @insiderpages", [IPKUser currentUser].name, page.name];
    [tweetComposeViewController setInitialText:formattedTweet];
    [IPISocialShareHelper presentTweetComposeViewController:tweetComposeViewController fromViewController:viewController];
}

+(void)tweetProvider:(IPKProvider*)provider fromViewController:(UIViewController*)viewController{
    TWTweetComposeViewController *tweetComposeViewController = [[TWTweetComposeViewController alloc] init];
    // Optional: set an image, url and initial text
    [tweetComposeViewController addImage:[UIImage imageNamed:@"bookmark.png"]];
    [tweetComposeViewController addURL:[NSURL URLWithString:@"http://qa.insiderpages.com/"]];
    
    NSString * formattedTweet = [NSString stringWithFormat:@"%@ just found %@ on @insiderpages", [IPKUser currentUser].name, provider.full_name];
    [tweetComposeViewController setInitialText:formattedTweet];
    [IPISocialShareHelper presentTweetComposeViewController:tweetComposeViewController fromViewController:viewController];
}

+(void)presentTweetComposeViewController:(TWTweetComposeViewController*)tweetComposeViewController fromViewController:(UIViewController*)viewController{
    // Show the controller
    [viewController presentModalViewController:tweetComposeViewController animated:YES];
    
    // Called when the tweet dialog has been closed
    tweetComposeViewController.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {
        NSString *title = @"Tweet Status";
        NSString *msg; 
        
        if (result == TWTweetComposeViewControllerResultCancelled)
            msg = @"Tweet compostion was canceled.";
        else if (result == TWTweetComposeViewControllerResultDone)
            msg = @"Tweet composition completed.";
        
        // Show alert to see how things went...
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
        
        // Dismiss the controller
        [viewController dismissModalViewControllerAnimated:YES];
    };
}

+(void)facebookPostPage:(IPKPage*)page fromViewController:(UIViewController*)viewController{
    NSString * device = @"iOS";
    
    NSMutableArray *deviceFilteredFriends = [[NSMutableArray alloc] init];
    [FBRequestConnection startWithGraphPath:@"me/friends" 
                                 parameters:[NSDictionary 
                                             dictionaryWithObjectsAndKeys:
                                             @"id,devices", @"fields",
                                             nil] 
                                 HTTPMethod:nil 
                          completionHandler:^(FBRequestConnection *connection, 
                                              id result, 
                                              NSError *error) {
                              if (!error) {
                                  // Get the result
                                  NSArray *resultData = [result objectForKey:@"data"];
                                  // Check we have data
                                  if ([resultData count] > 0) {
                                      // Loop through the friends returned
                                      for (NSDictionary *friendObject in resultData) {
                                          // Check if devices info available
                                          if ([friendObject objectForKey:@"devices"]) {
                                              NSArray *deviceData = [friendObject 
                                                                     objectForKey:@"devices"];
                                              // Loop through list of devices
                                              for (NSDictionary *deviceObject in deviceData) {
                                                  // Check if there is a device match
                                                  if ([device isEqualToString:
                                                       [deviceObject objectForKey:@"os"]]) {
                                                      // If there is a match, add it to the list
                                                      [deviceFilteredFriends addObject:
                                                       [friendObject objectForKey:@"id"]];
                                                      break;
                                                  }
                                              }
                                          }
                                      }
                                  }
                              }
                              // Send request
                              [self sendFacebookRequest:deviceFilteredFriends];
                          }];
}

+ (void)sendFacebookRequest:(NSArray *) targeted {
    NSDictionary *gift = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"5", @"social_karma",
                          @"1", @"badge_of_awesomeness",
                          nil];
    
    NSMutableDictionary* params = 
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"Learn how to make your iOS apps social.",  @"message",
     gift, @"data",
     nil];
    
    // Filter and only show targeted friends
    if (targeted != nil && [targeted count] > 0) {
        NSString *selectIDsStr = [targeted componentsJoinedByString:@","];
        [params setObject:selectIDsStr forKey:@"suggestions"];
    }
    
}

+(void)facebookPostProvider:(IPKProvider*)provider fromViewController:(UIViewController*)viewController{
    
}

@end
