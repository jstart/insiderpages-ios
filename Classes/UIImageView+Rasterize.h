//
//  UIImageView+Rasterize.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/8/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "NYXImagesKit.h"

@interface UIImageView (Rasterize)

-(void)loadURLString:(NSString*)URLString forSize:(CGSize)size mode:(NYXCropMode)mode;

-(void)loadURLString:(NSString*)URLString forSize:(CGSize)size withSubviews:(NSArray*)subviews mode:(NYXCropMode)mode;

@end
