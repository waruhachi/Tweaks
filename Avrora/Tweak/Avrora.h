#import <MediaRemote/MediaRemote.h>
#import "SparkAppList.h"
#import "libpddokdo.h"
#import <Cephei/HBPreferences.h>

HBPreferences* preferences;

extern BOOL enabled;

// date
NSString* dateFormatValue = @"MMMM";

// clock
NSString* timeFormatValue = @"HH:mm";

// weather
BOOL conditionSwitch = NO;
BOOL temperatureSwitch = NO;

// now playing
BOOL songTitleSwitch = NO;
BOOL artistNameSwitch = NO;
NSString* songTitle = nil;
NSString* artistName = nil;

// miscellaneous
BOOL lowercaseAllLabelsSwitch = NO;
BOOL hideAllOtherLabelsSwitch = NO;

@interface SBApplication : NSObject
- (NSString *)bundleIdentifier;
- (NSString *)displayName;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
- (BOOL)isPaused;
@end