//
//  CDISignUpViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/23/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISignUpViewController.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIFont+InsiderPagesiOSAdditions.h"
#import "CDISignInViewController.h"

@interface CDISignUpViewController ()
@property (nonatomic, strong, readonly) UIButton *facebookButton;
@end

@implementation CDISignUpViewController

@synthesize facebookButton = _facebookButton;

- (UIButton *)facebookButton {
	if (!_facebookButton) {
        _facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_facebookButton addTarget:self
                        action:@selector(login)
              forControlEvents:UIControlEventTouchUpInside];
        [_facebookButton setImage:
         [UIImage imageNamed:@"LoginWithFacebookNormal.png"]
                     forState:UIControlStateNormal];
        [_facebookButton setImage:
         [UIImage imageNamed:@"LoginWithFacebookPressed.png"] forState:UIControlStateHighlighted];
        [_facebookButton sizeToFit];
    }
	return _facebookButton;
}

- (UILabel *)registerLabel {
    UILabel * registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    registerLabel.backgroundColor = [UIColor clearColor];
    registerLabel.textAlignment = UITextAlignmentCenter;
    registerLabel.textColor = [UIColor whiteColor];
    [registerLabel setText:@"Connect with Facebook"];
    return registerLabel;
}



#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.title = @"InsiderPages";
//    UIButton *footer = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 34.0f)];
//    [footer setTitle:@"Already have an account? Sign In →" forState:UIControlStateNormal];
//    [footer setTitleColor:[UIColor cheddarBlueColor] forState:UIControlStateNormal];
//    [footer setTitleColor:[UIColor cheddarTextColor] forState:UIControlStateHighlighted];
//    [footer addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
//    footer.titleLabel.font = [UIFont cheddarFontOfSize:16.0f];
//    self.tableView.tableFooterView = footer;
    self.view.backgroundColor = [UIColor grayColor];
    UIButton * faceboookButton = [self facebookButton];
    CGPoint buttonCenter = self.view.center;
    buttonCenter.y = buttonCenter.y - 40;
    faceboookButton.center = buttonCenter;
    [[self view] addSubview:faceboookButton];
    
    UILabel * registerLabel = [self registerLabel];
    CGPoint labelCenter = faceboookButton.center;
    labelCenter.y = labelCenter.y - 35;
    registerLabel.center = labelCenter;
    [[self view] addSubview:registerLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedIn) name:@"Logged In" object:nil];
}


#pragma mark - Actions

-(void)login{
    [[IPIAppDelegate sharedAppDelegate] openSessionCheckCache:NO];
}

-(void)loggedIn{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

// These are not used but migth be useful when we do email login
- (void)signIn:(id)sender {
	[self.navigationController pushViewController:[[CDISignInViewController alloc] init] animated:YES];
}


- (void)signUp:(id)sender {
//	SSHUDView *hud = [[SSHUDView alloc] initWithTitle:@"Signing up..." loading:YES];
//	[hud show];
	
//	[[CDKHTTPClient sharedClient] signUpWithUsername:self.usernameTextField.text email:self.emailTextField.text password:self.passwordTextField.text success:^(AFJSONRequestOperation *operation, id responseObject) {
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[hud completeAndDismissWithTitle:@"Signed Up!"];
//			[self.navigationController dismissModalViewControllerAnimated:YES];
//		});
//	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[hud failAndDismissWithTitle:@"Failed"];
//		});
//	}];
}

//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	static NSString *const cellIdentifier = @"cellIdentifier";
//	
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//	if (!cell) {
//		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//	}
//	
//	if (indexPath.row == 0) {
//        UIButton * facebookButton = [self facebookButton];
//        facebookButton.center = cell.center;
//		[cell addSubview:facebookButton];
//	}
//	
//	return cell;
//}

@end
