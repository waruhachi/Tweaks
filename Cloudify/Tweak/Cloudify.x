#import "Cloudify.h"

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

%ctor {
	%init(
		AdPlayQueueManager = objc_getClass("AdPlayQueueManager"),
		UpsellManager = objc_getClass("SoundCloud.UpsellManager"),
		UserFeaturesService = objc_getClass("SoundCloud.UserFeaturesService"),
		AdsRequestPermitter = objc_getClass("SoundCloud.AdsRequestPermitter"),
		PlayQueueItemTrackEntity = objc_getClass("SoundCloud.PlayQueueItemTrackEntity"),
		GoUpsellButtonViewWrapper = objc_getClass("Payments.GoUpsellButtonViewWrapper"),
		DisplayAdBannerFeatureProvider = objc_getClass("Ads.DisplayAdBannerFeatureProvider"),
		AudioAdPlayerEventController = objc_getClass("SoundCloud.AudioAdPlayerEventController")
	);
}