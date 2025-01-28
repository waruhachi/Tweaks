#import <Tweak.h>

BOOL isDragging = NO;
BOOL hasFullyLoaded = NO;
BOOL isUsingGoodges = NO;

BOOL enabled;
double delay;

%hook SBFolderView
-(void)pageControl:(id)arg1 didRecieveTouchInDirection:(int)arg2 {
	%orig;
	[self _prepareHideLabels];
}

-(void)scrollViewDidEndDragging:(id)arg1 willDecelerate:(_Bool)arg2 {
	%orig;
	[self _prepareHideLabels];
}

-(void)scrollViewWillBeginDragging:(id)arg1 {
	%orig;
	isDragging = YES;
	[self _showLabels];
}

-(void)layoutSubviews {
	%orig;
	// Nasty workaround because this method gets called several times in a row
	// and we are unable to know which one is the one we actually need (homescreen became visible)
	if (delay >= 2.0) {
		[self _prepareHideLabels];
	} else {
		[self _hideLabels];
	}

}

%new
-(void)_prepareHideLabels {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_hideLabels) object:nil];
	[self performSelector:@selector(_hideLabels) withObject:nil afterDelay:delay];
}

%new
-(void)_hideLabels {
	animateIconLabelAlpha(0);
	isDragging = NO;
}

%new
-(void)_showLabels {
	animateIconLabelAlpha(1);
}
%end

%hook SBIconView
-(void)layoutSubviews {
	%orig;

	// If we are using Goodges, we have to update the visibility whenever the badgeValue changes
	if (hasFullyLoaded && isUsingGoodges && !isDragging) {
		SBIconController *controller = [%c(SBIconController) sharedInstance];
		SBRootIconListView *rootView = [controller currentRootIconList];

		NSArray *icons = [rootView icons];
		SBIcon *icon = [self icon];

		// Update only the icon page thats currently visible
		if (![icons containsObject:icon]) return;

		int badgeValue = (int)[icon badgeValue];

		if (badgeValue < 1) {
			[self setIconLabelAlpha: 0];
		} else {
			[self setIconLabelAlpha: 1];
		}
	}
}
%end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        hasFullyLoaded = YES;
    });
}
%end

static void animateIconLabelAlpha(double alpha) {
	SBIconController *controller = [%c(SBIconController) sharedInstance];
	SBRootIconListView *rootView = [controller currentRootIconList];

	NSArray *icons = [rootView icons];
	SBIconViewMap* map = [rootView viewMap];

	[UIView animateWithDuration:0.5 animations:^{
		for(SBIcon *icon in icons) {
			SBIconView *iconView = [map mappedIconViewForIcon:icon];

			int badgeValue = (int)[icon badgeValue];
			if (!isUsingGoodges || badgeValue < 1) {
				[iconView setIconLabelAlpha: alpha];
			} else {
				[iconView setIconLabelAlpha: 1];
			}
		}
	}];
}

// ===== PREFERENCE HANDLING ===== //

static void loadPrefs() {
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.noisyflake.shylabels.plist"];

  if (prefs) {
    enabled = ( [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES );
    delay = ( [prefs objectForKey:@"delay"] ? [[prefs objectForKey:@"delay"] doubleValue] : 1.0 );
  }

}

static void initPrefs() {
  // Copy the default preferences file when the actual preference file doesn't exist
  NSString *path = @"/User/Library/Preferences/com.noisyflake.shylabels.plist";
  NSString *pathDefault = @"/Library/PreferenceBundles/ShyLabels.bundle/defaults.plist";
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:path]) {
    [fileManager copyItemAtPath:pathDefault toPath:path error:nil];
  }
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.noisyflake.shylabels/prefsupdated"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	initPrefs();
	loadPrefs();

	NSFileManager *fileManager = [NSFileManager defaultManager];
	isUsingGoodges = [fileManager fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Goodges.dylib"];

	if(enabled) {
		%init(_ungrouped);
	}
}
