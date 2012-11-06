//
//  UIImageView+Rasterize.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/8/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "UIImageView+Rasterize.h"
#import "NYXImagesKit.h"
#import "UIView+Rasterize.h"

@implementation UIImageView (Rasterize)

static NSMutableDictionary * queueDictionary;

-(NSOperationQueue *)queueForKey:(NSString*)key {
    if (!queueDictionary) {
        queueDictionary = [[NSMutableDictionary alloc] init];
    }
    NSOperationQueue * queue = [queueDictionary objectForKey:key];
    if (!queue) {
        NSOperationQueue * newQueue = [[NSOperationQueue alloc] init];
        [newQueue setMaxConcurrentOperationCount:1];
        [queueDictionary setObject:newQueue forKey:key];
        return newQueue;
    }
    return queue;
}

-(void)loadURLString:(NSString*)URLString forSize:(CGSize)size mode:(NYXCropMode)mode{
    NSURL *profileImageViewURL = [NSURL URLWithString:URLString];
    NSString * cacheKey = [NSString stringWithFormat:@"%@-%@-%@", URLString, NSStringFromCGSize(size), @"rasterized"];
    [[self queueForKey:cacheKey] cancelAllOperations];
    UIImage * cachedImage = [[Nimbus imageMemoryCache] objectWithName:cacheKey];
    if (cachedImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = cachedImage;
        });
    }
    else {
        NSMutableURLRequest *profileImageViewrequest = [NSMutableURLRequest requestWithURL:profileImageViewURL];
        [NSURLConnection sendAsynchronousRequest:profileImageViewrequest queue:[self queueForKey:cacheKey] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"%@ %@", error, cacheKey);
                return;
            }
            UIImage * image = [UIImage imageWithData:data];
            UIImage * formattedImage = [image cropToSize:size usingMode:mode];
            UIImageView * rasterizationView = [[UIImageView alloc] initWithImage:formattedImage];
            UIImage * rasterizedImage = [UIView rasterizeView:rasterizationView];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = rasterizedImage;
            });
            [[Nimbus imageMemoryCache] storeObject:rasterizedImage withName:cacheKey expiresAfter:[NSDate dateWithTimeIntervalSinceNow:3600]];
        }];
    }
}

-(void)loadURLString:(NSString*)URLString forSize:(CGSize)size withSubviews:(NSArray*)subviews mode:(NYXCropMode)mode{
    NSURL *profileImageViewURL = [NSURL URLWithString:URLString];
    NSString * cacheKey = [NSString stringWithFormat:@"%@-%@-%@", URLString, NSStringFromCGSize(size), ((UILabel*)subviews[1]).text];
    [[self queueForKey:cacheKey] cancelAllOperations];
    UIImage * cachedImage = [[Nimbus imageMemoryCache] objectWithName:cacheKey];
    if (cachedImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = cachedImage;
        });
    }
    else {
        NSMutableURLRequest *profileImageViewrequest = [NSMutableURLRequest requestWithURL:profileImageViewURL];
        [NSURLConnection sendAsynchronousRequest:profileImageViewrequest queue:[self queueForKey:cacheKey] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"%@ %@", error, cacheKey);
                return;
            }
            UIImage * image = [UIImage imageWithData:data];
            UIImage * formattedImage = [image cropToSize:size usingMode:mode];
            UIImageView * rasterizationView = [[UIImageView alloc] initWithImage:formattedImage];
            [rasterizationView addSubview:subviews[0]];
            UIImage * rasterizedImage = [UIView rasterizeView:rasterizationView];

            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = rasterizedImage;
                [self addSubview:subviews[1]];
            });
            [[Nimbus imageMemoryCache] storeObject:rasterizedImage withName:cacheKey expiresAfter:[NSDate dateWithTimeIntervalSinceNow:3600]];
        }];
    }
}

@end
