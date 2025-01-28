#import <FocusDND.h>

%hook CCUIModuleSettingsManager

- (id)moduleSettingsForModuleIdentifier:(NSString *)identifier prototypeSize:(CCUILayoutSize)protoSize {
	if (![identifier isEqualToString:focusModuleIdentifier]) return %orig;

	return [[%c(CCUIModuleSettings) alloc] initWithPortraitLayoutSize:defaultLayoutSize landscapeLayoutSize:defaultLayoutSize];
}

%end

%hook FCCCModuleViewController

- (void)_updateTitle:(id)title on:(BOOL)isActive buttonSize:(CGSize)buttonSize {
	%orig(@"", NO, buttonSize);
}

%end

%ctor {
	[[NSNotificationCenter defaultCenter] addObserverForName:NSBundleDidLoadNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
		NSString *bundlePath = ((NSBundle *)notification.object).bundlePath;

		if ([bundlePath isEqualToString:focusModuleBundlePath]) %init;
	}];
}