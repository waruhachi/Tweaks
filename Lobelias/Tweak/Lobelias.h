#import <MediaRemote/MediaRemote.h>
#import <Kitten/libKitten.h>
#import "SparkColourPickerUtils.h"
#import <AudioToolbox/AudioServices.h>
#import "MusicLyricsBackgroundView.h"
#import "MarqueeLabel.h"
#import <Cephei/HBPreferences.h>

HBPreferences* preferences;
NSDictionary* preferencesDictionary;
UIColor* backgroundColor;
UIColor* primaryColor;
UIColor* secondaryColor;
MPArtworkCatalog* artworkCatalog;
MusicLyricsBackgroundView* lsMetalBackgroundView;

extern BOOL enabled;

UIStackView* stackView;
UIView* lobeliasView;
UIImage* currentArtwork;
NSData* lastArtworkData;
UIImageView* lsArtworkBackgroundImageView;
UIButton* lsArtworkImage;
UIImageView* pauseImage;
UIVisualEffectView* lsBlurView;
UIBlurEffect* lsBlur;
UILabel* songTitleLabel;
UILabel* artistNameLabel;
UIButton* rewindButton;
UIButton* skipButton;

// background
BOOL enableArtworkBackgroundSwitch = YES;
NSString* backgroundAlphaValue = @"1.0";
NSString* backgroundBlurValue = @"3";
NSString* backgroundBlurAlphaValue = @"1.0";
BOOL useLyricsBackgroundSwitch = NO;
BOOL artworkBackgroundTransitionSwitch = NO;

// artwork
NSString* artworkAlphaValue = @"1.0";
NSString* artworkCornerRadiusValue = @"115.0";
NSString* artworkBorderWidthValue = @"4.0";
BOOL artworkBorderCustomColorSwitch = NO;
BOOL pauseImageCustomColorSwitch = NO;
BOOL artworkBorderLibKittenSwitch = YES;
BOOL pauseImageLibKittenSwitch = YES;
BOOL artworkTransitionSwitch = NO;
BOOL artworkHapticFeedbackSwitch = NO;

// song title
NSString* songTitleAlphaValue = @"1.0";
NSString* songTitleFontSizeValue = @"24.0";
BOOL songTitleCustomColorSwitch = NO;
BOOL songTitleLibKittenSwitch = YES;
BOOL songTitleShadowSwitch = NO;
BOOL songTitleShadowLibKittenSwitch = NO;
NSString* songTitleShadowRadiusValue = @"0.0";
NSString* songTitleShadowOpacityValue = @"0.0";
NSString* songTitleShadowXValue = @"0.0";
NSString* songTitleShadowYValue = @"0.0";

// artist name
NSString* artistNameAlphaValue = @"1.0";
NSString* artistNameFontSizeValue = @"19.0";
BOOL artistNameShowArtistNameSwitch = YES;
BOOL artistNameShowAlbumNameSwitch = YES;
BOOL artistNameCustomColorSwitch = NO;
BOOL artistNameLibKittenSwitch = YES;
BOOL artistNameShadowSwitch = NO;
BOOL artistNameShadowLibKittenSwitch = NO;
NSString* artistNameShadowRadiusValue = @"0.0";
NSString* artistNameShadowOpacityValue = @"0.0";
NSString* artistNameShadowXValue = @"0.0";
NSString* artistNameShadowYValue = @"0.0";

// rewind button
NSString* rewindButtonAlphaValue = @"1.0";
NSString* rewindButtonCornerRadiusValue = @"27.5";
NSString* rewindButtonBorderWidthValue = @"0.0";
BOOL rewindButtonBackgroundCustomColorSwitch = NO;
BOOL rewindButtonCustomColorSwitch = NO;
BOOL rewindButtonBorderCustomColorSwitch = NO;
BOOL rewindButtonBackgroundLibKittenSwitch = YES;
BOOL rewindButtonLibKittenSwitch = YES;
BOOL rewindButtonBorderLibKittenSwitch = NO;
BOOL rewindButtonHapticFeedbackSwitch = NO;

// skip button
NSString* skipButtonAlphaValue = @"1.0";
NSString* skipButtonCornerRadiusValue = @"27.5";
NSString* skipButtonBorderWidthValue = @"0.0";
BOOL skipButtonBackgroundCustomColorSwitch = NO;
BOOL skipButtonCustomColorSwitch = NO;
BOOL skipButtonBorderCustomColorSwitch = NO;
BOOL skipButtonBackgroundLibKittenSwitch = YES;
BOOL skipButtonLibKittenSwitch = YES;
BOOL skipButtonBorderLibKittenSwitch = NO;
BOOL skipButtonHapticFeedbackSwitch = NO;

// others
NSString* scaleValue = @"1.0";
NSString* rewindSkipButtonInsetValue = @"0";
BOOL nextUpSupportSwitch = NO;

@interface CSCoverSheetViewController : UIViewController
@end

@interface CSNotificationAdjunctListViewController : UIViewController
- (void)rewindSong;
- (void)skipSong;
- (void)pausePlaySong;
@end

@interface NextUpViewController : UIViewController
- (id)initWithControlCenter:(BOOL)controlCenter defaultStyle:(long long)style;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPaused;
- (BOOL)isPlaying;
- (void)setNowPlayingInfo:(id)arg1;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
@end