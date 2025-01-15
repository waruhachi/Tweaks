//
//  PreferenceKeys.h
//  Crystal
//
//  Created by Alexandra Aurora Göttlicher
//

static NSString* const kPreferencesIdentifier = @"codes.aurora.crystal.preferences";

static NSString* const kPreferenceKeyEnabled = @"Enabled";
static NSString* const kPreferenceKeyVolumeThreshold = @"VolumeThreshold";
static NSString* const kPreferenceKeyBelowThresholdMode = @"BelowThresholdMode";
static NSString* const kPreferenceKeyAboveThresholdMode = @"AboveThresholdMode";

NSString* const kListeningModeAudioTransparency = @"AVOutputDeviceBluetoothListeningModeAudioTransparency";
NSString* const kListeningModeNormal = @"AVOutputDeviceBluetoothListeningModeNormal";
NSString* const kListeningModeActiveNoiseCancellation = @"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation";

static BOOL const kPreferenceKeyEnabledDefaultValue = YES;
static CGFloat const kPreferenceKeyVolumeThresholdDefaultValue = 0.4;
static NSString* const kPreferenceKeyBelowThresholdModeDefaultValue = kListeningModeAudioTransparency;
static NSString* const kPreferenceKeyAboveThresholdModeDefaultValue = kListeningModeActiveNoiseCancellation;
