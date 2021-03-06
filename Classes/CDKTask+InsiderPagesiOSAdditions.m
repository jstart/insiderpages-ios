//
//  CDKTask+InsiderPagesiOSAdditions.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/25/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDKTask+InsiderPagesiOSAdditions.h"
#import "TTTAttributedLabel.h"

@implementation IPKProvider (InsiderPagesiOSAdditions)
- (NSAttributedString *)attributedDisplayText {
	if (!self.displayText) {
		if (!self.text) {
			return nil;
		}
		return [[NSAttributedString alloc] initWithString:self.text];
	}
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.displayText];
	CTFontRef regularFont = CTFontCreateWithName((__bridge CFStringRef)kCDIRegularFontName, 20.0f, NULL);
	if (regularFont) {
		[attributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)regularFont range:NSMakeRange(0, self.displayText.length)];
	}
	[self addEntitiesToAttributedString:attributedString];
	return attributedString;
}


- (void)addEntitiesToAttributedString:(NSMutableAttributedString *)attributedString {
	// TODO: Cache fonts
	CTFontRef italicFont = NULL;
	CTFontRef boldFont = NULL;
	CTFontRef boldItalicFont = NULL;
	CTFontRef codeFont = NULL;
	
	// Add entities
	for (NSDictionary *entity in self.entities) {
		NSArray *indices = [entity objectForKey:@"display_indices"];
		NSRange range = NSMakeRange([[indices objectAtIndex:0] unsignedIntegerValue], 0);
		range.length = [[indices objectAtIndex:1] unsignedIntegerValue] - range.location;
		range = [attributedString.string composedRangeWithRange:range];
		
		// Skip malformed entities
		if (range.length > self.displayText.length) {
			continue;
		}
		
		NSString *type = [entity objectForKey:@"type"];
		
		// Italic
		if ([type isEqualToString:@"emphasis"]) {
			if (!italicFont) {
				italicFont = CTFontCreateWithName((__bridge CFStringRef)kCDIItalicFontName, 20.0f, NULL);
			}
			[attributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)italicFont range:range];
		}
		
		// Bold
		else if ([type isEqualToString:@"double_emphasis"]) {
			if (!boldFont) {
				boldFont = CTFontCreateWithName((__bridge CFStringRef)kCDIBoldFontName, 20.0f, NULL);
			}
			[attributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:range];
		}
		
		// Bold Italic
		else if ([type isEqualToString:@"triple_emphasis"]) {
			if (!boldItalicFont) {
				boldItalicFont = CTFontCreateWithName((__bridge CFStringRef)kCDIBoldItalicFontName, 20.0f, NULL);
			}
			[attributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldItalicFont range:range];
		}
		
		// Strikethrough
		else if ([type isEqualToString:@"strikethrough"]) {
			[attributedString addAttribute:kTTTStrikeOutAttributeName value:[NSNumber numberWithBool:YES] range:range];
		}
		
		// Code
		else if ([type isEqualToString:@"code"]) {
			if (!codeFont) {
				codeFont = CTFontCreateWithName((__bridge CFStringRef)@"Courier", 20.0f, NULL);
			}
			[attributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)codeFont range:range];
		}
	}
	
	if (italicFont) {
		CFRelease(italicFont);
	}
	
	if (boldFont) {
		CFRelease(boldFont);
	}
	
	if (boldItalicFont) {
		CFRelease(boldItalicFont);
	}
	
	if (codeFont) {
		CFRelease(codeFont);
	}
}

@end
