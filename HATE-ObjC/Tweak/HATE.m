//
//  HATE.m
//  HATE
//
//  Created by Alexandra Aurora Göttlicher
//

#import "HATE.h"
#import <substrate.h>
#import "../Preferences/PreferenceKeys.h"
#import "../Preferences/NotificationKeys.h"

#pragma mark - UIKeyboard class hooks

/**
 * Sets the background color of the keyboard to black.
 *
 * @param frame
 */
static UIKeyboard* (* orig_UIKeyboard_initWithFrame)(UIKeyboard* self, SEL _cmd, CGRect frame);
static UIKeyboard* override_UIKeyboard_initWithFrame(UIKeyboard* self, SEL _cmd, CGRect frame) {
	UIKeyboard* orig = orig_UIKeyboard_initWithFrame(self, _cmd, frame);
    [self setBackgroundColor:[UIColor blackColor]];
    return orig;
}

#pragma mark - UIKeyboardDockView class hooks

/**
 * Sets the background color of the keyboard dock to black.
 *
 * @param frame
 */
static UIKeyboardDockView* (* orig_UIKeyboardDockView_initWithFrame)(UIKeyboardDockView* self, SEL _cmd, CGRect frame);
static UIKeyboardDockView* override_UIKeyboardDockView_initWithFrame(UIKeyboardDockView* self, SEL _cmd, CGRect frame) {
	UIKeyboardDockView* orig = orig_UIKeyboardDockView_initWithFrame(self, _cmd, frame);
    [self setBackgroundColor:[UIColor blackColor]];
    return orig;
}

#pragma mark - TUIPredictionViewStackView class hooks

/**
 * Sets the background color of the prediction view to black.
 *
 * @param frame
 */
static TUIPredictionViewStackView* (* orig_TUIPredictionViewStackView_initWithFrame)(TUIPredictionViewStackView* self, SEL _cmd, CGRect frame);
static TUIPredictionViewStackView* override_TUIPredictionViewStackView_initWithFrame(TUIPredictionViewStackView* self, SEL _cmd, CGRect frame) {
	TUIPredictionViewStackView* orig = orig_TUIPredictionViewStackView_initWithFrame(self, _cmd, frame);
    [self setBackgroundColor:[UIColor blackColor]];
    return orig;
}

#pragma mark - TUIEmojiSearchInputView class hooks

/**
 * Sets the background color of the emoji search input view to black.
 */
static void (* orig_TUIEmojiSearchInputView_didMoveToWindow)(TUIEmojiSearchInputView* self, SEL _cmd);
static void override_TUIEmojiSearchInputView_didMoveToWindow(TUIEmojiSearchInputView* self, SEL _cmd) {
	orig_TUIEmojiSearchInputView_didMoveToWindow(self, _cmd);
    [self setBackgroundColor:[UIColor blackColor]];
}

/**
 * Tells iOS to always use the stock dark keyboard.
 *
 * This is done to prevent the keyboard keys from being white.
 *
 * @param lightKeyboard Whether the keyboard should be light or not.
 */
static void (* orig_UIKBRenderConfig_setLightKeyboard)(UIKBRenderConfig* self, SEL _cmd, BOOL lightKeyboard);
static void override_UIKBRenderConfig_setLightKeyboard(UIKBRenderConfig* self, SEL _cmd, BOOL lightKeyboard) {
	orig_UIKBRenderConfig_setLightKeyboard(self, _cmd, NO);
}

#pragma mark - Preferences

/**
 * Loads the user's preferences.
 */
static void load_preferences() {
    preferences = [[NSUserDefaults alloc] initWithSuiteName:kPreferencesIdentifier];

    [preferences registerDefaults:@{
        kPreferenceKeyEnabled: @(kPreferenceKeyEnabledDefaultValue)
    }];

    pfEnabled = [[preferences objectForKey:kPreferenceKeyEnabled] boolValue];
}

#pragma mark - Constructor

/**
 * Initializes the Tweak.
 */
__attribute((constructor)) static void initialize() {
	load_preferences();

    if (!pfEnabled) {
        return;
    }

    // Some processes should not be hooked into.
    if (![NSProcessInfo processInfo]) {
        return;
    }

    NSString* processName = [[NSProcessInfo processInfo] processName];
    BOOL isSpringboard = [@"SpringBoard" isEqualToString:processName];

    BOOL shouldLoad = NO;
    NSArray* args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = [args count];
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

	if (!shouldLoad) {
        return;
    }

    // The TextInputUI framework needs to be loaded before we can hook into it.
	NSBundle* bundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/TextInputUI.framework"];
    if (![bundle isLoaded]) {
        [bundle load];
    }

	MSHookMessageEx(NSClassFromString(@"UIKeyboard"), @selector(initWithFrame:), (IMP)&override_UIKeyboard_initWithFrame, (IMP *)&orig_UIKeyboard_initWithFrame);
    MSHookMessageEx(NSClassFromString(@"UIKeyboardDockView"), @selector(initWithFrame:), (IMP)&override_UIKeyboardDockView_initWithFrame, (IMP *)&orig_UIKeyboardDockView_initWithFrame);
    MSHookMessageEx(NSClassFromString(@"TUIPredictionViewStackView"), @selector(initWithFrame:), (IMP)&override_TUIPredictionViewStackView_initWithFrame, (IMP *)&orig_TUIPredictionViewStackView_initWithFrame);
    MSHookMessageEx(NSClassFromString(@"TUIEmojiSearchInputView"), @selector(didMoveToWindow), (IMP)&override_TUIEmojiSearchInputView_didMoveToWindow, (IMP *)&orig_TUIEmojiSearchInputView_didMoveToWindow);
    MSHookMessageEx(NSClassFromString(@"UIKBRenderConfig"), @selector(setLightKeyboard:), (IMP)&override_UIKBRenderConfig_setLightKeyboard, (IMP *)&orig_UIKBRenderConfig_setLightKeyboard);

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)load_preferences, (CFStringRef)kNotificationKeyPreferencesReload, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
