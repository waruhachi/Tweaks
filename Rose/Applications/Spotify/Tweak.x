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

BOOL enableSpotifySection;

BOOL SPTplayButtonSwitch;
BOOL SPTplayBarButtonSwitch;
BOOL SPTpreviousTrackButtonSwitch;
BOOL SPTnextTrackButtonSwitch;
BOOL SPTrepeatButtonSwitch;
BOOL SPTshuffleButtonSwitch;
BOOL SPTqueueButtonSwitch;
BOOL SPTsliderSwitch;
BOOL SPTfreeTierButtonSwitch;
BOOL SPTavailableDevicesButtonSwitch;
BOOL SPTnowPlayingLabelSwitch;
BOOL SPTplaylistButtonsSwitch;
NSString* customStrengthSPTplayButtonControl;
NSString* customStrengthSPTplayBarButtonControl;
NSString* customStrengthSPTpreviousTrackButtonControl;
NSString* customStrengthSPTnextTrackButtonControl;
NSString* customStrengthSPTrepeatButtonControl;
NSString* customStrengthSPTshuffleButtonControl;
NSString* customStrengthSPTqueueButtonControl;
NSString* customStrengthSPTsliderControl;
NSString* customStrengthSPTfreeTierButtonControl;
NSString* customStrengthSPTavailableDevicesButtonControl;
NSString* customStrengthSPTnowPlayingLabelControl;
NSString* customStrengthSPTplaylistButtonsControl;

BOOL delaySwitch;
NSString* delayLevel;

BOOL LowPowerMode;
BOOL LowPowerModeSwitch;
BOOL isDNDActive;
BOOL isDNDActiveSwitch;
BOOL isRingerSilent;
BOOL isRingerSilentSwitch;

@interface UIButton (Spotify)
- (id)_viewControllerForAncestor;
@end

%group Spotify

%hook SPTNowPlayingPlayButtonV2

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTplayButtonSwitch) return;
	int customStrength = [customStrengthSPTplayButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTNowPlayingPreviousTrackButton

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTpreviousTrackButtonSwitch) return;
	int customStrength = [customStrengthSPTpreviousTrackButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTNowPlayingNextTrackButton

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTnextTrackButtonSwitch) return;
	int customStrength = [customStrengthSPTnextTrackButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTNowPlayingRepeatButton

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTrepeatButtonSwitch) return;
	int customStrength = [customStrengthSPTrepeatButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTNowPlayingShuffleButton

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTshuffleButtonSwitch) return;
	int customStrength = [customStrengthSPTshuffleButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTNowPlayingQueueButton

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTqueueButtonSwitch) return;
	int customStrength = [customStrengthSPTqueueButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTNowPlayingSliderV2

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTsliderSwitch) return;
	int customStrength = [customStrengthSPTsliderControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTNowPlayingFreeTierFeedbackButton

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTfreeTierButtonSwitch) return;
	int customStrength = [customStrengthSPTfreeTierButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTGaiaDevicesAvailableViewImplementation

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTavailableDevicesButtonSwitch) return;
	int customStrength = [customStrengthSPTavailableDevicesButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTNowPlayingMarqueeLabel

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTnowPlayingLabelSwitch) return;
	int customStrength = [customStrengthSPTnowPlayingLabelControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook SPTNowPlayingBarPlayButton

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTplayBarButtonSwitch) return;
	int customStrength = [customStrengthSPTplayBarButtonControl intValue];

	if (customStrength == 0 && !enableLegacyEngineSwitch)
		[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
	else if (customStrength != 0 && !enableLegacyEngineSwitch)
		[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
	else if (customStrength == 0 && enableLegacyEngineSwitch)
		[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

}

%end

%hook UIButton

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {

	%orig;

	if (!SPTplaylistButtonsSwitch) return;
	UIViewController* ancestor = [self _viewControllerForAncestor];

	if ([ancestor isKindOfClass: %c(SPTFreeTierPlaylistVISREFHeaderViewController)]) {
		int customStrength = [customStrengthSPTplaylistButtonsControl intValue];

		if (customStrength == 0 && !enableLegacyEngineSwitch)
			[libRose triggerFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :tapticLVL :hapticLVL];
		else if (customStrength != 0 && !enableLegacyEngineSwitch)
			[libRose triggerCustomFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customStrength];
		else if (customStrength == 0 && enableLegacyEngineSwitch)
			[libRose triggerLegacyFeedback:LowPowerModeSwitch :LowPowerMode :isDNDActiveSwitch :isDNDActive :isRingerSilentSwitch :isRingerSilent :delaySwitch :delayLVL :enabled :enableTapticEngineSwitch :enableHapticEngineSwitch :enableLegacyEngineSwitch :customLegacyDuration :customLegacyStrength :selectedLegacyMode];

	}

}

%end

%end

%ctor {

    preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.rosepreferences"];

	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableExceptionsSection default:nil forKey:@"EnableExceptionsSection"];
	[preferences registerBool:&enableSpotifySection default:nil forKey:@"EnableSpotifySection"];
	
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

	if (enableSpotifySection) {
		[preferences registerBool:&SPTplayButtonSwitch default:NO forKey:@"SPTplayButton"];
		[preferences registerBool:&SPTplayBarButtonSwitch default:NO forKey:@"SPTplayBarButton"];
		[preferences registerBool:&SPTpreviousTrackButtonSwitch default:NO forKey:@"SPTpreviousTrackButton"];
		[preferences registerBool:&SPTnextTrackButtonSwitch default:NO forKey:@"SPTnextTrackButton"];
		[preferences registerBool:&SPTrepeatButtonSwitch default:NO forKey:@"SPTrepeatButton"];
		[preferences registerBool:&SPTshuffleButtonSwitch default:NO forKey:@"SPTshuffleButton"];
		[preferences registerBool:&SPTqueueButtonSwitch default:NO forKey:@"SPTqueueButton"];
		[preferences registerBool:&SPTsliderSwitch default:NO forKey:@"SPTslider"];
		[preferences registerBool:&SPTfreeTierButtonSwitch default:NO forKey:@"SPTfreeTierButton"];
		[preferences registerBool:&SPTavailableDevicesButtonSwitch default:NO forKey:@"SPTavailableDevicesButton"];
		[preferences registerBool:&SPTnowPlayingLabelSwitch default:NO forKey:@"SPTnowPlayingLabel"];
		[preferences registerBool:&SPTplaylistButtonsSwitch default:NO forKey:@"SPTplaylistButtons"];
		[preferences registerObject:&customStrengthSPTplayButtonControl default:@"0" forKey:@"customStrengthSPTplayButton"];
		[preferences registerObject:&customStrengthSPTplayBarButtonControl default:@"0" forKey:@"customStrengthSPTplayBarButton"];
		[preferences registerObject:&customStrengthSPTpreviousTrackButtonControl default:@"0" forKey:@"customStrengthSPTpreviousTrackButton"];
		[preferences registerObject:&customStrengthSPTnextTrackButtonControl default:@"0" forKey:@"customStrengthSPTnextTrackButton"];
		[preferences registerObject:&customStrengthSPTrepeatButtonControl default:@"0" forKey:@"customStrengthSPTrepeatButton"];
		[preferences registerObject:&customStrengthSPTshuffleButtonControl default:@"0" forKey:@"customStrengthSPTshuffleButton"];
		[preferences registerObject:&customStrengthSPTqueueButtonControl default:@"0" forKey:@"customStrengthSPTqueueButton"];
		[preferences registerObject:&customStrengthSPTsliderControl default:@"0" forKey:@"customStrengthSPTslider"];
		[preferences registerObject:&customStrengthSPTfreeTierButtonControl default:@"0" forKey:@"customStrengthSPTfreeTierButton"];
		[preferences registerObject:&customStrengthSPTavailableDevicesButtonControl default:@"0" forKey:@"customStrengthSPTavailableDevicesButton"];
		[preferences registerObject:&customStrengthSPTnowPlayingLabelControl default:@"0" forKey:@"customStrengthSPTnowPlayingLabel"];
		[preferences registerObject:&customStrengthSPTplaylistButtonsControl default:@"0" forKey:@"customStrengthSPTplaylistButtons"];
	}

    if (enabled && enableSpotifySection) {
		hapticLVL = [hapticLevel intValue];
		delayLVL = [delayLevel doubleValue];
		selectedLegacyMode = [legacyLevel intValue];
		customLegacyDuration = [customlegacyDurationLevel doubleValue];
		customLegacyStrength = [customlegacyStrengthLevel doubleValue];
		%init(Spotify);
		return;
    }

}