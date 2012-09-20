//
//  UIFont+InsiderPagesiOSAdditions.m
//  InsiderPages for iOS
//

#import "UIFont+InsiderPagesiOSAdditions.h"

@implementation UIFont (InsiderPagesiOSAdditions)

+ (UIFont *)cheddarFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIRegularFontName size:fontSize];
}


+ (UIFont *)boldCheddarFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIBoldFontName size:fontSize];
}


+ (UIFont *)boldItalicCheddarFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIBoldItalicFontName size:fontSize];
}


+ (UIFont *)italicCheddarFontOfSize:(CGFloat)fontSize {
	return [self fontWithName:kCDIItalicFontName size:fontSize];
}

@end
