#import "../../Tweak/Rose.h"
#import <Rose/libRose.h>

BOOL enabled;
BOOL enableTapticEngineSwitch;
BOOL enableHapticEngineSwitch;
BOOL enableLegacyEngineSwitch;

NSString* tapticLevel;
NSString* hapticLevel;
NSString* legacyLevel;
NSString* customlegacyDurationLevel;
NSString* customlegacyStrengthLevel;

int tapticLVL;
int hapticLVL;
double delayLVL;
int selectedLegacyMode;
double customLegacyDuration;
double customLegacyStrength;

BOOL enableExceptionsSection;

BOOL enableSafariSection;

BOOL SFUrlSwitch;
NSString* customStrengthSFUrlControl;

BOOL delaySwitch;
NSString* delayLevel;

BOOL LowPowerMode;
BOOL LowPowerModeSwitch;
BOOL isDNDActive;
BOOL isDNDActiveSwitch;
BOOL isRingerSilent;
BOOL isRingerSilentSwitch;

%group Safari

%hook _SFNavigationBarURLButton

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SFUrlSwitch) return;
	int customStrength = [customStrengthSFUrlControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%end

%ctor {

    preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.rosepreferences"];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableExceptionsSection default:nil forKey:@"EnableExceptionsSection"];
	[preferences registerBool:&enableSafariSection default:nil forKey:@"EnableSafariSection"];
	
	[preferences registerBool:&enableTapticEngineSwitch default:NO forKey:@"enableTapticEngine"];
	[preferences registerBool:&enableHapticEngineSwitch default:NO forKey:@"enableHapticEngine"];
	[preferences registerBool:&enableLegacyEngineSwitch default:NO forKey:@"enableLegacyEngine"];

	[preferences registerObject:&tapticLevel default:@"0" forKey:@"TapticStrength"];
    [preferences registerObject:&hapticLevel default:@"0" forKey:@"HapticStrength"];
	[preferences registerObject:&legacyLevel default:@"0" forKey:@"LegacyStrength"];

	[preferences registerObject:&customlegacyDurationLevel default:@"0" forKey:@"customLegacyDuration"];
	[preferences registerObject:&customlegacyStrengthLevel default:@"0" forKey:@"customLegacyStrength"];

	if (enableExceptionsSection) {
		[preferences registerBool:&LowPowerModeSwitch default:NO forKey:@"lowPowerMode"];
		[preferences registerBool:&isDNDActiveSwitch default:NO forKey:@"isDNDActive"];
		[preferences registerBool:&isRingerSilentSwitch default:NO forKey:@"isRingerSilent"];
	}

	if (enableSafariSection) {
		[preferences registerBool:&SFUrlSwitch default:NO forKey:@"SFUrl"];
		[preferences registerObject:&customStrengthSFUrlControl default:@"0" forKey:@"customStrengthSFUrl"];
	}

    if (enabled && enableSafariSection) {
		tapticLVL = [tapticLevel intValue];
		hapticLVL = [hapticLevel intValue];
		delayLVL = [delayLevel doubleValue];
		selectedLegacyMode = [legacyLevel intValue];
		customLegacyDuration = [customlegacyDurationLevel doubleValue];
		customLegacyStrength = [customlegacyStrengthLevel doubleValue];
		%init(Safari);
		return;
    }

}