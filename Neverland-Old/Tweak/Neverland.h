#import <UIKit/UIKit.h>

@interface SBApplication : NSObject
- (NSString *)bundleIdentifier;
@end

@interface SBMediaController
+ (id)sharedInstance;
- (BOOL)isPlaying;
- (SBApplication *)nowPlayingApplication;
@end

@interface SBAppLayout : NSObject
- (void)getAppId;
@end

@interface SBFluidSwitcherItemContainer : UIView
@end

@interface SBFluidSwitcherTouchPassThroughScrollView : UIScrollView
@end

NSString* swipeAppId = nil;
SBAppLayout* appLayout = nil;