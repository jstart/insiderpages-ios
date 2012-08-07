//
//  CDKTask+CheddariOSAdditions.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/25/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

@interface IPKProvider (CheddariOSAdditions)

- (NSAttributedString *)attributedDisplayText;
- (void)addEntitiesToAttributedString:(NSMutableAttributedString *)attributedString;

@end
