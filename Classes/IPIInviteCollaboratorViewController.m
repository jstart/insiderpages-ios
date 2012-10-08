//
//  IPIInviteCollaboratorViewController.m
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 10/8/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//

#import "IPIInviteCollaboratorViewController.h"
#import "IPIUserTableViewCell.h"

@implementation IPIInviteCollaboratorViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Invite";
}

- (void(^)(void))refresh {
    return ^(void){
        if (self.loading || ![IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]]) {
            return;
        }
        
        self.loading = YES;
        NSString * userID = [NSString stringWithFormat:@"%@", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID];
        [[IPKHTTPClient sharedClient] getFollowersForUserWithId:userID success:^(AFJSONRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loading = NO;
                self.fetchedResultsController = nil;
                [self.tableView reloadData];
            });
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSRateLimit resetLimitForName:@"refresh-followers"];
                self.loading = NO;
            });
        }];
    };
}

-(void)close{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - SSManagedViewController

- (Class)entityClass {
	return [IPKUser class];
}

- (NSPredicate *)predicate {
    if (self.customSearchDisplayController.searchBar.text != nil && ![self.customSearchDisplayController.searchBar.text isEqualToString:@""]) {
        return [NSPredicate predicateWithFormat:@"(0 != SUBQUERY(followedUsers, $user, $user.remoteID == %@).@count) AND (name CONTAINS [cd] %@)", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID, self.customSearchDisplayController.searchBar.text];
    }
	return [NSPredicate predicateWithFormat:@"(0 != SUBQUERY(followedUsers, $user, $user.remoteID == %@).@count)", [IPKUser currentUserInContext:[NSManagedObjectContext MR_contextForCurrentThread]].remoteID];
}

-(NSString *)sortDescriptors{
    return @"name";
}

-(BOOL)ascending{
    return NO;
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

#pragma mark - 
#pragma mark UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IPKUser * user = ((IPKUser*)[self objectForViewIndexPath:indexPath]);
    self.loading = YES;
    NSString * userID = [NSString stringWithFormat:@"%@", user.remoteID];
    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Inviting collaborators" loading:YES];
    [hud show];
    [[IPKHTTPClient sharedClient] addCollaboratorsToPageWithId:[self.page.remoteID stringValue] userID:userID success:^(AFJSONRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud completeAndDismissWithTitle:@"Collaborators invited"];
            self.loading = NO;
            [self close];
        });
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud failAndDismissWithTitle:@"Failed to invite."];
            [SSRateLimit resetLimitForName:@"refresh-followers"];
            self.loading = NO;
        });
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const cellIdentifier = @"cellIdentifier";
    
	IPIUserTableViewCell *cell = (IPIUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[IPIUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	cell.user = [self objectForViewIndexPath:indexPath];
	
	return cell;
}

#pragma mark - 
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    [((SSFilterableFetchedResultsController*)self.fetchedResultsController) addFilterPredicate:^BOOL(id obj) {
//        return ([[((IPKUser *)obj) name] rangeOfString:searchText].location != NSNotFound);} forKey:searchText];
//    [((SSFilterableFetchedResultsController*)self.fetchedResultsController) setActiveFilterByKey:searchText];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}


@end
