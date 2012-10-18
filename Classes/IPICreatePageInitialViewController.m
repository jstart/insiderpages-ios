//
//  IPICreatePageInitialViewController.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/11/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPICreatePageInitialViewController.h"
#import "UIColor-Expanded.h"

@interface IPICreatePageInitialViewController ()

@end

@implementation IPICreatePageInitialViewController
@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize privacyButton;
//@synthesize pageOrPollSegmentedControl;
//@synthesize thereCanOnlyBeOneImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Create a Page";
        self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        
        UIView * cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cancelButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [cancelView addSubview:cancelButton];
        UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelView];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
        
        UIView * checkmarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIButton * checkmarkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [checkmarkButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [checkmarkButton setImage:[UIImage imageNamed:@"checkmark_inactive"] forState:UIControlStateNormal];
        [checkmarkButton setImage:[UIImage imageNamed:@"checkmark_active"] forState:UIControlStateSelected];
        [checkmarkButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [checkmarkButton setEnabled:NO];
        [checkmarkView addSubview:checkmarkButton];
        UIBarButtonItem * checkmarkButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkmarkView];
        self.navigationItem.rightBarButtonItem = checkmarkButtonItem;
        
        self.privacyTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 300, 44*3) style:UITableViewStylePlain];
        self.privacyTableView.delegate = self;
        self.privacyTableView.dataSource = self;
        self.privacyTableView.layer.cornerRadius = 1;
        self.privacyTableView.layer.borderWidth = 1;
        self.privacyTableView.layer.borderColor = [UIColor grayColor].CGColor;
        [[self view] addSubview:self.privacyTableView];
        
        self.privacyTopMessageArray = [NSArray arrayWithObjects:@"Everyone can view.", @"Everyone can view.", @"Viewers are invited.", nil];
        self.privacyBottomMessageArray = [NSArray arrayWithObjects:@"Everyone can collaborate.", @"Collaborators are invited.", @"Collaborators are invited.", nil];
        [self.titleTextField setFont:[UIFont fontWithName:@"Myriad Web Pro" size:17]];
        [self.titleTextField addTarget:self action:@selector(titleTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
        [self.titleTextField setTextEdgeInsets:UIEdgeInsetsMake(15, 15, 0, 52)];
        [self.titleTextField setClearButtonEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -52)];
        self.titleTextField.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.titleTextField.layer.borderWidth = 1;
        [self.descriptionTextField setFont:[UIFont fontWithName:@"Myriad Web Pro" size:14]];
        [self.descriptionTextField setTextEdgeInsets:UIEdgeInsetsMake(15, 15, 0, 0)];
        self.descriptionTextField.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.descriptionTextField.layer.borderWidth = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)titleTextFieldChanged{
    if (!((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]).isSelected && self.titleTextField.text.length > 0) {
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setEnabled:YES];
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setSelected:YES];
    } else if(((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]).isSelected && self.titleTextField.text.length < 1){
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setEnabled:NO];
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setSelected:NO];
    }
}

-(void)close{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

-(void)done{
    IPKPage * page = [IPKPage MR_createEntity];
    page.name = self.titleTextField.text;
    page.description_text = self.descriptionTextField.text;
    page.owner = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    page.privacy_setting = self.privacyNumber;
    SSHUDView *hud = [[SSHUDView alloc] initWithTitle:@"Creating Page..." loading:YES];
	[hud show];
    [[IPKHTTPClient sharedClient] createPage:page success:^(AFJSONRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud completeAndDismissWithTitle:@"Page Created!"];
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SSRateLimit resetLimitForName:@"refresh-mine-pages"];
            [hud failAndDismissWithTitle:@"Page not successfully created."];
        });
    }];

    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTitleTextField:nil];
    [self setDescriptionTextField:nil];
    [self setPrivacyButton:nil];
//    [self setPageOrPollSegmentedControl:nil];
//    [self setThereCanOnlyBeOneImage:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [self.privacyTopMessageArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.privacyBottomMessageArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.privacyNumber = [NSNumber numberWithInt:indexPath.row];
    [self privacyButton:nil];
}

- (IBAction)privacyButton:(id)sender {
    if (self.privacyTableView.frame.origin.x == 320) {
        CGRect initialFrame = self.privacyTableView.frame;
        initialFrame.origin.y = self.privacyButton.frame.size.height;
        [self.privacyTableView setFrame:initialFrame];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        CGRect frame = self.privacyTableView.frame;
        frame.origin.x = 20;
        [self.privacyTableView setFrame:frame];
        [UIView commitAnimations];
    }
    else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        CGRect frame = self.privacyTableView.frame;
        frame.origin.x = 320;
        [self.privacyTableView setFrame:frame];
        [UIView commitAnimations];
    }
}

@end
