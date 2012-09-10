//
//  IPIBasePageSegmentViewController.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/10/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//


@protocol IPIBasePageSegmentDelegate

-(void)didSelectProvider:(IPKProvider*)provider;

@end

@interface IPIBasePageSegmentViewController : UIViewController

@property (nonatomic, strong) id <IPIBasePageSegmentDelegate> delegate;

@end
