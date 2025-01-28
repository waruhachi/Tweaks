#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface OhMyFlashPrefs : PSListController
@end

@interface OhMyFlashLogo : PSTableCell {
	UILabel *background;
	UILabel *tweakName;
	UILabel *version;
}
@end
