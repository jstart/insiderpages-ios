//
//  IPIProviderMapsCarouselViewController.h
//  InsiderPages for iOS
//
//  Created by Christopher Truman.
//
#import "IPIAbstractCarouselViewController.h"

@class IPKPage;

@protocol IPIProviderMapsCarouselDelegate <NSObject>

-(void)pageChanged;

@end

@interface IPIProviderMapsCarouselViewController : IPIAbstractCarouselViewController

@property (nonatomic, strong) IPKPage *page;
@property (nonatomic, strong) IPKUser *sortUser;
@property (nonatomic, assign) id <IPIProviderMapsCarouselDelegate> delegate;

@end
