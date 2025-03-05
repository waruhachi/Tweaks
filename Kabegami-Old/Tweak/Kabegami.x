#import <Kabegami.h>

void SaveWallpaper(NSInteger type) {
	if (!lockscreenWallpaperImage || !homescreenWallpaperImage) {
		dispatch_async(dispatch_get_main_queue(), ^{
			CustomToast *toast = [[CustomToast alloc] initWithTitle:@"Unable to Save Wallpaper" subtitle:@"Kabegami" icon:[UIImage systemImageNamed:@"exclamationmark.triangle"] iconColor:[UIColor redColor] autoHide:3.0];
			[toast presentToast];
		});
		return;
	}

	AudioServicesPlaySystemSound(hapticSoundID);
	if (type == 0) {
		UIImageWriteToSavedPhotosAlbum(lockscreenWallpaperImage, nil, nil, nil);
	} else if (type == 1) {
		UIImageWriteToSavedPhotosAlbum(homescreenWallpaperImage, nil, nil, nil);
	}

	dispatch_async(dispatch_get_main_queue(), ^{
		CustomToast *toast = [[CustomToast alloc] initWithTitle:@"Wallpaper Saved" subtitle:@"Kabegami" icon:[UIImage systemImageNamed:@"checkmark.circle"] iconColor:[UIColor greenColor] autoHide:3.0];
		[toast presentToast];
	});
}

void SaveWallpaper16() {
	SBWallpaperController *wallpaperController = [%c(SBWallpaperController) sharedInstance];
	UIView *wallpaperView = [wallpaperController safeValueForKey:@"_wallpaperWindow"];

	if (!wallpaperView) {
		dispatch_async(dispatch_get_main_queue(), ^{
			CustomToast *toast = [[CustomToast alloc] initWithTitle:@"Unable to Save Wallpaper" subtitle:@"Kabegami" icon:[UIImage systemImageNamed:@"exclamationmark.triangle"] iconColor:[UIColor redColor] autoHide:3.0];
			[toast presentToast];
		});
		return;
	}

	UIGraphicsBeginImageContextWithOptions(wallpaperView.frame.size, NO, [UIScreen mainScreen].scale);
	[wallpaperView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *wallpaperImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	if (!wallpaperImage) {
		dispatch_async(dispatch_get_main_queue(), ^{
			CustomToast *toast = [[CustomToast alloc] initWithTitle:@"Unable to Save Wallpaper" subtitle:@"Kabegami" icon:[UIImage systemImageNamed:@"exclamationmark.triangle"] iconColor:[UIColor redColor] autoHide:3.0];
			[toast presentToast];
		});
		return;
	}

	AudioServicesPlaySystemSound(hapticSoundID);
	UIImageWriteToSavedPhotosAlbum(wallpaperImage, nil, nil, nil);

	dispatch_async(dispatch_get_main_queue(), ^{
		CustomToast *toast = [[CustomToast alloc] initWithTitle:@"Wallpaper Saved" subtitle:@"Kabegami" icon:[UIImage systemImageNamed:@"checkmark.circle"] iconColor:[UIColor greenColor] autoHide:3.0];
		[toast presentToast];
	});
}

%hook CSCoverSheetViewController

- (void)viewDidLoad {
	%orig;

	if (self.view) {
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		tapGestureRecognizer.numberOfTapsRequired = numberOfTapsRequired;
		[self.view addGestureRecognizer:tapGestureRecognizer];
	}
}

%new
- (void)handleTap:(UITapGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateRecognized) {
		if (osVersion.majorVersion >= 16) {
			SaveWallpaper16();
		} else {
			SaveWallpaper(0);
		}
	}
}

%end

%hook SBHomeScreenViewController

- (void)viewDidLoad {
	%orig;

	if (self.view) {
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		tapGestureRecognizer.numberOfTapsRequired = numberOfTapsRequired;
		[self.view addGestureRecognizer:tapGestureRecognizer];
	}
}

%new
- (void)handleTap:(UITapGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateRecognized) {
		if (osVersion.majorVersion >= 16) {
			SaveWallpaper16();
		} else {
			SaveWallpaper(1);
		}
	}
}

%end

%hook SBFWallpaperView

- (id)initWithFrame:(struct CGRect )arg0 configuration:(id)arg1 variant:(NSInteger)arg2 cacheGroup:(id)arg3 delegate:(id)arg4 options:(NSUInteger)arg5 {
	self = %orig;

	SBFWallpaperConfiguration *configuration = arg1;
	NSURL *wallpaperFileURL = configuration.wallpaperImage.wallpaperFileURL;

	if (wallpaperFileURL && [[wallpaperFileURL absoluteString] rangeOfString:@"LockBackground"].location != NSNotFound) {
		lockscreenWallpaperImage = configuration.wallpaperImage;
	} else if (wallpaperFileURL && [[wallpaperFileURL absoluteString] rangeOfString:@"HomeBackground"].location != NSNotFound) {
		homescreenWallpaperImage = configuration.wallpaperImage;
	}

	return self;
}

%end

%ctor {
	osVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
}