#import "Lou.h"

AVFlashlight* flashlight = nil;

%group Lou

%hook SBDashBoardBiometricUnlockController

- (void)setAuthenticated:(BOOL)arg1 { // automatically unlock depending on settings

	%orig;

	if (!isLocked) return;

	if (arg1) {
		if (disableForMediaSwitch && ([[%c(SBMediaController) sharedInstance] isPlaying] || [[%c(SBMediaController) sharedInstance] isPaused])) return;
		if (disableForNotificationsSwitch && notificationCount > 0) return;
		if (disableForFlashlightSwitch && [flashlight flashlightLevel] > 0) return;
		if (disableForLowPowerModeSwitch && [[NSProcessInfo processInfo] isLowPowerModeEnabled]) return;
		[[%c(SBLockScreenManager) sharedInstance] unlockUIFromSource:17 withOptions:@{}];
	}

}

%end

%hook CSCoverSheetViewController

- (void)viewWillDisappear:(BOOL)animated {

	%orig;

	isLocked = NO;

}

%end

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 { // note when device was locked

	%orig;

	isLocked = YES;

}

%end

%hook NCNotificationMasterList

- (unsigned long long)notificationCount { // get the notification count

    notificationCount = %orig;

    return notificationCount;

}

%end

%end

%ctor {
	
	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.loupreferences"];
	[preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

	// settings
	[preferences registerBool:&disableForMediaSwitch default:YES forKey:@"disableForMedia"];
	[preferences registerBool:&disableForNotificationsSwitch default:YES forKey:@"disableForNotifications"];
	[preferences registerBool:&disableForFlashlightSwitch default:YES forKey:@"disableForFlashlight"];
	[preferences registerBool:&disableForLowPowerModeSwitch default:NO forKey:@"disableForLowPowerMode"];

	if (disableForFlashlightSwitch) flashlight = [%c(AVFlashlight) new];
	%init(Lou);
	
}