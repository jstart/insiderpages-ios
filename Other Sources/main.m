//
//  main.m
//  InsiderPages for iOS
//

#import "IPIAppDelegate.h"
//#import "CDITableViewCellDeleteConfirmationControl.h"
#import <objc/runtime.h>

int main(int argc, char *argv[]) {
	@autoreleasepool {
//		// Swizzle archive button
//		Class deleteControl = NSClassFromString([NSString stringWithFormat:@"_%@DeleteConfirmationControl", @"UITableViewCell"]);
//		if (deleteControl) {
//			Method drawRectCustom = class_getInstanceMethod(deleteControl, @selector(drawRect:));
//			Method drawRect = class_getInstanceMethod([CDITableViewCellDeleteConfirmationControl class], @selector(drawRectCustom:));
//			method_exchangeImplementations(drawRect, drawRectCustom);
//		}

		return UIApplicationMain(argc, argv, nil, NSStringFromClass([IPIAppDelegate class]));
	}
}
