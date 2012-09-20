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

    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"UserHeaderCell";
            staticContentCell.tableViewCellSubclass = [IPIPullOutUserCell class];
            staticContentCell.cellHeight = [IPIPullOutUserCell cellHeight];
            IPKUser * user = [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            
            [((IPIPullOutUserCell*)cell).profileImageView setPathToNetworkImage:[user imageProfilePathForSize:IPKUserProfileImageSizeMedium ]];
            cell.textLabel.text = user.name;
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, [IPIPullOutUserCell cellHeight]-2, 320, 2)];
            view.image = [UIImage imageNamed:@"keyline"];
            [cell addSubview:view];
        } whenSelected:^(NSIndexPath *indexPath) {
//            [self.navigationController pushViewController:[[WifiViewController alloc] init] animated:YES];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"FeedCell";
            staticContentCell.tableViewCellSubclass = [IPIIconCell class];

            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"Feed";
            cell.imageView.image = [UIImage imageNamed:@"clock_icon.png"];
            
            UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, 320, 2)];
            view.image = [UIImage imageNamed:@"keyline"];
            [cell addSubview:view];
//            cell.detailTextLabel.text = NSLocalizedString(@"T.A.R.D.I.S.", @"T.A.R.D.I.S.");
        } whenSelected:^(NSIndexPath *indexPath) {
            //            [self.navigationController pushViewController:[[WifiViewController alloc] init] animated:YES];
        }];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"To-DoCell";
            staticContentCell.tableViewCellSubclass = [IPIIconCell class];

            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"To-Do";
            cell.imageView.image = [UIImage imageNamed:@"check_icon.png"];
            UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, 320, 2)];
            view.image = [UIImage imageNamed:@"keyline"];
            [cell addSubview:view];
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
            UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, 320, 2)];
            view.image = [UIImage imageNamed:@"keyline"];
            [cell addSubview:view];
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
            UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, 320, 2)];
            view.image = [UIImage imageNamed:@"keyline"];
            [cell addSubview:view];
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
            UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, 320, 2)];
            view.image = [UIImage imageNamed:@"keyline"];
            [cell addSubview:view];
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

//            cell.textLabel.text = @"Logout";
            //            cell.detailTextLabel.text = NSLocalizedString(@"T.A.R.D.I.S.", @"T.A.R.D.I.S.");
        } whenSelected:^(NSIndexPath *indexPath) {
            //            [self.navigationController pushViewController:[[WifiViewController alloc] init] animated:YES];
        }];
    }];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
