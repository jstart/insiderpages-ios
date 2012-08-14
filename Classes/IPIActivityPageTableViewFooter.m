//
//  IPIActivityPageTableViewFooter.m
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/10/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIActivityPageTableViewFooter.h"

@implementation IPIActivityPageTableViewFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.providersButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 30, 20)];
        self.providersButton.backgroundColor = [UIColor blackColor];
        [self addSubview:self.providersButton];
        
        self.collaboratorsButton = [[UIButton alloc] initWithFrame:CGRectMake(15 + 30 + 5, 5, 30, 20)];
        self.collaboratorsButton.backgroundColor = [UIColor blackColor];
        [self addSubview:self.collaboratorsButton];
    }

    return self;
}

-(void)setPage:(IPKPage *)page{
    if (_page != page) {
        _page = page;
        NSString * providerCountString = [NSString stringWithFormat:@"%d", page.providers.count];
        [self.providersButton setTitle:providerCountString forState:UIControlStateNormal];
        
        NSString * collaboratorsCountString = [NSString stringWithFormat:@"%d", arc4random()%21];
        [self.collaboratorsButton setTitle:collaboratorsCountString forState:UIControlStateNormal];
    }
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
