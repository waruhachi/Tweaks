#include <UIKit/UIKit.h>

%hook UITabBarController

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    NSMutableArray *filteredViewControllers = [viewControllers mutableCopy];

    if (filteredViewControllers.count > 1) {
        [filteredViewControllers removeObjectAtIndex:1];
    }

    %orig(filteredViewControllers, animated);
}

%end
