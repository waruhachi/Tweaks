#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>

HBPreferences* preferences = nil;
BOOL enabled = NO;

BOOL isLocked = YES;
int notificationCount = 0;

// settings
BOOL disableForMediaSwitch = YES;
BOOL disableForNotificationsSwitch = YES;
BOOL disableForFlashlightSwitch = YES;
BOOL disableForLowPowerModeSwitch = NO;

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (BOOL)unlockUIFromSource:(int)arg1 withOptions:(id)arg2;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
- (BOOL)isPaused;
@end

@interface AVFlashlight : NSObject
- (float)flashlightLevel;
@end