//
//  IPISegmentContainerViewController.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/6/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIBookmarkBaseViewController.h"
#import "FireUIPagedScrollView.h"
#import "IPIPageViewController.h"
#import "IPIPageDisqusViewController.h"

@class IPKPage;

@interface IPISegmentContainerViewController : IPIBookmarkBaseViewController <FireUIPagedScrollViewDelegate, IPIBasePageSegmentDelegate>

@property (strong, nonatomic) UISegmentedControl *segmentControl;
@property (strong, nonatomic) FireUIPagedScrollView * pagedScrollView;
@property (strong, nonatomic) IPIPageViewController * pageViewController;
@property (strong, nonatomic) IPIPageDisqusViewController * pageDisqusViewController;

@property (strong, nonatomic) IPKPage * page;

@end
