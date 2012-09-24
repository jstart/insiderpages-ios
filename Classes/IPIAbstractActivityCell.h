//
//  IPIAbstractActivityCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPIAbstractActivityCell : UITableViewCell

@property (nonatomic, strong) IPKActivity * activity;

- (id)initWithActivity:(IPKActivity*)activity reuseIdentifier:(NSString *)reuseIdentifier;

+(CGFloat)cellHeight;

@end
