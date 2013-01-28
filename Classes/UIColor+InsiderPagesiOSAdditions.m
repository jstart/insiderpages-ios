//
//  UIColor+InsiderPagesiOSAdditions.m
//  InsiderPages for iOS
//

#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIColor-Expanded.h"

@implementation UIColor (InsiderPagesiOSAdditions)

+ (UIColor *)cheddarArchesColor {
	return [self colorWithPatternImage:[UIImage imageNamed:@"arches.png"]];
}


+ (UIColor *)cheddarTextColor {
	return [self colorWithWhite:0.267f alpha:1.0f];
}


+ (UIColor *)cheddarLightTextColor {
	return [self colorWithWhite:0.651f alpha:1.0f];
}


+ (UIColor *)cheddarBlueColor {
	return [self colorWithRed:0.031f green:0.506f blue:0.702f alpha:1.0f];
}


+ (UIColor *)cheddarSteelColor {
	return [self colorWithRed:0.376f green:0.408f blue:0.463f alpha:1.0f];
}


+ (UIColor *)cheddarHighlightColor {
	return [self colorWithRed:1.000f green:0.996f blue:0.792f alpha:1.0f];
}

+(UIColor *)standardBackgroundColor{
    return  [self colorWithHexString:@"e9e9e9"];
}

+(UIColor *)pulloutBackgroundColor{
    return [self colorWithHexString:@"3a3b3f"];
}

@end
