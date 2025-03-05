@import CepheiPrefs;

#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>

@interface NitaCreditsSubPreferencesListController : HBListController

@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@property(nonatomic, retain)HBAppearanceSettings* appearanceSettings;

@end