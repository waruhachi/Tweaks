#import "Stardust.h"

%group Stardust

%hook SPTNowPlayingNavigationBarViewV2

- (void)didMoveToWindow { // remove playlist label(s)

	%orig;

	SPTNowPlayingMarqueeLabel* titleLabel = [self valueForKey:@"_titleLabel"];
	SPTNowPlayingMarqueeLabel* subtitleLabel = [self valueForKey:@"_subtitleLabel"];
	[titleLabel setHidden:YES];
	[subtitleLabel setHidden:YES];

}

%end

%hook MPNowPlayingInfoCenter

- (void)setNowPlayingInfo:(id)arg1 { // update the artwork when song changed
	
	%orig;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stardustUpdateArtwork" object:nil];
    });

}

%end

%hook SPTNowPlayingCoverArtCell

- (void)didMoveToWindow { // remove original artwork

	%orig;

	[self setHidden:YES];

}

%end

%hook SPTNowPlayingViewController

%property(nonatomic, retain)UIImageView* stardustArtworkImageView;
%property(nonatomic, retain)CAGradientLayer* stardustArtworkGradient;

- (void)viewDidLoad { // add background artwork

	%orig;


	// artwork
	self.stardustArtworkImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	[[self stardustArtworkImageView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[[self stardustArtworkImageView] setContentMode:UIViewContentModeScaleAspectFill];
	[[self view] insertSubview:[self stardustArtworkImageView] atIndex:0];


	// gradient
	self.stardustArtworkGradient = [CAGradientLayer layer];
	[[self stardustArtworkGradient] setFrame:[[self view] bounds]];
	[[self stardustArtworkGradient] setColors:@[(id)[[UIColor clearColor] CGColor], (id)[[[UIColor blackColor] colorWithAlphaComponent:1] CGColor]]];
	[[[self view] layer] insertSublayer:[self stardustArtworkGradient] atIndex:1];


	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setArtwork) name:@"stardustUpdateArtwork" object:nil];

}

- (void)viewWillAppear:(BOOL)animated { // update the artwork when now playing view appears

	%orig;

	[self setArtwork];

}

%new
- (void)setArtwork { // get the current artwork and apply it

	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		NSDictionary* dict = (__bridge NSDictionary *)information;
		if (dict) {
			if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
				[[self stardustArtworkImageView] setImage:[UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]];
			}
      	}
  	});

}

%end

%hook SPTNowPlayingInformationUnitViewController

- (void)viewDidLoad { // change font size of the song title and artist label as well as centering them

	%orig;


	// artist label
	SPTNowPlayingMarqueeLabel* subtitleLabel = [self valueForKey:@"_subtitleLabel"];

    [subtitleLabel setFont:[UIFont fontWithName:@"CircularSpUI-Book" size:18]];

	[subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [subtitleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    ]];


	// song title label
	SPTNowPlayingMarqueeLabel* titleLabel = [self valueForKey:@"_titleLabel"];

    [titleLabel setFont:[UIFont fontWithName:@"CircularSpUIm40-Bold" size:32]];
	
	[titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
		[titleLabel.bottomAnchor constraintEqualToAnchor:subtitleLabel.topAnchor constant:-2],
    ]];

}

%end

%hook SPTNowPlayingAnimatedLikeButton

- (void)didMoveToWindow { // hide like button

	%orig;

	[self setHidden:YES];

}

%end

%hook SPTNowPlayingDurationViewV2

- (void)didMoveToWindow { // hide remaining and elapsed time label

	%orig;

	UILabel* remainingTimeLabel = [self valueForKey:@"_timeRemainingLabel"];
	UILabel* elapsedTimeLabel = [self valueForKey:@"_timeTakenLabel"];
	[remainingTimeLabel setHidden:YES];
	[elapsedTimeLabel setHidden:YES];

}

%end

%hook SPTNowPlayingShuffleButton

- (void)didMoveToWindow { // hide shuffle button

	%orig;

	[self setHidden:YES];

}

%end

%hook SPTNowPlayingRepeatButton

- (void)didMoveToWindow { // hide repeat button

	%orig;

	[self setHidden:YES];

}

%end

%hook SPTGaiaDevicesAvailableViewImplementation

- (void)didMoveToWindow {

	%orig;

	UILabel* devicesLabel = [self valueForKey:@"_devicesLabel"];
	UIImageView* iconImageView = [self valueForKey:@"_iconImageView"];

	[devicesLabel setTextColor:[UIColor whiteColor]];
	[iconImageView setTintColor:[UIColor whiteColor]];

}

%end

%end

%ctor {

	%init(Stardust);

}