#import "CPARootListController.h"

@implementation CPAAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed: 0.59 green: 0.16 blue: 0.58 alpha: 1.00];

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

    return [UIColor colorWithRed: 0.21 green: 0.02 blue: 0.21 alpha: 1.00];

}

- (BOOL)translucentNavigationBar {

    return YES;

}

@end