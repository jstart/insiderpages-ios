//
//  KNSemiModalViewController.h
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#define kSemiModalAnimationDuration   0.3

@interface UIViewController (KNSemiModal)

-(void)presentSemiViewController:(UIViewController*)vc;
-(void)presentSemiHiddenViewController:(UIViewController*)vc;
-(void)presentSemiView:(UIView*)vc;
-(void)presentSemiHiddenView:(UIView*)vc;
-(void)dismissSemiModalView;
-(void)dismissSemiModalViewHidden;

@end

// Convenient category method to find actual ViewController that contains a view

@interface UIView (FindUIViewController)
- (UIViewController *) containingViewController;
- (id) traverseResponderChainForUIViewController;
@end