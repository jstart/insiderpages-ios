//
//  CDIPageTableViewCell.h
//
//

#import "CDITableViewCell.h"
#import "NINetworkImageView.h"

@interface IPIProviderTableViewCell : CDITableViewCell

@property (nonatomic, strong) IPKProvider *provider;
@property (nonatomic, strong) NINetworkImageView * providerImageView;
@end
