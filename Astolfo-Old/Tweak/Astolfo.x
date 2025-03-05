#import "Astolfo.h"

%group Astolfo

%hook SiriUIBackgroundBlurViewController

- (void)viewDidLoad { // add astolfo

	%orig;

	// background blur
	if ([blurAmountValue doubleValue] != 0) {
		if (!blur) {
			if ([blurValue intValue] == 0)
				blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([blurValue intValue] == 1)
				blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			else if ([blurValue intValue] == 2)
				blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
		}
		if (!blurView) blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
		[blurView setFrame:[[self view] bounds]];
		[blurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[blurView setClipsToBounds:YES];
		[blurView setAlpha:[blurAmountValue doubleValue]];
		if (![blurView isDescendantOfView:[self view]]) [[self view] addSubview:blurView];
	}


	// astolfo image
	if (!astolfoImageView) astolfoImageView = [UIImageView new];

	if (!fillScreenSwitch)
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFit];
	else
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFill];

	if (!useCustomAstolfoImageSwitch)
		[astolfoImageView setImage:[UIImage imageWithContentsOfFile:jbroot(@"/Library/PreferenceBundles/AstolfoPreferences.bundle/astolfo.png")]];
	else
		[astolfoImageView setImage:[GcImagePickerUtils imageFromDefaults:@"love.litten.astolfopreferences" withKey:@"astolfoImage"]];
		
	[astolfoImageView setAlpha:0];
	if (![astolfoImageView isDescendantOfView:[self view]]) [[self view] addSubview:astolfoImageView];

	[astolfoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[astolfoImageView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = YES;
	[astolfoImageView.heightAnchor constraintEqualToConstant:self.view.bounds.size.height].active = YES;
	[astolfoImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:[astolfoXPositionValue doubleValue]].active = YES;
	[astolfoImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:[astolfoYPositionValue doubleValue]].active = YES;

}

- (void)viewWillAppear:(BOOL)animated { // fade astolfo when siri appears

	%orig;

	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[blurView setAlpha:[blurAmountValue doubleValue]];
		[astolfoImageView setAlpha:[astolfoAlphaValue doubleValue]];
	} completion:nil];

}

%end

%hook SiriPresentationViewController

- (void)viewWillDisappear:(BOOL)animated { // fade astolfo when siri disappears

	%orig;

	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[blurView setAlpha:0];
		[astolfoImageView setAlpha:0];
	} completion:nil];

}

%end

%end

%group Astolfo13

%hook AFUISiriViewController

- (void)viewDidLoad { // add astolfo

	%orig;

	if (!astolfoImageView) astolfoImageView = [UIImageView new];

	if (!fillScreenSwitch)
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFit];
	else
		[astolfoImageView setContentMode:UIViewContentModeScaleAspectFill];

	if (!useCustomAstolfoImageSwitch)
		[astolfoImageView setImage:[UIImage imageWithContentsOfFile:jbroot(@"/Library/PreferenceBundles/AstolfoPreferences.bundle/astolfo.png")]];
	else
		[astolfoImageView setImage:[GcImagePickerUtils imageFromDefaults:@"love.litten.astolfopreferences" withKey:@"astolfoImage"]];
		
	[astolfoImageView setAlpha:0];
	[[self view] addSubview:astolfoImageView];

	[astolfoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[astolfoImageView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = YES;
	[astolfoImageView.heightAnchor constraintEqualToConstant:self.view.bounds.size.height].active = YES;
	[astolfoImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:[astolfoXPositionValue doubleValue]].active = YES;
	[astolfoImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:[astolfoYPositionValue doubleValue]].active = YES;

}

- (void)viewWillAppear:(BOOL)animated { // fade astolfo when siri appears

	%orig;

	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[astolfoImageView setAlpha:[astolfoAlphaValue doubleValue]];
	} completion:nil];

}

- (void)viewWillDisappear:(BOOL)animated { // fade astolfo when siri disappears

	%orig;

	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[astolfoImageView setAlpha:0];
	} completion:nil];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.astolfopreferences"];

	[preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

	// image customization
	[preferences registerBool:&useCustomAstolfoImageSwitch default:NO forKey:@"useCustomAstolfoImage"];
	[preferences registerBool:&fillScreenSwitch default:NO forKey:@"fillScreen"];
	[preferences registerObject:&astolfoXPositionValue default:@"0" forKey:@"astolfoXPosition"];
	[preferences registerObject:&astolfoYPositionValue default:@"150" forKey:@"astolfoYPosition"];
	[preferences registerObject:&astolfoAlphaValue default:@"1" forKey:@"astolfoAlpha"];

	// background blur
	if (!SYSTEM_VERSION_LESS_THAN(@"14")) {
		[preferences registerObject:&blurValue default:@"2" forKey:@"blur"];
		[preferences registerObject:&blurAmountValue default:@"0" forKey:@"blurAmount"];
	}

	if (!SYSTEM_VERSION_LESS_THAN(@"14")) %init(Astolfo);
	else if (SYSTEM_VERSION_LESS_THAN(@"14")) %init(Astolfo13);

}