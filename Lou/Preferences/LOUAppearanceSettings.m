#import "LOURootListController.h"

@implementation LOUAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed:0.54 green:0.81 blue:0.72 alpha:1];

}

- (UIStatusBarStyle)statusBarStyle {

    return UIStatusBarStyleDarkContent;

}

- (UIColor *)navigationBarTitleColor {

    return [UIColor whiteColor];

}

- (UIColor *)navigationBarTintColor {

    return [UIColor whiteColor];

}

- (UIColor *)tableViewCellSeparatorColor {

    return [[UIColor whiteColor] colorWithAlphaComponent:0];

}

- (UIColor *)navigationBarBackgroundColor {

    return [UIColor colorWithRed:0.54 green:0.81 blue:0.72 alpha:1];

}

- (BOOL)translucentNavigationBar {

    return YES;

}

@end