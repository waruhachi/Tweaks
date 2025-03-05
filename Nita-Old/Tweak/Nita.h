#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import "libpddokdo/libpddokdo.h"

HBPreferences* preferences = nil;

BOOL enabled = NO;

NSString* condition = nil;
NSString* weatherString = nil;

// position
BOOL replaceTimeSwitch = NO;
BOOL alongsideTimeSwitch = NO;
BOOL replaceCarrierSwitch = YES;

// visibility
BOOL showEmojiSwitch = YES;
BOOL showTemperatureSwitch = NO;

// miscellaneous
BOOL hideBreadcrumbsSwitch = YES;

@interface _UIStatusBarStringView : UIView

- (void)getEmojis;

@end

@interface _UIStatusBarDisplayItem : NSObject

@property (nonatomic, weak, readonly) id item;

@end

@interface SBLockScreenManager : NSObject

+ (id)sharedInstance;
- (BOOL)isLockScreenVisible;

@end