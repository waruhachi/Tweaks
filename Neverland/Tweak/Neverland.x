#import "Neverland.h"

%group Neverland

%hook SBFluidSwitcherItemContainer

- (void)layoutSubviews {

	%orig;

	appLayout = [self valueForKey:@"_appLayout"];
	[appLayout getAppId];
	if (swipeAppId == [[[%c(SBMediaController) sharedInstance] nowPlayingApplication] bundleIdentifier] && [[%c(SBMediaController) sharedInstance] isPlaying]) {
		SBFluidSwitcherTouchPassThroughScrollView* scrollView = [self valueForKey:@"_killScrollView"];
		[scrollView setScrollEnabled:NO];
	}

}

%end

%hook SBAppLayout

%new
- (void)getAppId {

	NSDictionary* roles =  [self valueForKey:@"rolesToLayoutItemsMap"];
	NSArray* jsonArray = [roles allValues];
	NSDictionary* firstObjectDict = [jsonArray objectAtIndex:0];
	swipeAppId = [firstObjectDict valueForKey:@"bundleIdentifier"];

}

%end

%end

%ctor {

	%init(Neverland);

}