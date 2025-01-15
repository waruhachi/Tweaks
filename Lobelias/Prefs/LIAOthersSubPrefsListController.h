#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>

@interface LIAAppearanceSettings : HBAppearanceSettings
@end

@interface LIAOthersSubPrefsListController : HBListController
@property(nonatomic, retain)UILabel* titleLabel;
@end