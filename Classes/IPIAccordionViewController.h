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

@interface IPIAccordionViewController : UIViewController <AccordionViewDelegate, UISearchBarDelegate>

@property (nonatomic, retain) AccordionView * accordionView;
@property (nonatomic, retain) IPIAccordionPagesViewController * page1;
@property (nonatomic, retain) IPIAccordionPagesViewController * page2;
@property (nonatomic, retain) IPIAccordionPagesViewController * page3;

@end
