//
//  IPIBaseManagedPageSegmentViewController.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/10/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import "CDIManagedTableViewController.h"
#import "IPIBasePageSegmentViewController.h"

@interface IPIBaseManagedPageSegmentViewController : CDIManagedTableViewController

@property (nonatomic, strong) id <IPIBasePageSegmentDelegate> delegate;

@end
