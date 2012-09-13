//
//  IPICreatePageInitialViewController.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/11/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPICreatePageInitialViewController.h"

@interface IPICreatePageInitialViewController ()

@end

@implementation IPICreatePageInitialViewController
@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize privacyButton;
@synthesize pageOrPollSegmentedControl;
@synthesize thereCanOnlyBeOneImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Create a Page";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        self.privacyTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 300, 44*3) style:UITableViewStylePlain];
        self.privacyTableView.delegate = self;
        self.privacyTableView.dataSource = self;
        self.privacyTableView.layer.cornerRadius = 1;
        self.privacyTableView.layer.borderWidth = 1;
        self.privacyTableView.layer.borderColor = [UIColor grayColor].CGColor;
        [[self view] addSubview:self.privacyTableView];
        
        self.privacyTopMessageArray = [NSArray arrayWithObjects:@"Everyone can view.", @"Everyone can view.", @"Viewers are invited.", nil];
        self.privacyBottomMessageArray = [NSArray arrayWithObjects:@"Everyone can collaborate.", @"Collaborators are invited.", @"Collaborators are invited.", nil];

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

-(void)close{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

-(void)done{
    IPKPage * page = [IPKPage MR_createEntity];
    page.name = self.titleTextField.text;
    page.description_text = self.descriptionTextField.text;
    page.owner = [IPKUser currentUser];
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
    [self setPageOrPollSegmentedControl:nil];
    [self setThereCanOnlyBeOneImage:nil];
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
