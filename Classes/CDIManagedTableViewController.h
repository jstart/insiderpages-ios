//
//  CDIManagedTableViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/10/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIPullToRefreshView.h"

@interface CDIManagedTableViewController : SSManagedTableViewController <SSPullToRefreshViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong, readonly) CDIPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong, readonly) NSIndexPath *editingIndexPath;
@property (nonatomic, assign, readonly) CGRect keyboardRect;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) NSNumber *perPage;
@property (nonatomic, strong) NSNumber *currentPage;

- (void (^)(void))refresh;
- (void (^)(void))nextPage;

- (void)toggleEditMode:(id)sender;
- (void)endCellTextEditing;
- (void)editRow:(UITapGestureRecognizer *)editingTapGestureRecognizer;

- (void)updateTableViewOffsets;
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;
- (void)reachabilityChanged:(NSNotification *)notification;

- (void)showCoverView;
- (BOOL)showingCoverView;
- (void)hideCoverView;
- (void)coverViewTapped:(id)sender;

@end
