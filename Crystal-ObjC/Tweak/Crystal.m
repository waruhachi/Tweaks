//
//  Crystal.m
//  Crystal
//
//  Created by Alexandra Aurora Göttlicher
//

#import "Crystal.h"
#import <substrate.h>
#import "../Preferences/PreferenceKeys.h"
#import "../Preferences/NotificationKeys.h"

#pragma mark - ExampleClass class hooks

/**
 * Handles what should happen on volume increase.
 */
static void (* orig_SBVolumeControl_increaseVolume)(SBVolumeControl* self, SEL _cmd);
static void override_SBVolumeControl_increaseVolume(SBVolumeControl* self, SEL _cmd) {
    orig_SBVolumeControl_increaseVolume(self, _cmd);

    if ([self _effectiveVolume] > pfVolumeThreshold) {
        setListeningMode(pfAboveThresholdMode);
    }
}

/**
 * Handles what should happen on volume decrease.
 */
static void (* orig_SBVolumeControl_decreaseVolume)(SBVolumeControl* self, SEL _cmd);
static void override_SBVolumeControl_decreaseVolume(SBVolumeControl* self, SEL _cmd) {
    orig_SBVolumeControl_decreaseVolume(self, _cmd);

    if ([self _effectiveVolume] < pfVolumeThreshold) {
        setListeningMode(pfBelowThresholdMode);
    }
}

/**
 * Sets the listening mode.
 *
 * @param mode The listening mode to set.
 */
void setListeningMode(NSString* mode) {
    MPAVRoutingController* routingController = [[objc_getClass("SBMediaController") sharedInstance] valueForKey:@"_routingController"];
    MPAVRoute* pickedRoute = [routingController pickedRoute];
    MRAVConcreteOutputDevice* outputDevice = [pickedRoute logicalLeaderOutputDevice];
    AVOutputDevice* avOutputDevice = [outputDevice valueForKey:@"_avOutputDevice"];
    [avOutputDevice setCurrentBluetoothListeningMode:mode];
}

#pragma mark - Preferences

/**
 * Loads the user's preferences.
 */
static void load_preferences() {
    preferences = [[NSUserDefaults alloc] initWithSuiteName:kPreferencesIdentifier];

    [preferences registerDefaults:@{
        kPreferenceKeyEnabled: @(kPreferenceKeyEnabledDefaultValue),
        kPreferenceKeyVolumeThreshold: @(kPreferenceKeyVolumeThresholdDefaultValue),
        kPreferenceKeyBelowThresholdMode: kPreferenceKeyBelowThresholdModeDefaultValue,
        kPreferenceKeyAboveThresholdMode: kPreferenceKeyAboveThresholdModeDefaultValue
    }];

    pfEnabled = [[preferences objectForKey:kPreferenceKeyEnabled] boolValue];
    pfVolumeThreshold = [[preferences objectForKey:kPreferenceKeyVolumeThreshold] floatValue];
    pfBelowThresholdMode = [preferences objectForKey:kPreferenceKeyBelowThresholdMode];
    pfAboveThresholdMode = [preferences objectForKey:kPreferenceKeyAboveThresholdMode];
}

#pragma mark - Constructor

/**
 * Initializes the Tweak.
 *
 * First it loads the preferences and continues if Crystal is enabled.
 * Secondly it sets up the hooks.
 * Finally it registers the notification callbacks.
 */
__attribute((constructor)) static void initialize() {
	load_preferences();

    if (!pfEnabled) {
        return;
    }

	MSHookMessageEx(objc_getClass("SBVolumeControl"), @selector(increaseVolume), (IMP)&override_SBVolumeControl_increaseVolume, (IMP *)&orig_SBVolumeControl_increaseVolume);
    MSHookMessageEx(objc_getClass("SBVolumeControl"), @selector(decreaseVolume), (IMP)&override_SBVolumeControl_decreaseVolume, (IMP *)&orig_SBVolumeControl_decreaseVolume);

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)load_preferences, (CFStringRef)kNotificationKeyPreferencesReload, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
