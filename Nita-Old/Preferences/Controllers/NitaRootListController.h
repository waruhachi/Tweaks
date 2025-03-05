@import Cephei;
@import CepheiPrefs;

#import <roothide.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>

@interface NitaRootListController : HBRootListController

@property(nonatomic, retain)UIView* headerView;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIBarButtonItem* item;
@property(nonatomic, retain)UIImageView* iconView;
@property(nonatomic, retain)UISwitch* enableSwitch;
@property(nonatomic, retain)HBPreferences* preferences;
@property(nonatomic, retain)UIImageView* headerImageView;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@property(nonatomic, retain)HBAppearanceSettings* appearanceSettings;

- (void)respring;
- (void)setEnabled;
- (void)resetPrompt;
- (void)setEnabledState;
- (void)resetPreferences;

@end