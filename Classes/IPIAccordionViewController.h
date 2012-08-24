//
//  IPIAccordionViewController.h
//  InsiderPages for iOS
//
//  Created by Truman, Christopher on 8/14/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "AccordionView.h"
#import "IPIAccordionPagesViewController.h"
#import "IIViewDeckController.h"

@interface IPIAccordionViewController : UIViewController <AccordionViewDelegate, IPIAccordionPagesViewControllerDelegate, IIViewDeckControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) AccordionView * accordionView;
@property (nonatomic, strong) IPIAccordionPagesViewController * page1;
@property (nonatomic, strong) IPIAccordionPagesViewController * page2;
@property (nonatomic, strong) IPIAccordionPagesViewController * page3;

@end
