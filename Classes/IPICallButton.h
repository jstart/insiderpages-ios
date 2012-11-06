//
//  IPICallButton.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 11/2/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPICallButton : UIButton

@property (nonatomic, strong) UILabel * phoneNumberLabel;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) UIImageView * phoneImageView;

+(IPICallButton*)standardCallButton;

@end
