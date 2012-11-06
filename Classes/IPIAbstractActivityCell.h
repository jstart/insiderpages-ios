//
//  IPIAbstractActivityCell.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/20/12.
//  Copyright (c) 2012 InsiderPages. All rights reserved.
//


@protocol IPIAbstractActivityCellDelegate <NSObject>

-(void)didSelectUser:(IPKUser*)user;

@end

@interface IPIAbstractActivityCell : UITableViewCell

@property (nonatomic, strong) IPKActivity * activity;
@property (nonatomic, strong) id <IPIAbstractActivityCellDelegate> delegate;

+(CGFloat)cellHeight;

@end
