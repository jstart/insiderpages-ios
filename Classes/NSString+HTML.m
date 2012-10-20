//
//  NSString+HTML.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/19/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)

-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [[s stringByReplacingCharactersInRange:r withString:@""] stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    return s;
}
@end
