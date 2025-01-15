#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

@interface AFOAppearanceSettings : HBAppearanceSettings
@end

@interface AFOContributorsSubPreferencesListController : HBListController
@property(nonatomic, retain)AFOAppearanceSettings* appearanceSettings;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@end