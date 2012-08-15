//
//  CDITableViewCell.h
//

@interface CDITableViewCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)setAppearanceBackgroundImage:(UIImage *)image UI_APPEARANCE_SELECTOR;
- (void)setAppearanceBackgroundColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setTextLabelColor:(UIColor *)textLabelColor UI_APPEARANCE_SELECTOR;
- (void)setTextLabelFont:(UIFont *)textLabelFont UI_APPEARANCE_SELECTOR;
- (void)setDetailTextLabelColor:(UIColor *)detailTextLabelColor UI_APPEARANCE_SELECTOR;
- (void)setDetailTextLabelFont:(UIFont *)detailTextLabelFont UI_APPEARANCE_SELECTOR;

@end
