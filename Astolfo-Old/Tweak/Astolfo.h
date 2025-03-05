#import <roothide.h>
#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

#import "GcUniversal/GcImagePickerUtils.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

HBPreferences* preferences = nil;
BOOL enabled = NO;

UIImageView* astolfoImageView = nil;
UIVisualEffectView* blurView = nil;
UIBlurEffect* blur = nil;

// image customization
BOOL useCustomAstolfoImageSwitch = NO;
BOOL fillScreenSwitch = NO;
NSString* astolfoXPositionValue = @"0";
NSString* astolfoYPositionValue = @"150";
NSString* astolfoAlphaValue = @"1";

// background blur
NSString* blurValue = @"2";
NSString* blurAmountValue = @"0";

@interface SiriUIBackgroundBlurViewController : UIViewController
@end

@interface AFUISiriViewController : UIViewController
@end