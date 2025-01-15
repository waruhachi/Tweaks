#import "Koi.h"

_UIContextMenuContainerView* contextMenuContainerView = nil;

%group Koi

%hook _UIContextMenuActionsListView

- (void)willMoveToWindow:(UIWindow *)newWindow {

	if (!enableMenuColoringSwitch) return %orig;
	if ([[self subviews] count] && [self.subviews objectAtIndex:0] && [[([[self subviews] objectAtIndex:0]) subviews] count]) {
		UIView* collectionView = [[([[self subviews] objectAtIndex:0]) subviews] objectAtIndex:0];
		UIView* visualEffectView = [[([[collectionView subviews] objectAtIndex:0]) subviews] objectAtIndex:0];
		[collectionView setBackgroundColor:currentBundleMenuColor];
		[visualEffectView setBackgroundColor:currentBundleMenuColor];
		[visualEffectView setAlpha:[magicValue doubleValue]];
	}
	
	%orig;

}

%end

%hook _UIContextMenuContainerView

- (id)init {

	contextMenuContainerView = self;

	return %orig;

}

- (void)willMoveToWindow:(UIWindow *)newWindow {

	if (!enableBackgroundColoringSwitch) return %orig;
	if (currentBundleBackgroundColor){
		[UIView animateWithDuration:1.0 animations:^{
			[self setBackgroundColor:currentBundleBackgroundColor];
		} completion:nil];	
	}

	%orig;

}

%end


%hook SBIconController

- (id)containerViewForPresentingContextMenuForIconView:(SBIconView *)iconView {

	currentBundleBackgroundColor = nil; // reset current color first, there's no guarantee we will find a new one for current view
	currentBundleMenuColor = nil;
	SBFolder* folder = [iconView folder];
	NSString* bundleIdentifier = nil;

	UIImage* image = nil; // pointer to target image of icon for which we will generate the color

	if (folder && [[folder icons] count] && [[folder icons] objectAtIndex:0])
		bundleIdentifier = [[[folder icons] objectAtIndex:0] applicationBundleID];
	else
		bundleIdentifier = [[iconView icon] applicationBundleID];

	SBIconImageView *iconImageView = [iconView currentImageView];

	if (!image && iconImageView && [iconImageView respondsToSelector:@selector(displayedImage)]) {
		// use the cached image from memory, the fastest way
		image = [iconImageView displayedImage];
	}

	if (!image && bundleIdentifier) {
		// fall back to loading icon using a bundle identifier
		// (this will be used for folders)
		image = [UIImage _applicationIconImageForBundleIdentifier:bundleIdentifier format:2 scale:[UIScreen mainScreen].scale];
	}

	if (!image) {
		// still nothing, we will try to capture the UIView to an image
		// that's a fallback for iOS 14 widgets mainly
		UIGraphicsBeginImageContext(CGSizeMake(iconView.frame.size.width, iconView.frame.size.height));
		// below two lines are interchangeable
    	[iconView drawViewHierarchyInRect:CGRectMake(0, 0, iconView.frame.size.width, iconView.frame.size.height) afterScreenUpdates:YES]; // the resulting images look smoother for eye, but might actually be worse for color calculation
    	//[iconView.layer renderInContext:UIGraphicsGetCurrentContext()]; // the resulting images are more pixelated, but colors are sharper
    	image = UIGraphicsGetImageFromCurrentImageContext();
    	UIGraphicsEndImageContext();
		//UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); // was used for tests
	}

	if (!image) return %orig;

	if (enableBackgroundColoringSwitch) {
		if ([selectedBackgroundColorValue intValue] == 0)
			currentBundleBackgroundColor = [[libKitten backgroundColor:image] colorWithAlphaComponent:[ backgroundAlphaValue doubleValue]];
		else if ([selectedBackgroundColorValue intValue] == 1)
			currentBundleBackgroundColor = [[libKitten primaryColor:image] colorWithAlphaComponent:[ backgroundAlphaValue doubleValue]];
		else if ([selectedBackgroundColorValue intValue] == 2)
			currentBundleBackgroundColor = [[libKitten secondaryColor:image] colorWithAlphaComponent:[ backgroundAlphaValue doubleValue]];
	}

	if (enableMenuColoringSwitch) {
		if ([selectedMenuColorValue intValue] == 0)
			currentBundleMenuColor = [[libKitten backgroundColor:image] colorWithAlphaComponent:[ menuAlphaValue doubleValue]];
		else if ([selectedMenuColorValue intValue] == 1)
			currentBundleMenuColor = [[libKitten primaryColor:image] colorWithAlphaComponent:[ menuAlphaValue doubleValue]];
		else if ([selectedMenuColorValue intValue] == 2)
			currentBundleMenuColor = [[libKitten secondaryColor:image] colorWithAlphaComponent:[ menuAlphaValue doubleValue]];	
	}
	
	return %orig;

}

%end

%hook SBIconView 

- (void)activateShortcut:(id)item withBundleIdentifier:(NSString*)bundleID forIconView:(id)iconView {

	if (contextMenuContainerView) [contextMenuContainerView setBackgroundColor:nil];

	%orig;

}

%end


%hook _UIPreviewPlatterPresentationController

- (void)_handleDismissalTapGesture:(id)arg1 {

	if (contextMenuContainerView) [contextMenuContainerView setBackgroundColor:nil];

	%orig;

}

%end

%hook SBHIconManager

- (void)setEditing:(BOOL)arg1 {

	if (contextMenuContainerView) [contextMenuContainerView setBackgroundColor:nil];

	%orig;

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"0xcc.woodfairy.koipreferences"];
	[preferences registerBool:&enabled default:NO forKey:@"Enabled"];
	if (!enabled) return;

	// Background
	[preferences registerBool:&enableBackgroundColoringSwitch default:YES forKey:@"enableBackgroundColoring"];
	[preferences registerObject:&backgroundAlphaValue default:@"0.25" forKey:@"backgroundAlpha"];
	[preferences registerObject:&selectedBackgroundColorValue default:@"1" forKey:@"selectedBackgroundColor"];

	// Menu
	[preferences registerBool:&enableMenuColoringSwitch default:YES forKey:@"enableMenuColoring"];
	[preferences registerObject:&menuAlphaValue default:@"1.0" forKey:@"menuAlpha"];
	[preferences registerObject:&selectedMenuColorValue default:@"0" forKey:@"selectedMenuColor"];

	[preferences registerObject:&magicValue default:@"0.8" forKey:@"magic"];

	%init(Koi);

}
