//
//  IPBookmarkViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IPIBookmarkBaseManagedModalViewController.h"
#import "IPIBookmarkHeaderViewController.h"

@interface IPIBookmarkViewController : IPIBookmarkBaseManagedModalViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) IPIBookmarkHeaderViewController * headerViewController;

@end

