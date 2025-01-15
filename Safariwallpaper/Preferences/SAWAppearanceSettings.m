#import "SAWRootListController.h"

@implementation SAWAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed: 0.93 green: 0.81 blue: 0.65 alpha: 1.00];

}

- (UIColor *)statusBarTintColor {

    return [UIColor whiteColor];

}

- (UIColor *)navigationBarTitleColor {

    return [UIColor whiteColor];

}

- (UIColor *)navigationBarTintColor {

    return [UIColor whiteColor];

}

- (UIColor *)tableViewCellSeparatorColor {

    return [UIColor colorWithWhite:0 alpha:0];

}

- (UIColor *)navigationBarBackgroundColor {

    return [UIColor colorWithRed: 0.93 green: 0.81 blue: 0.65 alpha: 1.00];

}

- (BOOL)translucentNavigationBar {

    return YES;

}

@end