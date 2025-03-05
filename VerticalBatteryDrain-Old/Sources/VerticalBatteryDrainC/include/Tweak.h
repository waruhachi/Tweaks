#import <UIKit/UIKit.h>

@interface _UIBatteryView : UIView
@property (nonatomic, strong, readwrite) CALayer *fillLayer;
@end
@interface CALayer ()
- (void)setFrame:(CGRect)frame;
@end