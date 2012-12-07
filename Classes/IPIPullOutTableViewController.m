//
//  IPIPullOutTableViewController.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/17/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "IPIPullOutTableViewController.h"
#import "IPIPullOutUserCell.h"
#import "IPIIconCell.h"
#import "IPIPullOutLogoCell.h"
#import "UIColor+InsiderPagesiOSAdditions.h"
#import "UIColor-Expanded.h"
#import "IIViewDeckController.h"

#import "IPIActivityViewController.h"
#import "IPIUserViewController.h"

@interface IPIPullOutTableViewController ()

@end

@implementation IPIPullOutTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIView * backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    backgroundView.backgroundColor = [UIColor pulloutBackgroundColor];
    [backgroundView.layer setOpaque:NO];
    self.tableView.backgroundView = backgroundView;
    [self.tableView.layer setOpaque:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBounces:NO];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithHexString:@"292929"];
    [[UITableViewCell appearanceWhenContainedIn:[self class], nil] setSelectedBackgroundView:v];

    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"UserHeaderCell";
            staticContentCell.tableViewCellSubclass = [IPIPullOutUserCell class];
            staticContentCell.cellHeight = [IPIPullOutUserCell cellHeight];
            IPKUser * user = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            [((IPIPullOutUserCell*)cell).profileImageView setPathToNetworkImage:[user imageProfilePathForSize:IPKUserProfileImageSizeMedium]];
            cell.textLabel.text = user.name;
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            topView.image = [UIImage imageNamed:@"keyline_piece_bottomlight"];
            [cell addSubview:topView];
            
            UIImageView * bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [IPIPullOutUserCell cellHeight]-1, 320, 1)];
            bottomView.image = [UIImage imageNamed:@"keyline_piece_topdark"];
            [cell addSubview:bottomView];
        } whenSelected:^(NSIndexPath *indexPath) {
            [self.parentViewController.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
                IPIUserViewController * userViewController = [[IPIUserViewController alloc] init];
                [userViewController setUser:[IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]];
                [((UINavigationController*)controller.centerController) pushViewController:userViewController animated:NO];
            }];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"FeedCell";
            staticContentCell.tableViewCellSubclass = [IPIIconCell class];

            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"Feed";
            cell.imageView.image = [UIImage imageNamed:@"clock_icon.png"];
            
            UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            topView.image = [UIImage imageNamed:@"keyline_piece_bottomlight"];
            [cell addSubview:topView];
            
            UIImageView * bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [IPIIconCell cellHeight]-1, 320, 1)];
            bottomView.image = [UIImage imageNamed:@"keyline_piece_topdark"];
            [cell addSubview:bottomView];
//            cell.detailTextLabel.text = NSLocalizedString(@"T.A.R.D.I.S.", @"T.A.R.D.I.S.");
        } whenSelected:^(NSIndexPath *indexPath) {
            [self.parentViewController.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
                IPIActivityViewController * activityViewController = [[IPIActivityViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [((UINavigationController*)controller.centerController) pushViewController:activityViewController animated:NO];
            }];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"To-DoCell";
            staticContentCell.tableViewCellSubclass = [IPIIconCell class];

            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"To-Do";
            cell.imageView.image = [UIImage imageNamed:@"check_icon.png"];
            UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            topView.image = [UIImage imageNamed:@"keyline_piece_bottomlight"];
            [cell addSubview:topView];
            
            UIImageView * bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [IPIIconCell cellHeight]-1, 320, 1)];
            bottomView.image = [UIImage imageNamed:@"keyline_piece_topdark"];
            [cell addSubview:bottomView];
            //            cell.detailTextLabel.text = NSLocalizedString(@"T.A.R.D.I.S.", @"T.A.R.D.I.S.");
        } whenSelected:^(NSIndexPath *indexPath) {
            //            [self.navigationController pushViewController:[[WifiViewController alloc] init] animated:YES];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"Add-FriendsCell";
            staticContentCell.tableViewCellSubclass = [IPIIconCell class];

            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"Add Friends";
            cell.imageView.image = [UIImage imageNamed:@"friends_icon.png"];
            UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            topView.image = [UIImage imageNamed:@"keyline_piece_bottomlight"];
            [cell addSubview:topView];
            
            UIImageView * bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [IPIIconCell cellHeight]-1, 320, 1)];
            bottomView.image = [UIImage imageNamed:@"keyline_piece_topdark"];
            [cell addSubview:bottomView];
            //            cell.detailTextLabel.text = NSLocalizedString(@"T.A.R.D.I.S.", @"T.A.R.D.I.S.");
        } whenSelected:^(NSIndexPath *indexPath) {
            //            [self.navigationController pushViewController:[[WifiViewController alloc] init] animated:YES];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"SettingsCell";
            staticContentCell.tableViewCellSubclass = [IPIIconCell class];

            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"Settings";
            cell.imageView.image = [UIImage imageNamed:@"settings_icon.png"];
            UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            topView.image = [UIImage imageNamed:@"keyline_piece_bottomlight"];
            [cell addSubview:topView];
            
            UIImageView * bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [IPIIconCell cellHeight]-1, 320, 1)];
            bottomView.image = [UIImage imageNamed:@"keyline_piece_topdark"];
            [cell addSubview:bottomView];
            //            cell.detailTextLabel.text = NSLocalizedString(@"T.A.R.D.I.S.", @"T.A.R.D.I.S.");
        } whenSelected:^(NSIndexPath *indexPath) {
            //            [self.navigationController pushViewController:[[WifiViewController alloc] init] animated:YES];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"LogoutCell";
            staticContentCell.tableViewCellSubclass = [IPIIconCell class];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"Logout";
            
            cell.imageView.image = [UIImage imageNamed:@"logout_icon.png"];
            UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            topView.image = [UIImage imageNamed:@"keyline_piece_bottomlight"];
            [cell addSubview:topView];
            
            UIImageView * bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [IPIIconCell cellHeight]-1, 320, 1)];
            bottomView.image = [UIImage imageNamed:@"keyline_piece_topdark"];
            [cell addSubview:bottomView];
            //            cell.detailTextLabel.text = NSLocalizedString(@"T.A.R.D.I.S.", @"T.A.R.D.I.S.");
        } whenSelected:^(NSIndexPath *indexPath) {
            //            [self.navigationController pushViewController:[[WifiViewController alloc] init] animated:YES];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"LogoCell";
            staticContentCell.cellHeight = [IPIPullOutLogoCell cellHeight];
            staticContentCell.tableViewCellSubclass = [IPIPullOutLogoCell class];
            
            cell.accessoryType = UITableViewCellAccessoryNone;

            UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            topView.image = [UIImage imageNamed:@"keyline_piece_bottomlight"];
            [cell addSubview:topView];
            
            UIImageView * bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [IPIPullOutLogoCell cellHeight]-1, 320, 1)];
            bottomView.image = [UIImage imageNamed:@"keyline_piece_topdark"];
            [cell addSubview:bottomView];
//            cell.textLabel.text = @"Logout";
            //            cell.detailTextLabel.text = NSLocalizedString(@"T.A.R.D.I.S.", @"T.A.R.D.I.S.");
        } whenSelected:^(NSIndexPath *indexPath) {

        }];
    }];
    [[self tableView] reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
