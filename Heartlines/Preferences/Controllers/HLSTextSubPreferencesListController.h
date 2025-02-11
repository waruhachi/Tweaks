#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>

#import <Cephei/HBPreferences.h>

#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

@interface HLSAppearanceSettings : HBAppearanceSettings
@end

@interface HLSTextSubPreferencesListController : HBListController <UIFontPickerViewControllerDelegate>
@property(nonatomic, retain)HLSAppearanceSettings* appearanceSettings;
@property(nonatomic, retain)HBPreferences* preferences;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@property(nonatomic, retain)UIFontPickerViewController* fontPicker;
- (void)showFontPicker;
@end