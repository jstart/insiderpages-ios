//
//  IPIAbstractActivityCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIAbstractActivityCell.h"

@implementation IPIAbstractActivityCell

@synthesize activity = _activity;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeight{
//    should be overidden by subclass
    return 0;
}

@end
