#import "Copypasta.h"

UIKeyboardInputMode* inputMode = nil;

void showCopypastaWithNotification();

%group Copypasta

%hook UIInputWindowController

- (void)viewDidLoad { // add copypasta

    %orig;

    if (!cpaView) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        cpaView = [[CPAView alloc] initWithFrame:CGRectMake(0, bounds.size.height, bounds.size.width, 0)];
        
        if (styleValue == 0) cpaView.darkMode = NO;
        else if (styleValue == 1) cpaView.darkMode = YES;
        cpaView.showIcons = showIconsSwitch;
        cpaView.showNames = showNamesSwitch;
        cpaView.dismissAfterPaste = dismissAfterPasteSwitch;
        cpaView.playsHapticFeedback = hapticFeedbackSwitch;
        cpaView.tableHeight = heightValue;
        cpaView.dismissesFully = !alwaysShowChevronSwitch;
        
        [cpaView recreateBlur];
        [cpaView refresh];
    }

    [cpaView hide:!alwaysShowChevronSwitch animated:NO];
    
    if (![cpaView isDescendantOfView:[self view]]) [[self view] addSubview:cpaView];

}

%end

%hook UIKeyboardLayoutStar

- (id)initWithFrame:(CGRect)arg1 { // add swipe up gesture

    if (!useSwipeUpSwitch || alwaysShowChevronSwitch) return %orig;
    upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [upSwipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:upSwipe];

    return %orig;

}

- (void)didMoveToWindow { // show or hide copypasta when keyboard appeared or disappeared

    %orig;

    if (alwaysShowChevronSwitch) [cpaView show:NO animated:YES];
    if (cpaView.isOpenFully) [cpaView hide:!alwaysShowChevronSwitch animated:YES];

}

- (UIKBTree *)keyHitTest:(CGPoint)arg1 {  // show copypasta when pressing dictation key (old keyboard)

    if (!useDictationKeySwitch || alwaysShowChevronSwitch) return %orig;
    UIKBTree* orig = %orig;
    if (orig && [orig.name isEqualToString:@"Dictation-Key"]) {
        orig.properties[@"KBinteractionType"] = @(0);
        
        if (hapticFeedbackSwitch && !cpaView.isOpenFully) AudioServicesPlaySystemSound(1519);
        [cpaView show:YES animated:YES];

        return orig;
    }

    return orig;

}

%new
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender { // show copypasta when swiped up

	if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        if (hapticFeedbackSwitch && !cpaView.isOpenFully) AudioServicesPlaySystemSound(1519);
        [cpaView show:YES animated:YES];
    }

}

%end

%hook UISystemKeyboardDockController

- (void)dictationItemButtonWasPressed:(id)arg1 withEvent:(id)arg2 { // show copypasta when pressing dictation key (new keyboard)

    if (!useDictationKeySwitch || alwaysShowChevronSwitch) {
        %orig;
        return;
    }

    if (hapticFeedbackSwitch && !cpaView.isOpenFully) AudioServicesPlaySystemSound(1519);
    [cpaView show:YES animated:YES];

}

%end

%hook UIKeyboardImpl

- (BOOL)shouldShowDictationKey { // always show dictation key

    if (useDictationKeySwitch && !alwaysShowChevronSwitch) return YES;
    return %orig;

}

+ (Class)layoutClassForInputMode:(id)arg1 keyboardType:(long long)arg2 screenTraits:(id)arg3 { // show copypasta when selecting keyboard mode

    if (!useKeyboardInputModeSwitch || alwaysShowChevronSwitch) return %orig;
    if ([arg1 isEqualToString:@"Copypasta"]) {
        if (hapticFeedbackSwitch && !cpaView.isOpenFully) AudioServicesPlaySystemSound(1519);
        [cpaView show:YES animated:YES];
        return nil;
    }

    return %orig;

}

%end

%hook UIKeyboardInputMode

+ (id)keyboardInputModeWithIdentifier:(id)arg1 { // add keyboard input mode

    if (!useKeyboardInputModeSwitch || alwaysShowChevronSwitch) return %orig;
    if ([arg1 isEqualToString:@"Copypasta"]){
        if (!inputMode) {
            id orig = %orig(@"en_US");
            [orig setIdentifier:@"Copypasta"];
            inputMode = orig;
        }
        
        return inputMode;
    }

    return %orig;

}

- (NSString *)displayName { // add keyboard input mode

    if (!useKeyboardInputModeSwitch || alwaysShowChevronSwitch) return %orig;
    if ([[self identifier] isEqualToString:@"Copypasta"])
        return @"Copypasta";

    return %orig;
}

- (id)primaryLanguage { // add keyboard input mode
    
    if (!useKeyboardInputModeSwitch || alwaysShowChevronSwitch) return %orig;
    if ([[self identifier] isEqualToString:@"Copypasta"])
        return @"Copypasta";

    return %orig;

}

%end

%hook UIKeyboardInputModeController

- (NSArray *)keyboardInputModes { // add keyboard input mode

    if (!useKeyboardInputModeSwitch || alwaysShowChevronSwitch) return %orig;
    return [%orig arrayByAddingObjectsFromArray:@[[%c(UIKeyboardInputMode) keyboardInputModeWithIdentifier:@"Copypasta"]]];

}

%end

%end

void reloadItems() { // reload saved items

    [[CPAManager sharedInstance] reload];
    if (cpaView) {
        [cpaView refresh];
        [cpaView.tableView setContentOffset:CGPointZero animated:YES];
    }

}

void showCopypastaWithNotification() {

    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) [cpaView show:YES animated:YES];

}

%ctor {

    if ([SparkAppList doesIdentifier:@"love.litten.copypasta.blacklistpreferences" andKey:@"blacklistedApps" containBundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]]) return;
    if (![NSProcessInfo processInfo]) return;
    NSString* processName = [NSProcessInfo processInfo].processName;
    BOOL isSpringboard = [@"SpringBoard" isEqualToString:processName];

    BOOL shouldLoad = NO;
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

    preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.copypastapreferences"];
    cpaObserver = [CPAObserver new];

    [preferences registerBool:&enabled default:NO forKey:@"Enabled"];
    if (!enabled) return;

    // activation
    [preferences registerBool:&useSwipeUpSwitch default:YES forKey:@"useSwipeUp"];
    [preferences registerBool:&useDictationKeySwitch default:NO forKey:@"useDictationKey"];
    [preferences registerBool:&useKeyboardInputModeSwitch default:NO forKey:@"useKeyboardInputMode"];

    // style
    [preferences registerInteger:&styleValue default:0 forKey:@"style"];
    [preferences registerBool:&blurryBackgroundSwitch default:NO forKey:@"blurryBackground"];
    [preferences registerBool:&showNamesSwitch default:YES forKey:@"showNames"];
    [preferences registerBool:&showIconsSwitch default:YES forKey:@"showIcons"];
    [preferences registerBool:&alwaysShowChevronSwitch default:NO forKey:@"alwaysShowChevron"];
    [preferences registerBool:&hideChevronSwitch default:NO forKey:@"hideChevron"];
    [preferences registerBool:&useBackgroundImageSwitch default:NO forKey:@"useBackgroundImage"];
    [preferences registerDouble:&backgroundAlphaValue default:0.5 forKey:@"backgroundAlpha"];

    // behavior
    [preferences registerBool:&dismissAfterPasteSwitch default:YES forKey:@"dismissAfterPaste"];
    [preferences registerBool:&hapticFeedbackSwitch default:YES forKey:@"hapticFeedback"];
    [preferences registerFloat:&heightValue default:350.0 forKey:@"height"];
    [preferences registerInteger:&numberOfItemsValue default:10 forKey:@"numberOfItems"];

    [preferences registerPreferenceChangeBlock:^() {
        [[CPAManager sharedInstance] setNumberOfItems:numberOfItemsValue];

        if (!cpaView) return;

        if (styleValue == 0) cpaView.darkMode = NO;
        else if (styleValue == 1) cpaView.darkMode = YES;
        cpaView.showIcons = showIconsSwitch;
        cpaView.showNames = showNamesSwitch;
        cpaView.dismissAfterPaste = dismissAfterPasteSwitch;
        cpaView.playsHapticFeedback = hapticFeedbackSwitch;
        cpaView.tableHeight = heightValue;
        cpaView.dismissesFully = !alwaysShowChevronSwitch;
        
        [cpaView recreateBlur];
        [cpaView refresh];
    }];

    %init(Copypasta);
    if (!isSpringboard && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Shortmoji.dylib"]) CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)showCopypastaWithNotification, (CFStringRef)@"love.litten.copypasta/showWithNotification", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadItems, (CFStringRef)@"love.litten.copypasta/ReloadItems", NULL, (CFNotificationSuspensionBehavior)kNilOptions);

}
