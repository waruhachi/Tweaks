#include <UIKit/UIKit.h>
#include <CustomToast/CustomToast.h>
#include <AudioToolbox/AudioToolbox.h>

@interface NSObject (Undocumented)
	- (id)safeValueForKey:(NSString *)key;
@end

@interface UITapGestureRecognizer (Additions)
	- (NSUInteger)numberOfTapsRequired;
@end

@interface CSCoverSheetViewController : UIViewController
@end

@interface SBWallpaperController : NSObject
	+ (id)sharedInstance;
@end

@interface PBUIPosterWallpaperRemoteViewController : UIViewController
@end

@interface PBUIPosterWallpaperViewController : UIViewController
@end

@interface SBHomeScreenViewController : UIViewController
@end

@interface SBFWallpaperView : UIView
	- (id)initWithFrame:(struct CGRect )arg0 configuration:(id)arg1 variant:(NSInteger)arg2 cacheGroup:(id)arg3 delegate:(id)arg4 options:(NSUInteger)arg5;
@end

@interface SBWallpaperImage : UIImage
	@property (readonly, copy, nonatomic) NSURL *wallpaperFileURL;
@end

@interface SBFWallpaperConfiguration : NSObject 
	@property (retain, nonatomic) SBWallpaperImage *wallpaperImage;
@end

static NSOperatingSystemVersion osVersion;
static SBWallpaperImage *lockscreenWallpaperImage;
static SBWallpaperImage *homescreenWallpaperImage;

static const SystemSoundID hapticSoundID = 1521;
static const NSUInteger numberOfTapsRequired = 3;