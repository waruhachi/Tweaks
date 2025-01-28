#import "AlbumManagerCCToggle.h"

@implementation AlbumManagerCCToggle

- (UIImage *)iconGlyph {
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:25 weight:UIImageSymbolWeightMedium scale:UIImageSymbolScaleLarge];
    return [UIImage systemImageNamed:@"lock.slash" withConfiguration:configuration];
}

- (UIImage *)selectedIconGlyph {
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:25 weight:UIImageSymbolWeightMedium scale:UIImageSymbolScaleLarge];
    return [UIImage systemImageNamed:@"lock" withConfiguration:configuration];
}

- (UIColor *)selectedColor {
    return kAlbumManagerColor;
}

- (BOOL)isSelected {
    AlbumManager *manager = [AlbumManager sharedInstance];
    return [[manager objectForKey:@"showLockedAlbums"] boolValue];
}

- (void)setSelected:(BOOL)selected {
    AlbumManager *manager = [AlbumManager sharedInstance];
    [manager setObject:@(selected) forKey:@"showLockedAlbums"];

    pid_t pid;
	int status;
	const char* args[] = {"killall", "-9", "MobileSlideShow", NULL};
	posix_spawn(&pid, ROOT_PATH("/usr/bin/killall"), NULL, NULL, (char* const*)args, NULL);
	waitpid(pid, &status, WEXITED);

    [manager reloadSettings];
    [super refreshState];
}

@end