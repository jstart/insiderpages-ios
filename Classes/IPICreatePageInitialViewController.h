//
//  IPICreatePageInitialViewController.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/11/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPICreatePageInitialViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet SSTextField *titleTextField;
@property (strong, nonatomic) IBOutlet SSTextField *descriptionTextField;

@property (strong, nonatomic) IBOutlet UIButton *privacyButton;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *pageOrPollSegmentedControl;

//@property (strong, nonatomic) IBOutlet UIImageView *thereCanOnlyBeOneImage;

@property (strong, nonatomic) NSNumber * privacyNumber;

@property (strong, nonatomic) UITableView *privacyTableView;

@property (strong, nonatomic) NSArray * privacyTopMessageArray;

@property (strong, nonatomic) NSArray * privacyBottomMessageArray;

- (IBAction)privacyButton:(id)sender;

@end
