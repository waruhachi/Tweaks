@import Cephei;
@import CepheiPrefs;

#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>

@interface HLSTextSubPreferencesListController : HBListController <UIFontPickerViewControllerDelegate>
@property(nonatomic, retain)HBAppearanceSettings* appearanceSettings;
@property(nonatomic, retain)HBPreferences* preferences;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@property(nonatomic, retain)UIFontPickerViewController* fontPicker;
- (void)showFontPicker;
@end