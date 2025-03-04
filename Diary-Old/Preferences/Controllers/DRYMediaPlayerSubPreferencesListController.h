@import Cephei;
@import CepheiPrefs;

#import <roothide.h>

#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>

@interface DRYMediaPlayerSubPreferencesListController : HBListController
@property(nonatomic, retain)HBAppearanceSettings* appearanceSettings;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UIVisualEffectView* blurView;
- (void)respring;
@end
