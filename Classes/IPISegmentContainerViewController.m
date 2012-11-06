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
#import "UIColor-Expanded.h"

@implementation IPISegmentContainerViewController

-(id)init{
    if (self = [super init]) {
        self.segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Rankings", @"Debate", nil]];
        [self.segmentControl setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"Myriad Web Pro" size:13], UITextAttributeTextColor : [UIColor colorWithHexString:@"a2a2a2"]} forState:UIControlStateNormal];
        [self.segmentControl setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"Myriad Web Pro" size:13], UITextAttributeTextColor : [UIColor colorWithHexString:@"ffffff"]} forState:UIControlStateSelected];

        [self.segmentControl setFrame:CGRectMake(0, 0, 142, 31)];
        [self.segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"toggle_ranking_active.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        self.pageViewController = [[IPIPageViewController alloc] init];
        [self addChildViewController:self.pageViewController];
        self.pageDisqusViewController = [[IPIPageDisqusViewController alloc] init];
        [self addChildViewController:self.pageDisqusViewController];
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
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
}

- (void)presentBookmarkViewController{
    [self.pageDisqusViewController bookmarkTapped];
    [super presentBookmarkViewController];
}

-(void) bookmarkViewWasDismissed:(int)homePageIndex{
    [super bookmarkViewWasDismissed:0];
    [self.pageDisqusViewController bookmarkClosed];
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
    [self.navigationController pushViewController:providerViewController animated:YES];
    [providerViewController setProvider:provider];
}

#pragma mark - FireUIPagedScrollViewDelegate

// Occurs when the current page is changed or a new page is added. Use this callback to update your visual control(in case you dont want to use pageControl or segmentedControl properties)
-(void)firePagerChanged:(FireUIPagedScrollView*)pager pagesCount:(NSInteger)pagesCount currentPageIndex:(NSInteger)currentPageIndex{
    if (currentPageIndex == 0) {
        [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"toggle_ranking_active.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }else{
        [self.segmentControl setBackgroundImage:[UIImage imageNamed:@"toggle_debate_active.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self.pageDisqusViewController viewWillAppear:YES];
    }
}

@end
