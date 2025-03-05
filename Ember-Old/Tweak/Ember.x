#import "Ember.h"

%group Ember

%hook SBRingerControl

- (void)setRingerMuted:(BOOL)arg1 {

	%orig;

	DNDModeAssertionService* assertionService = (DNDModeAssertionService *)[objc_getClass("DNDModeAssertionService") serviceForClientIdentifier:@"com.apple.donotdisturb.control-center.module"];

	if (arg1) {
		DNDModeAssertionDetails* newAssertion = [objc_getClass("DNDModeAssertionDetails") userRequestedAssertionDetailsWithIdentifier:@"com.apple.control-center.manual-toggle" modeIdentifier:@"com.apple.donotdisturb.mode.default" lifetime:nil];
		[assertionService takeModeAssertionWithDetails:newAssertion error:NULL];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SBQuietModeStatusChangedNotification" object:nil];
	} else {
		[assertionService invalidateAllActiveModeAssertionsWithError:NULL];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SBQuietModeStatusChangedNotification" object:nil];
	}

}

%end

%end

%ctor {

	%init(Ember);

}