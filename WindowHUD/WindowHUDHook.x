#import "WindowHUD.h"

%hook HookedClass
	static id sharedInstance;

	-(id)initWithDisplayConfiguration:(id)arg1 {
		id original = %orig;
		sharedInstance = original;

		return original;
	}

	%new
	+(id)sharedInstance{
		return sharedInstance;
	}
%end

%ctor {
	Class cls = NSClassFromString(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0") ? @"UIRootSceneWindow" : @"FBRootWindow");
	%init(HookedClass=cls);
}
