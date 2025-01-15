#import "Letter.h"

%group Letter

%hook UIKeyboard

- (id)initWithFrame:(CGRect)frame {

	id orig = %orig;

	keyboardColor = [libKitten primaryColor:[UIImage _applicationIconImageForBundleIdentifier:[[NSBundle mainBundle] bundleIdentifier] format:1 scale:2]];
	[self setBackgroundColor:keyboardColor];

	return orig;

}

%end

%hook UIKeyboardDockView

- (void)didMoveToWindow {

	%orig;

	[self setBackgroundColor:keyboardColor];

}

%end

%hook TUIPredictionViewCell

- (void)didMoveToWindow {

	%orig;

	[self setBackgroundColor:keyboardColor];

}

%end

%hook TUIEmojiSearchInputView

- (void)didMoveToWindow {

	%orig;

	[self setBackgroundColor:keyboardColor];

}

%end

%hook UIKBRenderConfig

- (void)setLightKeyboard:(BOOL)arg1 {

	%orig(NO);

}

%end

%end

%ctor {

	if (![NSProcessInfo processInfo]) return;
    NSString* processName = [NSProcessInfo processInfo].processName;
    bool isSpringboard = [@"SpringBoard" isEqualToString:processName];

    bool shouldLoad = NO;
    NSArray* args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString* executablePath = args[0];
        if (executablePath) {
            NSString* processName = [executablePath lastPathComponent];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"]
                        || [processName isEqualToString:@"CoreAuthUI"]
                        || [processName isEqualToString:@"InCallService"]
                        || [processName isEqualToString:@"MessagesNotificationViewService"]
                        || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if ((!isFileProvider && isApplication && !skip) || isSpringboard) {
                shouldLoad = YES;
            }
        }
    }

	if (!shouldLoad) return;

	NSBundle* bundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/TextInputUI.framework"];
    if (!bundle.loaded) [bundle load];
	%init(Letter);

}