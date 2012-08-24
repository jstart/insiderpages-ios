//
//  IPBookmarkHeaderViewControllerViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPIBookmarkHeaderViewController : UIViewController
@property (strong, nonatomic) NINetworkImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@end
