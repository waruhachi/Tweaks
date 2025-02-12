//
//  AppearanceSelectionTableCell.h
//  libappearancecell
//
//  Created by Conor (@conorthedev)
//

#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface UIImage (Private)
+ (UIImage*)kitImageNamed:(NSString*)name;
@end

@interface UIColor (libappearancecell)
+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end

@implementation UIColor (libappearancecell)
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end

@interface AppearanceSelectionTableCell : PSTableCell
@property(nonatomic, retain) UIStackView *containerStackView;
@property(nonatomic, retain) NSArray *options;

- (void)updateForType:(int)type;
@end

@interface AppearanceTypeStackView : UIStackView
@property(nonatomic, retain) AppearanceSelectionTableCell *hostController;

@property(nonatomic, retain) UIImageView *iconView;
@property(nonatomic, retain) UILabel *captionLabel;
@property(nonatomic, retain) UIButton *checkmarkButton;

@property(nonatomic, retain) UIImpactFeedbackGenerator *feedbackGenerator;
@property(nonatomic, retain) UILongPressGestureRecognizer *tapGestureRecognizer;

@property(nonatomic, assign) int type;
@property(nonatomic, retain) NSString *defaultsIdentifier;
@property(nonatomic, retain) NSString *postNotification;
@property(nonatomic, retain) NSString *key;
@property(nonatomic, retain) NSString *tintColor;
@property(nonatomic, retain) NSUserDefaults *defaults;

- (AppearanceTypeStackView *)initWithType:(int)type forController:(AppearanceSelectionTableCell *)controller withImage:(UIImage *)image andText:(NSString *)text andSpecifier:(PSSpecifier *)specifier;
- (void)buttonTapped:(UILongPressGestureRecognizer *)sender;
@end