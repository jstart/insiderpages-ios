//
//  UIView+Rasterize.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/5/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "UIView+Rasterize.h"

@implementation UIView (Rasterize)

+(UIImage*) rasterizeView: (UIView*) object
{
    UIGraphicsBeginImageContextWithOptions(object.frame.size, YES, [UIScreen mainScreen].scale);
    [object.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //now that we are done we return this image back,
    return viewImage;
}

@end
