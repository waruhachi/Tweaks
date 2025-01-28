#include <UIKit/UIKit.h>

typedef struct CCUILayoutSize {
	NSUInteger width;
	NSUInteger height;
} CCUILayoutSize;

static CCUILayoutSize const defaultLayoutSize = {1, 1};

static NSString *const focusModuleIdentifier = @"com.apple.FocusUIModule";
static NSString *const focusModuleBundlePath = @"/System/Library/ControlCenter/Bundles/FocusUIModule.bundle";

@interface CCUIModuleSettings : NSObject
	- (id)initWithPortraitLayoutSize:(CCUILayoutSize)portraitSize landscapeLayoutSize:(CCUILayoutSize)landscapeSize;
@end