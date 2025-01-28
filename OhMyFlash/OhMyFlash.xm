#import "OhMyFlash.h"

NSMutableDictionary *prefs, *defaultPrefs;
NSTimer *timer = nil;

%hook AVFlashlight
-(BOOL)setFlashlightLevel:(float)level withError:(id*)arg2 {
	if (!getBool(@"enabled")) return %orig;

	if (timer != nil) [timer invalidate];

	if (level > 0) {
		// Create the timer on the main thread
		dispatch_async(dispatch_get_main_queue(), ^{
			double timeout = [([prefs objectForKey:@"timeout"] ?: [defaultPrefs objectForKey:@"timeout"]) doubleValue] * 60;
			timer = [NSTimer scheduledTimerWithTimeInterval:timeout
					    target:self
					    selector:@selector(turnFlashlightOff)
					    userInfo:nil
					    repeats:NO];
		});
	}
	return %orig;
}

%new
-(void)turnFlashlightOff {
	[self setFlashlightLevel:0 withError:nil];
}
%end

// ----- PREFERENCE HANDLING ----- //

static BOOL getBool(NSString *key) {
	id ret = [prefs objectForKey:key];

	if(ret == nil) {
		ret = [defaultPrefs objectForKey:key];
	}

	return [ret boolValue];
}

static void loadPrefs() {
	prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.noisyflake.ohmyflash.plist"];
}

static void initPrefs() {
	// Copy the default preferences file when the actual preference file doesn't exist
	NSString *path = @"/User/Library/Preferences/com.noisyflake.ohmyflash.plist";
	NSString *pathDefault = @"/Library/PreferenceBundles/OhMyFlashPrefs.bundle/defaults.plist";
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:path]) {
		[fileManager copyItemAtPath:pathDefault toPath:path error:nil];
	}

	defaultPrefs = [[NSMutableDictionary alloc] initWithContentsOfFile:pathDefault];
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.noisyflake.ohmyflash/prefsupdated"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	initPrefs();
	loadPrefs();
}


