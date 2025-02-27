#import "DRYBackgroundSubPreferencesListController.h"

@implementation DRYBackgroundSubPreferencesListController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.appearanceSettings = [HBAppearanceSettings new];
    self.hb_appearanceSettings = [self appearanceSettings];

    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[self blur]];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    [[self blurView] setFrame:[[self view] bounds]];
    [[self blurView] setAlpha:1];
    [[self view] addSubview:[self blurView]];

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self blurView] setAlpha:0];
    } completion:nil];

}

- (id)specifiers {

    return _specifiers;

}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {

    NSString* sub = [specifier propertyForKey:@"DRYSub"];
    NSString* title = [specifier name];

    _specifiers = [self loadSpecifiersFromPlistName:sub target:self];

    [self setTitle:title];
    [[self navigationItem] setTitle:title];

    for (PSSpecifier *spec in _specifiers) {
        NSString *footerText = [spec propertyForKey:@"footerText"];
        if ([footerText isEqualToString:@"PLACEHOLDER_WALLPAPER_PATH"]) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL dopamineInstalled = [fileManager fileExistsAtPath:@"/var/jb/.installed_dopamine"];

            NSString *updatedFooterText = [NSString stringWithFormat:@"To use random wallpapers (spotlight), copy your wallpapers into %@", dopamineInstalled ? @"/var/jb/Library/Diary/Wallpapers/" : jbroot(@"/Library/Diary/Wallpapers/")];

            [spec setProperty:updatedFooterText forKey:@"footerText"];
            break;
        }
    }

}

- (void)setSpecifier:(PSSpecifier *)specifier {

    [self loadFromSpecifier:specifier];
    [super setSpecifier:specifier];

}

- (BOOL)shouldReloadSpecifiersOnResume {

    return false;

}

@end
