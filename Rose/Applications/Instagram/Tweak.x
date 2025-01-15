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

BOOL enableInstagramSection;

BOOL ITGlikeButtonSwitch;
BOOL ITGdoubleTapToLikeSwitch;
BOOL ITGcommentButtonSwitch;
BOOL ITGsaveButtonSwitch;
BOOL ITGsendButtonSwitch;
NSString* customStrengthITGlikeButtonControl;
NSString* customStrengthITGdoubleTapToLikeControl;
NSString* customStrengthITGcommentButtonControl;
NSString* customStrengthITGsaveButtonControl;
NSString* customStrengthITGsendButtonControl;

BOOL delaySwitch;
NSString* delayLevel;

BOOL LowPowerMode;
BOOL LowPowerModeSwitch;
BOOL isDNDActive;
BOOL isDNDActiveSwitch;
BOOL isRingerSilent;
BOOL isRingerSilentSwitch;

%group Instagram

%hook IGFeedPhotoView

- (void)_onDoubleTap:(id)arg1 {

	%orig;

	if (!ITGdoubleTapToLikeSwitch) return;
	int customStrength = [customStrengthITGdoubleTapToLikeControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook IGFeedItemVideoView

- (void)overlayViewDidDoubleTap:(id)arg1 {

	%orig;

	if (!ITGdoubleTapToLikeSwitch) return;
	int customStrength = [customStrengthITGdoubleTapToLikeControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook IGUFIButtonBarView

- (void)_onLikeButtonPressed:(id)arg1 {

	%orig;

	if (!ITGlikeButtonSwitch) return;
	int customStrength = [customStrengthITGlikeButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

- (void)_onCommentButtonPressed:(id)arg1 {

	%orig;

	if (!ITGcommentButtonSwitch) return;
	int customStrength = [customStrengthITGcommentButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

- (void)_onSaveButtonLongPressed:(id)arg1 {

	%orig;

	if (!ITGsaveButtonSwitch) return;
	int customStrength = [customStrengthITGsaveButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

- (void)_onSaveButtonPressed:(id)arg1 {

	%orig;

	if (!ITGsaveButtonSwitch) return;
	int customStrength = [customStrengthITGsaveButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

- (void)_onSendButtonPressed:(id)arg1 {

	%orig;

	if (!ITGsendButtonSwitch) return;
	int customStrength = [customStrengthITGsendButtonControl intValue];

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
	[preferences registerBool:&enableInstagramSection default:nil forKey:@"EnableInstagramSection"];
	
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

	if (enableInstagramSection) {
		[preferences registerBool:&ITGlikeButtonSwitch default:NO forKey:@"ITGlikeButton"];
		[preferences registerBool:&ITGdoubleTapToLikeSwitch default:NO forKey:@"ITGdoubleTapToLike"];
		[preferences registerBool:&ITGcommentButtonSwitch default:NO forKey:@"ITGcommentButton"];
		[preferences registerBool:&ITGsaveButtonSwitch default:NO forKey:@"ITGsaveButton"];
		[preferences registerBool:&ITGsendButtonSwitch default:NO forKey:@"ITGsendButton"];
		[preferences registerObject:&customStrengthITGlikeButtonControl default:@"0" forKey:@"customStrengthITGlikeButton"];
		[preferences registerObject:&customStrengthITGdoubleTapToLikeControl default:@"0" forKey:@"customStrengthITGdoubleTapToLike"];
		[preferences registerObject:&customStrengthITGcommentButtonControl default:@"0" forKey:@"customStrengthITGcommentButton"];
		[preferences registerObject:&customStrengthITGsaveButtonControl default:@"0" forKey:@"customStrengthITGsaveButton"];
		[preferences registerObject:&customStrengthITGsendButtonControl default:@"0" forKey:@"customStrengthITGsendButton"];
	}

    if (enabled && enableInstagramSection) {
		tapticLVL = [tapticLevel intValue];
		hapticLVL = [hapticLevel intValue];
		delayLVL = [delayLevel doubleValue];
		selectedLegacyMode = [legacyLevel intValue];
		customLegacyDuration = [customlegacyDurationLevel doubleValue];
		customLegacyStrength = [customlegacyStrengthLevel doubleValue];
		%init(Instagram);
		return;
    }

}