#import "Lobelias.h"

BOOL enabled;

NextUpViewController* nextUpViewController;

%group Lobelias

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add lobelias

	%orig;

    if (!enableArtworkBackgroundSwitch) return;
    // background
	if (!lsArtworkBackgroundImageView) {
        lsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
        [lsArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [lsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
        [lsArtworkBackgroundImageView setClipsToBounds:YES];
        [lsArtworkBackgroundImageView setAlpha:[backgroundAlphaValue doubleValue]];
		[lsArtworkBackgroundImageView setHidden:YES];
        [[self view] insertSubview:lsArtworkBackgroundImageView atIndex:0];
    }
    
    // background blur
    if (lsArtworkBackgroundImageView && !lsBlur && [backgroundBlurValue intValue] != 0) {
        if ([backgroundBlurValue intValue] == 1)
            lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        else if ([backgroundBlurValue intValue] == 2)
            lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        else if ([backgroundBlurValue intValue] == 3)
            lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        if (!lsBlurView) lsBlurView = [[UIVisualEffectView alloc] initWithEffect:lsBlur];
        [lsBlurView setFrame:[lsArtworkBackgroundImageView bounds]];
        [lsBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [lsBlurView setClipsToBounds:YES];
        [lsBlurView setAlpha:[backgroundBlurAlphaValue doubleValue]];
        [lsArtworkBackgroundImageView addSubview:lsBlurView];
    }

    // animated lyrics background
    if (useLyricsBackgroundSwitch) {
        NSString* path = [%c(LSApplicationProxy) applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
        path = [path stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
        [[NSBundle bundleWithPath:path] load];

        if (currentArtwork && !artworkCatalog) artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
        if (!lsMetalBackgroundView) lsMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];
        if (artworkCatalog) [lsMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

        [lsMetalBackgroundView setFrame:[lsArtworkBackgroundImageView bounds]];
        [lsMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [lsMetalBackgroundView setClipsToBounds:YES];
        [[self view] insertSubview:lsMetalBackgroundView atIndex:0];
    }

}
%end


%hook CSAdjunctItemView

- (id)initWithFrame:(CGRect)frame { // remove original player

    return nil;

}

%end

%hook CSNotificationAdjunctListViewController

- (void)viewDidLoad {

    %orig;

    CGFloat lobeliasHeight = 0.0;
    CGFloat last = 0.0;

    if (!stackView) stackView = [self valueForKey:@"_stackView"];

    if (!lobeliasView) {
        lobeliasView = [UIView new];
        [lobeliasView.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width].active = YES;
        [lobeliasView setTransform:CGAffineTransformMakeScale([scaleValue doubleValue], [scaleValue doubleValue])];
        [lobeliasView setHidden:YES];
    }

    [stackView addArrangedSubview:lobeliasView];
    [lobeliasView.centerXAnchor constraintEqualToAnchor:stackView.centerXAnchor].active = YES;

    // artwork
    if (!lsArtworkImage) {
         lsArtworkImage = [UIButton new];
        [lsArtworkImage addTarget:self action:@selector(pausePlaySong) forControlEvents:UIControlEventTouchDown];
        [lsArtworkImage setContentMode:UIViewContentModeScaleAspectFill];
        [lsArtworkImage setClipsToBounds:YES];
        [[lsArtworkImage layer] setCornerRadius:[artworkCornerRadiusValue doubleValue]];
        if (artworkBorderCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"artworkBorderColor"] withFallback:@"#ffffff"];
            [[lsArtworkImage layer] setBorderColor:[customColor CGColor]];
        } else {
            [[lsArtworkImage layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        }
        [[lsArtworkImage layer] setBorderWidth:[artworkBorderWidthValue doubleValue]];
        [lsArtworkImage setAdjustsImageWhenHighlighted:NO];
        [lsArtworkImage setAlpha:[artworkAlphaValue doubleValue]];
        [lobeliasView addSubview:lsArtworkImage];

        [lsArtworkImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        [lsArtworkImage.widthAnchor constraintEqualToConstant:230.0].active = YES;
        [lsArtworkImage.heightAnchor constraintEqualToConstant:230.0].active = YES;
        [lsArtworkImage.centerXAnchor constraintEqualToAnchor:lobeliasView.centerXAnchor].active = YES;
        [lsArtworkImage.topAnchor constraintEqualToAnchor:lobeliasView.topAnchor].active = YES;
        lobeliasHeight += 230.0;
    }
    
    // pause image
    if (!pauseImage && lsArtworkImage) {
        pauseImage = [[UIImageView alloc] initWithFrame:[lsArtworkImage bounds]];
        [pauseImage setContentMode:UIViewContentModeScaleAspectFit];
        [pauseImage setClipsToBounds:YES];
        [pauseImage setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/pauseImage.png"]];
        pauseImage.image = [pauseImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (pauseImageCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"pauseImageColor"] withFallback:@"#ffffff"];
            [pauseImage setTintColor:customColor];
        } else {
            [pauseImage setTintColor:[UIColor whiteColor]];
        }
        [pauseImage setAlpha:0.0];
        [pauseImage setHidden:NO];
        [lsArtworkImage addSubview:pauseImage];
    }
    
    // song title
    if (!songTitleLabel) {
        songTitleLabel = [MarqueeLabel new];
        if (songTitleCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"songTitleColor"] withFallback:@"#ffffff"];
            [songTitleLabel setTextColor:customColor];
        } else {
            [songTitleLabel setTextColor:[UIColor whiteColor]];
        }
        [songTitleLabel setFont:[UIFont systemFontOfSize:[songTitleFontSizeValue doubleValue] weight:UIFontWeightSemibold]];
        if (songTitleShadowSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"songTitleShadowColor"] withFallback:@"#ffffff"];
            [[songTitleLabel layer] setShadowColor:[customColor CGColor]];
            [[songTitleLabel layer] setShadowRadius:[songTitleShadowRadiusValue doubleValue]];
            [[songTitleLabel layer] setShadowOpacity:[songTitleShadowOpacityValue doubleValue]];
            [[songTitleLabel layer] setShadowOffset:CGSizeMake([songTitleShadowXValue doubleValue], [songTitleShadowYValue doubleValue])];
        }
        [songTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [songTitleLabel setAlpha:[songTitleAlphaValue doubleValue]];
        [lobeliasView addSubview:songTitleLabel];

        [songTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [songTitleLabel.widthAnchor constraintEqualToConstant:180.0 - [rewindSkipButtonInsetValue intValue]].active = YES;
        [songTitleLabel.heightAnchor constraintEqualToConstant:29.0].active = YES;
        [songTitleLabel.centerXAnchor constraintEqualToAnchor:lobeliasView.centerXAnchor].active = YES;
        [songTitleLabel.centerYAnchor constraintEqualToAnchor:lsArtworkImage.bottomAnchor constant:55.0].active = YES;
        lobeliasHeight += 69.5;
    }
    
    // artist name & album title
    if (!artistNameLabel) {
        artistNameLabel = [MarqueeLabel new];
        if (artistNameCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"artistNameColor"] withFallback:@"#ffffff"];
            [artistNameLabel setTextColor:customColor];
        } else {
            [artistNameLabel setTextColor:[UIColor colorWithRed: 0.65 green: 0.65 blue: 0.65 alpha: 1.00]];
        }
        [artistNameLabel setFont:[UIFont systemFontOfSize:[artistNameFontSizeValue doubleValue]]];
        if (artistNameShadowSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"artistNameShadowColor"] withFallback:@"#ffffff"];
            [[artistNameLabel layer] setShadowColor:[customColor CGColor]];
            [[artistNameLabel layer] setShadowRadius:[artistNameShadowRadiusValue doubleValue]];
            [[artistNameLabel layer] setShadowOpacity:[artistNameShadowOpacityValue doubleValue]];
            [[artistNameLabel layer] setShadowOffset:CGSizeMake([artistNameShadowXValue doubleValue], [artistNameShadowYValue doubleValue])];
        }
        [artistNameLabel setTextAlignment:NSTextAlignmentCenter];
        [artistNameLabel setAlpha:[artistNameAlphaValue doubleValue]];
        [lobeliasView addSubview:artistNameLabel];

        [artistNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [artistNameLabel.widthAnchor constraintEqualToConstant:180.0 - [rewindSkipButtonInsetValue intValue]].active = YES;
        [artistNameLabel.heightAnchor constraintEqualToConstant:21.0].active = YES;
        [artistNameLabel.centerXAnchor constraintEqualToAnchor:songTitleLabel.centerXAnchor].active = YES;
        [artistNameLabel.topAnchor constraintEqualToAnchor:songTitleLabel.bottomAnchor constant:0.0].active = YES;
        lobeliasHeight += 31;
    }
    
    // rewind button
    if (!rewindButton) {
        rewindButton = [UIButton new];
        [rewindButton addTarget:self action:@selector(rewindSong) forControlEvents:UIControlEventTouchUpInside];
        UIImage* rewindImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/rewindImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [rewindButton setImage:rewindImage forState:UIControlStateNormal];
        [rewindButton setClipsToBounds:YES];
        [[rewindButton layer] setCornerRadius:[rewindButtonCornerRadiusValue doubleValue]];
        if (rewindButtonBackgroundCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"rewindButtonBackgroundColor"] withFallback:@"#ffffff"];
            [rewindButton setBackgroundColor:customColor];
        } else {
            [rewindButton setBackgroundColor:[UIColor colorWithRed: 0.44 green: 0.44 blue: 0.44 alpha: 1.00]];
        }
        if (rewindButtonCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"rewindButtonColor"] withFallback:@"#ffffff"];
            [rewindButton setTintColor:customColor];
        } else {
            [rewindButton setTintColor:[UIColor whiteColor]];
        }
        if (rewindButtonBorderCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"rewindButtonBorderColor"] withFallback:@"#ffffff"];
            [[rewindButton layer] setBorderColor:[customColor CGColor]];
        } else {
            [[rewindButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        }
        [[rewindButton layer] setBorderWidth:[rewindButtonBorderWidthValue doubleValue]];
        [rewindButton setAdjustsImageWhenHighlighted:NO];
        [rewindButton setAlpha:[rewindButtonAlphaValue doubleValue]];
        [lobeliasView addSubview:rewindButton];

        [rewindButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [rewindButton.widthAnchor constraintEqualToConstant:55.0].active = YES;
        [rewindButton.heightAnchor constraintEqualToConstant:55.0].active = YES;
        [rewindButton.centerXAnchor constraintEqualToAnchor:songTitleLabel.leftAnchor constant:-40.0].active = YES;
        [rewindButton.centerYAnchor constraintEqualToAnchor:lsArtworkImage.bottomAnchor constant:65.0].active = YES;
        if (!songTitleLabel && last + 23 > lobeliasHeight)
            lobeliasHeight = last + 23;
        else if (lobeliasHeight == 299.5)
            lobeliasHeight += 23;
    }
    
    // skip button
    if (!skipButton) {
        skipButton = [UIButton new];
        [skipButton addTarget:self action:@selector(skipSong) forControlEvents:UIControlEventTouchUpInside];
        UIImage* skipImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LobeliasPrefs.bundle/skipImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [skipButton setImage:skipImage forState:UIControlStateNormal];
        [skipButton setClipsToBounds:YES];
        [[skipButton layer] setCornerRadius:[skipButtonCornerRadiusValue doubleValue]];
        if (skipButtonBackgroundCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"skipButtonBackgroundColor"] withFallback:@"#ffffff"];
            [skipButton setBackgroundColor:customColor];
        } else {
            [skipButton setBackgroundColor:[UIColor colorWithRed: 0.44 green: 0.44 blue: 0.44 alpha: 1.00]];
        }
        if (skipButtonCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"skipButtonColor"] withFallback:@"#ffffff"];
            [skipButton setTintColor:customColor];
        } else {
            [skipButton setTintColor:[UIColor whiteColor]];
        }
        if (skipButtonBorderCustomColorSwitch) {
            UIColor* customColor = [SparkColourPickerUtils colourWithString:[preferencesDictionary objectForKey:@"skipButtonBorderColor"] withFallback:@"#ffffff"];
            [[skipButton layer] setBorderColor:[customColor CGColor]];
        } else {
            [[skipButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        }
        [[skipButton layer] setBorderWidth:[skipButtonBorderWidthValue doubleValue]];
        [skipButton setAdjustsImageWhenHighlighted:NO];
        [skipButton setAlpha:[skipButtonAlphaValue doubleValue]];
        [lobeliasView addSubview:skipButton];

        [skipButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [skipButton.widthAnchor constraintEqualToConstant:55.0].active = YES;
        [skipButton.heightAnchor constraintEqualToConstant:55.0].active = YES;
        [skipButton.centerXAnchor constraintEqualToAnchor:songTitleLabel.rightAnchor constant:40.0].active = YES;
        [skipButton.centerYAnchor constraintEqualToAnchor:lsArtworkImage.bottomAnchor constant:65.0].active = YES;
        if (!songTitleLabel && last + 23 > lobeliasHeight)
            lobeliasHeight = last + 23;
        else if (lobeliasHeight == 299.5)
            lobeliasHeight += 23;
    }

    if (!nextUpViewController && nextUpSupportSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/NextUp.dylib"]) {
        nextUpViewController = [[%c(NextUpViewController) alloc] initWithControlCenter:NO defaultStyle:3];
        [nextUpViewController.view.widthAnchor constraintEqualToConstant:lobeliasView.bounds.size.width - 40].active = YES;
        [nextUpViewController.view.heightAnchor constraintEqualToConstant:100.0].active = YES;
        [nextUpViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addChildViewController:nextUpViewController];
        [nextUpViewController didMoveToParentViewController:self];
        [lobeliasView addSubview:[nextUpViewController view]];
        
        [nextUpViewController.view.centerXAnchor constraintEqualToAnchor:lobeliasView.centerXAnchor].active = YES;
        [nextUpViewController.view.centerYAnchor constraintEqualToAnchor:artistNameLabel.bottomAnchor constant:65.0].active = YES;
        if (!songTitleLabel && last + 115 > lobeliasHeight)
            lobeliasHeight = last + 115;
        else
            lobeliasHeight += 115;
    }

    CGFloat max = 0;

    for (UIView* view in lobeliasView.subviews) {
        if ((view.frame.origin.y + view.frame.size.height) > max)
            max = (view.frame.origin.y + view.frame.size.height);
    }

    if (max > lobeliasHeight)
        lobeliasHeight = max;

    lobeliasView.translatesAutoresizingMaskIntoConstraints = NO;
    [lobeliasView.heightAnchor constraintEqualToConstant:lobeliasHeight].active = YES;

}

%new
- (void)rewindSong { // rewind song

	[[%c(SBMediaController) sharedInstance] changeTrack:-1 eventSource:0];

    [UIView animateWithDuration:0.16 delay:0 usingSpringWithDamping:400 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseIn animations:^{ // bounce animation
        rewindButton.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.16 delay:0 usingSpringWithDamping:1000 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            rewindButton.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }];

    if (rewindButtonHapticFeedbackSwitch) AudioServicesPlaySystemSound(1519);

}

%new
- (void)skipSong { // skip song

	[[%c(SBMediaController) sharedInstance] changeTrack:1 eventSource:0];

    [UIView animateWithDuration:0.16 delay:0 usingSpringWithDamping:400 initialSpringVelocity:40 options:UIViewAnimationOptionCurveEaseIn animations:^{ // bounce animation
        skipButton.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.16 delay:0 usingSpringWithDamping:1000 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            skipButton.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }];

    if (skipButtonHapticFeedbackSwitch) AudioServicesPlaySystemSound(1519);

}

%new
- (void)pausePlaySong { // pause/play song

	[[%c(SBMediaController) sharedInstance] togglePlayPauseForEventSource:0];
    
    [pauseImage setFrame:[lsArtworkImage bounds]];
    pauseImage.image = [pauseImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pauseImage setTintColor:secondaryColor];
    if (![[%c(SBMediaController) sharedInstance] isPaused]) {
        [UIView animateWithDuration:0.15 delay:0.1 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image fade animation
            [pauseImage setAlpha:1.0];
            pauseImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        [UIView animateWithDuration:0.4 delay:0.15 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image fade animation
            [pauseImage setAlpha:0.0];
            pauseImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
            } completion:nil];
        }];
    }

    [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{ // bounce animation
        lsArtworkImage.transform = CGAffineTransformMakeScale(0.98, 0.98);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            lsArtworkImage.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }];

    if (artworkHapticFeedbackSwitch) AudioServicesPlaySystemSound(1519);

}

%end

%end

%group LobeliasData

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // set now playing info

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;

            currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]; // set artwork
            [songTitleLabel setText:[NSString stringWithFormat:@"%@ ", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle]]]; // set song title
            if (artistNameShowArtistNameSwitch && artistNameShowAlbumNameSwitch)
                [artistNameLabel setText:[NSString stringWithFormat:@"%@ - %@ ", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist], [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum]]]; // set artist and album name
            else if (artistNameShowArtistNameSwitch && !artistNameShowAlbumNameSwitch)
                [artistNameLabel setText:[NSString stringWithFormat:@"%@ ", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist]]]; // set artist name
            else if (!artistNameShowArtistNameSwitch && artistNameShowAlbumNameSwitch)
                [artistNameLabel setText:[NSString stringWithFormat:@"%@ ", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum]]]; // set album name

            if (dict) {
                if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
                    // set images
                    if (!artworkTransitionSwitch) {
                        [lsArtworkImage setImage:currentArtwork forState:UIControlStateNormal];
                    } else {
                        [UIView transitionWithView:lsArtworkImage duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                            [lsArtworkImage setImage:currentArtwork forState:UIControlStateNormal];
                        } completion:nil];
                    }
                    if (!artworkBackgroundTransitionSwitch) {
                        [lsArtworkBackgroundImageView setImage:currentArtwork];
                    } else {
                        [UIView transitionWithView:lsArtworkBackgroundImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                            [lsArtworkBackgroundImageView setImage:currentArtwork];
                        } completion:nil];
                    }

                    // unhide elements
                    [lobeliasView setHidden:NO];
                    lobeliasView.superview.frame = CGRectMake(lobeliasView.superview.frame.origin.x,lobeliasView.superview.frame.origin.y,lobeliasView.superview.frame.size.width,lobeliasView.superview.frame.size.height+lobeliasView.frame.size.height);
                    [lsArtworkBackgroundImageView setHidden:NO];

                    if (![lastArtworkData isEqual:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]) {
                        // get libKitten colors
                        backgroundColor = [libKitten backgroundColor:currentArtwork];
                        primaryColor = [libKitten primaryColor:currentArtwork];
                        secondaryColor = [libKitten secondaryColor:currentArtwork];

                        // set libKitten colors
                        if (pauseImageLibKittenSwitch) [pauseImage setTintColor:secondaryColor];
                        if (artworkBorderLibKittenSwitch) [[lsArtworkImage layer] setBorderColor:[backgroundColor CGColor]];
                        if (songTitleLibKittenSwitch) [songTitleLabel setTextColor:primaryColor];
                        if (songTitleShadowLibKittenSwitch) [[songTitleLabel layer] setShadowColor:[primaryColor CGColor]];
                        if (artistNameLibKittenSwitch) [artistNameLabel setTextColor:secondaryColor];
                        if (artistNameShadowLibKittenSwitch) [[artistNameLabel layer] setShadowColor:[secondaryColor CGColor]];
                        if (rewindButtonBackgroundLibKittenSwitch) [rewindButton setBackgroundColor:backgroundColor];
                        if (rewindButtonLibKittenSwitch) [rewindButton setTintColor:primaryColor];
                        if (rewindButtonBorderLibKittenSwitch) [[rewindButton layer] setBorderColor:[secondaryColor CGColor]];
                        if (skipButtonBackgroundLibKittenSwitch) [skipButton setBackgroundColor:backgroundColor];
                        if (skipButtonLibKittenSwitch) [skipButton setTintColor:primaryColor];
                        if (skipButtonBorderLibKittenSwitch) [[skipButton layer] setBorderColor:[secondaryColor CGColor]];
                    }

                    lastArtworkData = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData];
                }
            }
        } else { // hide everything if not playing
            [lobeliasView setHidden:YES];
            lobeliasView.superview.frame = CGRectMake(lobeliasView.superview.frame.origin.x,lobeliasView.superview.frame.origin.y,lobeliasView.superview.frame.size.width,0);
            [lsArtworkBackgroundImageView setHidden:YES];
        }
  	});
    
}

- (void)_mediaRemoteNowPlayingApplicationIsPlayingDidChange:(id)arg1 { // show pause image when event source has paused playback

    %orig;

    [pauseImage setFrame:[lsArtworkImage bounds]];
    pauseImage.image = [pauseImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [pauseImage setTintColor:secondaryColor];
    if ([self isPaused]) {
        [UIView animateWithDuration:0.15 delay:0.1 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image animation
            [pauseImage setAlpha:1.0];
            pauseImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        [UIView animateWithDuration:0.4 delay:0.15 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{ // pause image animation
            [pauseImage setAlpha:0.0];
            pauseImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:400 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [pauseImage setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
            } completion:nil];
        }];
    }

}

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 { // reload data after a respring

    %orig;

    [[%c(SBMediaController) sharedInstance] setNowPlayingInfo:0];
    
}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.lobeliaspreferences"];
    preferencesDictionary = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/love.litten.lobelias.colorspreferences.plist"]];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];

    // background
    [preferences registerBool:&enableArtworkBackgroundSwitch default:YES forKey:@"enableArtworkBackground"];
    [preferences registerObject:&backgroundAlphaValue default:@"1.0" forKey:@"backgroundAlpha"];
    [preferences registerObject:&backgroundBlurValue default:@"3" forKey:@"backgroundBlur"];
    [preferences registerObject:&backgroundBlurAlphaValue default:@"1.0" forKey:@"backgroundBlurAlpha"];
    [preferences registerBool:&useLyricsBackgroundSwitch default:NO forKey:@"useLyricsBackground"];
    [preferences registerBool:&artworkBackgroundTransitionSwitch default:NO forKey:@"artworkBackgroundTransition"];

    // artwork
    [preferences registerObject:&artworkAlphaValue default:@"1.0" forKey:@"artworkAlpha"];
    [preferences registerObject:&artworkCornerRadiusValue default:@"115.0" forKey:@"artworkCornerRadius"];
    [preferences registerObject:&artworkBorderWidthValue default:@"4.0" forKey:@"artworkBorderWidth"];
    [preferences registerBool:&artworkBorderCustomColorSwitch default:NO forKey:@"artworkBorderCustomColor"];
    [preferences registerBool:&pauseImageCustomColorSwitch default:NO forKey:@"pauseImageCustomColor"];
    [preferences registerBool:&artworkBorderLibKittenSwitch default:YES forKey:@"artworkBorderLibKitten"];
    [preferences registerBool:&pauseImageLibKittenSwitch default:YES forKey:@"pauseImageLibKitten"];
    [preferences registerBool:&artworkTransitionSwitch default:NO forKey:@"artworkTransition"];
    [preferences registerBool:&artworkHapticFeedbackSwitch default:NO forKey:@"artworkHapticFeedback"];

    // song title
    [preferences registerObject:&songTitleAlphaValue default:@"1.0" forKey:@"songTitleAlpha"];
    [preferences registerObject:&songTitleFontSizeValue default:@"24.0" forKey:@"songTitleFontSize"];
    [preferences registerBool:&songTitleCustomColorSwitch default:NO forKey:@"songTitleCustomColor"];
    [preferences registerBool:&songTitleLibKittenSwitch default:YES forKey:@"songTitleLibKitten"];
    [preferences registerBool:&songTitleShadowSwitch default:NO forKey:@"songTitleShadow"];
    [preferences registerBool:&songTitleShadowLibKittenSwitch default:NO forKey:@"songTitleShadowLibKitten"];
    [preferences registerObject:&songTitleShadowRadiusValue default:@"0.0" forKey:@"songTitleShadowRadius"];
    [preferences registerObject:&songTitleShadowOpacityValue default:@"0.0" forKey:@"songTitleShadowOpacity"];
    [preferences registerObject:&songTitleShadowXValue default:@"0.0" forKey:@"songTitleShadowX"];
    [preferences registerObject:&songTitleShadowYValue default:@"0.0" forKey:@"songTitleShadowY"];

    // artist name
    [preferences registerObject:&artistNameAlphaValue default:@"1.0" forKey:@"artistNameAlpha"];
    [preferences registerObject:&artistNameFontSizeValue default:@"19.0" forKey:@"artistNameFontSize"];
    [preferences registerBool:&artistNameShowArtistNameSwitch default:YES forKey:@"artistNameShowArtistName"];
    [preferences registerBool:&artistNameShowAlbumNameSwitch default:YES forKey:@"artistNameShowAlbumName"];
    [preferences registerBool:&artistNameCustomColorSwitch default:NO forKey:@"artistNameCustomColor"];
    [preferences registerBool:&artistNameLibKittenSwitch default:YES forKey:@"artistNameLibKitten"];
    [preferences registerBool:&artistNameShadowSwitch default:NO forKey:@"artistNameShadow"];
    [preferences registerBool:&artistNameShadowLibKittenSwitch default:NO forKey:@"artistNameShadowLibKitten"];
    [preferences registerObject:&artistNameShadowRadiusValue default:@"0.0" forKey:@"artistNameShadowRadius"];
    [preferences registerObject:&artistNameShadowOpacityValue default:@"0.0" forKey:@"artistNameShadowOpacity"];
    [preferences registerObject:&artistNameShadowXValue default:@"0.0" forKey:@"artistNameShadowX"];
    [preferences registerObject:&artistNameShadowYValue default:@"0.0" forKey:@"artistNameShadowY"];

    // rewind button
    [preferences registerObject:&rewindButtonAlphaValue default:@"1.0" forKey:@"rewindButtonAlpha"];
    [preferences registerObject:&rewindButtonCornerRadiusValue default:@"27.5" forKey:@"rewindButtonCornerRadius"];
    [preferences registerObject:&rewindButtonBorderWidthValue default:@"0.0" forKey:@"rewindButtonBorderWidth"];
    [preferences registerBool:&rewindButtonBackgroundCustomColorSwitch default:NO forKey:@"rewindButtonBackgroundCustomColor"];
    [preferences registerBool:&rewindButtonCustomColorSwitch default:NO forKey:@"rewindButtonCustomColor"];
    [preferences registerBool:&rewindButtonBorderCustomColorSwitch default:NO forKey:@"rewindButtonBorderCustomColor"];
    [preferences registerBool:&rewindButtonBackgroundLibKittenSwitch default:YES forKey:@"rewindButtonBackgroundLibKitten"];
    [preferences registerBool:&rewindButtonLibKittenSwitch default:YES forKey:@"rewindButtonLibKitten"];
    [preferences registerBool:&rewindButtonBorderLibKittenSwitch default:NO forKey:@"rewindButtonBorderLibKitten"];
    [preferences registerBool:&rewindButtonHapticFeedbackSwitch default:NO forKey:@"rewindButtonHapticFeedback"];

    // skip button
    [preferences registerObject:&skipButtonAlphaValue default:@"1.0" forKey:@"skipButtonAlpha"];
    [preferences registerObject:&skipButtonCornerRadiusValue default:@"27.5" forKey:@"skipButtonCornerRadius"];
    [preferences registerObject:&skipButtonBorderWidthValue default:@"0.0" forKey:@"skipButtonBorderWidth"];
    [preferences registerBool:&skipButtonBackgroundCustomColorSwitch default:NO forKey:@"skipButtonBackgroundCustomColor"];
    [preferences registerBool:&skipButtonCustomColorSwitch default:NO forKey:@"skipButtonCustomColor"];
    [preferences registerBool:&skipButtonBorderCustomColorSwitch default:NO forKey:@"skipButtonBorderCustomColor"];
    [preferences registerBool:&skipButtonBackgroundLibKittenSwitch default:YES forKey:@"skipButtonBackgroundLibKitten"];
    [preferences registerBool:&skipButtonLibKittenSwitch default:YES forKey:@"skipButtonLibKitten"];
    [preferences registerBool:&skipButtonBorderLibKittenSwitch default:YES forKey:@"skipButtonBorderLibKitten"];
    [preferences registerBool:&skipButtonHapticFeedbackSwitch default:NO forKey:@"skipButtonHapticFeedback"];

    // others
    [preferences registerObject:&scaleValue default:@"1.0" forKey:@"scale"];
    [preferences registerObject:&rewindSkipButtonInsetValue default:@"0" forKey:@"rewindSkipButtonInset"];
    [preferences registerBool:&nextUpSupportSwitch default:NO forKey:@"nextUpSupport"];

	if (enabled) {
        %init(Lobelias);
        %init(LobeliasData);
    }

}