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

BOOL enableTwitterSection;

BOOL TWTtabBarSwitch;
BOOL TWTtweetViewSwitch;
BOOL TWTdirectMessagesTapSwitch;
BOOL TWTactivityTapSwitch;
BOOL TWTtweetButtonSwitch;
NSString* customStrengthTWTtabBarControl;
NSString* customStrengthTWTtweetViewControl;
NSString* customStrengthTWTdirectMessagesTapControl;
NSString* customStrengthTWTactivityTapControl;
NSString* customStrengthTWTtweetButtonControl;

BOOL delaySwitch;
NSString* delayLevel;

BOOL LowPowerMode;
BOOL LowPowerModeSwitch;
BOOL isDNDActive;
BOOL isDNDActiveSwitch;
BOOL isRingerSilent;
BOOL isRingerSilentSwitch;

%group Twitter

%hook TFNCustomTabBar

- (void)tap:(id)arg1 {

	%orig;

	if (!TWTtabBarSwitch) return;
	int customStrength = [customStrengthTWTtabBarControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook T1StandardStatusView

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!TWTtweetViewSwitch) return;
	int customStrength = [customStrengthTWTtweetViewControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook T1DirectMessageInboxSummaryView

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!TWTdirectMessagesTapSwitch) return;
	int customStrength = [customStrengthTWTdirectMessagesTapControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook T1ActivityCell

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!TWTactivityTapSwitch) return;
	int customStrength = [customStrengthTWTactivityTapControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook TFNFloatingActionButton

- (void)_tfn_expandingButtonAction:(id)arg1 {

	%orig;

	if (!TWTtweetButtonSwitch) return;
	int customStrength = [customStrengthTWTtweetButtonControl intValue];

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
	[preferences registerBool:&enableTwitterSection default:nil forKey:@"EnableTwitterSection"];
	
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

	if (enableTwitterSection) {
		[preferences registerBool:&TWTtabBarSwitch default:NO forKey:@"TWTtabBar"];
		[preferences registerBool:&TWTtweetViewSwitch default:NO forKey:@"TWTweetTap"];
		[preferences registerBool:&TWTdirectMessagesTapSwitch default:NO forKey:@"TWTdirectMessagesTap"];
		[preferences registerBool:&TWTactivityTapSwitch default:NO forKey:@"TWTactivityTap"];
		[preferences registerBool:&TWTtweetButtonSwitch default:NO forKey:@"TWTtweetButton"];
		[preferences registerObject:&customStrengthTWTtabBarControl default:@"0" forKey:@"customStrengthTWTtabBar"];
		[preferences registerObject:&customStrengthTWTtweetViewControl default:@"0" forKey:@"customStrengthTWTtweetView"];
		[preferences registerObject:&customStrengthTWTdirectMessagesTapControl default:@"0" forKey:@"customStrengthTWTdirectMessagesTap"];
		[preferences registerObject:&customStrengthTWTactivityTapControl default:@"0" forKey:@"customStrengthTWTactivityTap"];
		[preferences registerObject:&customStrengthTWTtweetButtonControl default:@"0" forKey:@"customStrengthTWTtweetButton"];
	}

    if (enabled && enableTwitterSection) {
		tapticLVL = [tapticLevel intValue];
		hapticLVL = [hapticLevel intValue];
		delayLVL = [delayLevel doubleValue];
		selectedLegacyMode = [legacyLevel intValue];
		customLegacyDuration = [customlegacyDurationLevel doubleValue];
		customLegacyStrength = [customlegacyStrengthLevel doubleValue];
		%init(Twitter);
		return;
    }

}