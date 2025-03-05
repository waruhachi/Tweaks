#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>

@interface SPTNowPlayingMarqueeLabel : UILabel
@end

@interface SPTNowPlayingNavigationBarViewV2 : UIView
@end

@interface SPTNowPlayingViewController : UIViewController
@property(nonatomic, retain)UIImageView* stardustArtworkImageView;
@property(nonatomic, retain)CAGradientLayer* stardustArtworkGradient;
- (void)setArtwork;
@end

@interface SPTNowPlayingCoverArtCell : UIView
@end

@interface SPTNowPlayingInformationUnitViewController : UIViewController
@end

@interface SPTNowPlayingAnimatedLikeButton : UIButton
@end

@interface SPTNowPlayingDurationViewV2 : UIView
@end

@interface SPTNowPlayingShuffleButton : UIButton
@end

@interface SPTNowPlayingRepeatButton : UIButton
@end

@interface SPTGaiaDevicesAvailableViewImplementation : UIView
@end