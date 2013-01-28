//
//  IPIRankPageActivityCell.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 11/5/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIRankPageActivityCell.h"
#import "IPIProviderActivityCell.h"

@implementation IPIRankPageActivityCell

@synthesize activity = _activity;

- (void)setActivity:(IPKActivity *)activity {
    if (_activity != activity) {
        _activity = activity;

        int count = 0;
        if (activity.top_listings.count > 3) {
            [self showAllProviderCells];
            count = 2;
        }else if(activity.top_listings.count == 0){
            [self hideAllProviderCells];
            count = 0;
        }else{
            count = activity.top_listings.count;
            [self showProviderCells:count];
            [self hideProviderCells:count];
        }
        for (int i = 0; i < count; i++) {
            IPIProviderActivityCell * providerCell = [self.providerCellArray objectAtIndex:i];
            providerCell.nameLabel.text = ((IPKProvider *)[activity.top_listings objectAtIndex:i]).full_name;
            providerCell.rankLabel.text = [NSString stringWithFormat:@"%d", i+1];
        }
    }
    [self setNeedsLayout];
}

-(void)hideProviderCells:(int)cellsToHide{
    for (int i = 2; i >= cellsToHide; i--) {
        IPIProviderActivityCell * providerCell = [self.providerCellArray objectAtIndex:i];
        providerCell.hidden = YES;
    }
}

-(void)showProviderCells:(int)cellsToShow{
    for (int i = 0; i <= cellsToShow; i++) {
        IPIProviderActivityCell * providerCell = [self.providerCellArray objectAtIndex:i];
        providerCell.hidden = NO;
    }
}

-(void)hideAllProviderCells{
    for (IPIProviderActivityCell * providerCell in self.providerCellArray) {
        providerCell.hidden = YES;
    }
}

-(void)showAllProviderCells{
    for (IPIProviderActivityCell * providerCell in self.providerCellArray) {
        providerCell.hidden = NO;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.providerCellArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            IPIProviderActivityCell * providerCell = [[IPIProviderActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IPIProviderActivityCell"];
            CGRect frame = providerCell.frame;
            int padding = i * 10;
            frame.origin.y = (i * [IPIProviderActivityCell cellHeight]) + padding;
            providerCell.frame = frame;
            [self addSubview:providerCell];
            [self.providerCellArray addObject:providerCell];
        }
        
    }
    return self;
}

+(CGFloat)cellHeightForActivity:(IPKActivity *)activity{
    int count = 0;
    if (activity.top_listings.count > 3) {
        count = 2;
    }else if(activity.top_listings.count == 0){
        count = 0;
    }else{
        count = activity.top_listings.count;
    }
    return 50 * count;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
