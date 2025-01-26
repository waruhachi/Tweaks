#import <UIKit/UIKit.h>

%hook UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:objc_getClass("IntroViewControllerBase")]) {
        return;
    }

    %orig(viewControllerToPresent, flag, completion);
}

%end
