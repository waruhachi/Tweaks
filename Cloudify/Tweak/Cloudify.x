#import <UIKit/UIKit.h>

// UIColor category for hex conversion
@interface UIColor (Hex)
+ (UIColor *)colorFromHex:(NSString *)hex;
- (BOOL)matchesColor:(UIColor *)otherColor tolerance:(CGFloat)tolerance;
@end

@implementation UIColor (Hex)

+ (UIColor *)colorFromHex:(NSString *)hex {
    NSString *cleanHex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:cleanHex];
    unsigned hexValue = 0;
    [scanner scanHexInt:&hexValue];

    CGFloat alpha = 1.0;
    CGFloat red, green, blue;

    if (cleanHex.length == 8) {
        alpha = ((hexValue >> 24) & 0xFF) / 255.0;
        red = ((hexValue >> 16) & 0xFF) / 255.0;
        green = ((hexValue >> 8) & 0xFF) / 255.0;
        blue = (hexValue & 0xFF) / 255.0;
    } else {
        red = ((hexValue >> 16) & 0xFF) / 255.0;
        green = ((hexValue >> 8) & 0xFF) / 255.0;
        blue = (hexValue & 0xFF) / 255.0;
    }

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (BOOL)matchesColor:(UIColor *)otherColor tolerance:(CGFloat)tolerance {
    CGFloat r1, g1, b1, a1;
    CGFloat r2, g2, b2, a2;

    if (![self getRed:&r1 green:&g1 blue:&b1 alpha:&a1] ||
        ![otherColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2]) {
        return NO;
    }

    return fabs(r1 - r2) <= tolerance &&
           fabs(g1 - g2) <= tolerance &&
           fabs(b1 - b2) <= tolerance &&
           fabs(a1 - a2) <= tolerance;
}

@end

%hook UpsellManager
	- (bool)canNotUpsell {
		return YES;
	}

	- (bool)shouldUpsell {
		return NO;
	}

	- (bool)shouldUpsellCreator {
		return NO;
	}

	- (bool)shouldShowTabBarUpsell {
		return NO;
	}

	- (bool)shouldUpsellForTrack:(id)arg1 {
		return NO;
	}

	- (bool)shouldUpsellForPlaylist:(id)arg1 {
		return NO;
	}
%end

%hook UserFeaturesService
	- (bool)isNoAudioAdsEnabled {
		return YES;
	}

	- (bool)isEnrolledInBetaProgram {
		return YES;
	}

	- (bool)isHQAudioFeatureEnabled {
		return YES;
	}

	- (bool)isDevelopmentMenuEnabled {
		return YES;
	}

	- (bool)isOfflineSyncFeatureEnabled {
		return YES;
	}
%end

%hook AdsRequestPermitter
	- (bool)shouldReuqestAds {
		return NO;
	}
%end

%hook PlayQueueItemTrackEntity
	- (bool)isMonetizable {
		return NO;
	}

	- (id)initWithUrn:(id)arg1 transcodings:(id)arg2 streamURL:(id)arg3 waveformURL:(id)arg4 artistUrn:(id)arg5 stationUrn:(id)arg6 artistName:(id)arg7 title:(id)arg8 playQueueTitle:(id)arg9 playableDurationInMs:(unsigned long long)arg10 fullDurationInMs:(unsigned long long)arg11 monetizable:(bool)arg12 shareable:(bool)arg13 blocked:(bool)arg14 snipped:(bool)arg15 syncable:(bool)arg16 subMidTier:(bool)arg17 subHighTier:(bool)arg18 monetizationModel:(id)arg19 policy:(id)arg20 analyticsBag:(id)arg21 artworkUrn:(id)arg22 itemType:(long long)arg23 imageUrlTemplate:(id)arg24 secretToken:(id)arg25 playlistStationUrn:(id)arg26 permalinkURL:(id)arg27 genre:(id)arg28 {
		arg12 = NO;
		return %orig;
	}
%end

%hook GoUpsellButtonViewWrapper
	- (instancetype)init {
		self = %orig;

		if (self) {
			((UIView *)self).hidden = YES;
		}

		return self;
	}
%end

%hook DisplayAdBannerFeatureProvider
	- (bool)canShowDisplayAdBanner {
		return NO;
	}

	- (bool)canShowTrackPageAdBanner {
		return NO;
	}

	- (void)setCanShowDisplayAdBanner:(bool)arg1 {
		arg1 = NO;
		return %orig;
	}
%end

%hook AudioAdPlayerEventController
	- (id)init {
		return NULL;
	}
%end

%hook AdPlayQueueManager
	- (bool)isItemMonetizable:(id)arg1 {
		return NO;
	}
%end

// %hook HostingScrollView

// - (void)layoutSubviews {
//     %orig;

//     UIColor *targetColor = [UIColor colorFromHex:@"#262626"];
//     NSMutableArray *viewStack = [NSMutableArray arrayWithObject:self];

//     while (viewStack.count > 0) {
//         UIView *currentView = [viewStack lastObject];
//         [viewStack removeLastObject];

//         CGRect targetFrame = CGRectMake(28.0, 828.6666666666666, 372.0, 172.33333333333334);
//         CGFloat tolerance = 0.5;
//         BOOL frameMatches =
//             fabs(currentView.frame.origin.x - targetFrame.origin.x) <= tolerance &&
//             fabs(currentView.frame.origin.y - targetFrame.origin.y) <= tolerance &&
//             fabs(currentView.frame.size.width - targetFrame.size.width) <= tolerance &&
//             fabs(currentView.frame.size.height - targetFrame.size.height) <= tolerance;

//         if (
//             [NSStringFromClass([currentView class]) containsString:@"_UIGraphicsView"] &&
//             currentView.subviews.count == 0 &&
//             currentView.backgroundColor &&
//             [currentView.backgroundColor matchesColor:targetColor tolerance:0.05] &&
//             frameMatches
//         ) {
//             NSLog(@"[Cloudify] === Found target view ===");
//             UIView *parent = currentView.superview;

//             // Get index of current view in parent's subviews
//             NSUInteger currentIndex = [parent.subviews indexOfObject:currentView];

//             NSInteger startIndex = MAX(0, (NSInteger)currentIndex - 1);
//             NSInteger endIndex = MIN(parent.subviews.count - 1, currentIndex + 6);

//             NSMutableArray *adjacentGraphicsViews = [NSMutableArray new];

//             // Check neighbors within range
//             for (NSInteger i = startIndex; i <= endIndex; i++) {
//                 if (i == currentIndex) continue; // Skip self

//                 UIView *sibling = parent.subviews[i];
//                 [adjacentGraphicsViews addObject:sibling];
//                 // sibling.backgroundColor = [UIColor colorFromHex:@"#00FF00"];
//                 [sibling removeFromSuperview];
//                 if (adjacentGraphicsViews.count == 7) break;
//             }

//             // Log results
//             NSLog(@"[Cloudify] Adjacent _UIGraphicsViews (%lu/%lu):",
//                 (unsigned long)adjacentGraphicsViews.count,
//                 (unsigned long)(endIndex - startIndex));

//             for (UIView *sibling in adjacentGraphicsViews) {
//                 NSLog(@"[Cloudify] |-- Index: %lu", [parent.subviews indexOfObject:sibling]);
//                 NSLog(@"[Cloudify] |   Frame: %@", NSStringFromCGRect(sibling.frame));
//             }

//             NSLog(@"[Cloudify] ========================");
//             // currentView.backgroundColor = [UIColor colorFromHex:@"#FF0000"];
//         }

//         [viewStack addObjectsFromArray:currentView.subviews];
//     }
// }

// %end

%hook PlatformGroupContainer

// - (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
//     UIColor *targetColor = [UIColor colorFromHex:@"#262626"];
//     NSString *className = NSStringFromClass([view class]);

//     if ([className containsString:@"_UIGraphicsView"] &&
//         [view.backgroundColor matchesColor:targetColor tolerance:0.05]) {

//         static UIView *lastTrackedView = nil;
//         UIColor *desiredColor = [UIColor redColor];

//         if (lastTrackedView) {
//             lastTrackedView.backgroundColor = targetColor;
//         }

//         view.backgroundColor = desiredColor;
//         lastTrackedView = view;
//     }
// }

// - (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
//     NSLog(@"[Cloudify] (PlatformGroupContainer) <insertSubview> adding: %@ above: %@", NSStringFromClass([view class]), NSStringFromClass([siblingSubview class]));

//     %orig;
// }

// - (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
//     NSLog(@"[Cloudify] (PlatformGroupContainer) <insertSubview> adding: %@ below: %@", NSStringFromClass([view class]), NSStringFromClass([siblingSubview class]));

//     %orig;
// }

// - (void)didAddSubview:(UIView *)subview {
//     NSLog(@"[Cloudify] (PlatformGroupContainer) <didAddSubview> adding: %@", NSStringFromClass([subview class]));

//     %orig;
// }

%end

%ctor {
	%init(
		AdPlayQueueManager = objc_getClass("AdPlayQueueManager"),
		UpsellManager = objc_getClass("SoundCloud.UpsellManager"),
        // HostingScrollView = objc_getClass("SwiftUI.HostingScrollView"),
		UserFeaturesService = objc_getClass("SoundCloud.UserFeaturesService"),
		AdsRequestPermitter = objc_getClass("SoundCloud.AdsRequestPermitter"),
		PlayQueueItemTrackEntity = objc_getClass("SoundCloud.PlayQueueItemTrackEntity"),
		GoUpsellButtonViewWrapper = objc_getClass("Payments.GoUpsellButtonViewWrapper"),
		DisplayAdBannerFeatureProvider = objc_getClass("Ads.DisplayAdBannerFeatureProvider"),
		AudioAdPlayerEventController = objc_getClass("SoundCloud.AudioAdPlayerEventController"),
        // PlatformGroupContainer = objc_getClass("_TtCC7SwiftUI17HostingScrollView22PlatformGroupContainer")
	);
}
