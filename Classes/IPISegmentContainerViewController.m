//
//  IPISegmentContainerViewController.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/6/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPISegmentContainerViewController.h"
#import "IPIProviderViewController.h"
#import "IPISocialShareHelper.h"

@implementation IPISegmentContainerViewController

-(id)init{
    if (self = [super init]) {
        self.segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Rankings", @"Debate", nil]];
        [self.segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];

        self.pageViewController = [[IPIPageViewController alloc] init];
        self.pageDisqusViewController = [[IPIPageDisqusViewController alloc] init];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitleView:self.segmentControl];
    
    self.pagedScrollView = [[FireUIPagedScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [self.pagedScrollView setScrollEnabled:NO];
    self.pagedScrollView.segmentedControl = self.segmentControl;
    self.pagedScrollView.pagerDelegate = self;
    [[self view] addSubview:self.pagedScrollView];

    self.pageViewController.delegate = self;
    [self.pagedScrollView addPagedViewController:self.pageViewController animated:NO];
    self.pageDisqusViewController.delegate = self;
    [self.pagedScrollView addPagedViewController:self.pageDisqusViewController animated:NO];
    [self.segmentControl setSelectedSegmentIndex:0];
    [self.pagedScrollView setCurrentPage:0];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:2 forBarMetrics:UIBarMetricsDefault];
}

-(void)setSortUser:(IPKUser *)sortUser{
    _sortUser = sortUser;
    [self.pageViewController setSortUser:sortUser];
    [self.pageDisqusViewController setSortUser:sortUser];
}

-(void)setPage:(IPKPage *)page{
    _page = page;
    [self.pageViewController setPage:page];
    [self.pageDisqusViewController setPage:page];
}
#pragma mark - IPIBasePageSegmentDelegate

-(void)didSelectProvider:(IPKProvider*)provider{
    IPIProviderViewController * providerViewController = [[IPIProviderViewController alloc] init];
    [providerViewController setProvider:provider];
    [self.navigationController pushViewController:providerViewController animated:YES];
}

#pragma mark - FireUIPagedScrollViewDelegate

// Occurs when the current page is changed or a new page is added. Use this callback to update your visual control(in case you dont want to use pageControl or segmentedControl properties)
-(void)firePagerChanged:(FireUIPagedScrollView*)pager pagesCount:(NSInteger)pagesCount currentPageIndex:(NSInteger)currentPageIndex{
    [self.pageDisqusViewController viewWillAppear:YES];
}

@end
