#import "Central.h"

%hook  SBIconListView
	- (CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1 metrics:(id)arg2 {
		doneWaitingForLoad = YES;

		CGPoint original = %orig(arg1, arg2);
		
		if (!preferenceTweakEnabled) return original;
		if (!preferenceChangeFolderLayout && [self.iconLocation containsString:@"Folder"]) return original;
		if (!preferenceChangeLibraryLayout && [self isKindOfClass:%c(SBHLibraryCategoryPodIconListView)]) return original;

		if ([self isEditing]) return original;
		if ([self.iconLocation containsString:@"Dock"]) return original;
		if ([self isKindOfClass:%c(_SBHLibraryPodIconListView)] && ![self isKindOfClass:%c(_SBHLibraryPodCategoryIconListView)]) return original;

		NSInteger totalIcons = 0;
		NSInteger totalWidgetIcons = 0;

		for (UIView *icon in self.icons) {
			if (![icon isKindOfClass:%c(SBWidgetIcon)]) {
				totalIcons = totalIcons + totalWidgetIcons + 1;
				totalWidgetIcons = 0;
			} else {
				SBIcon *widget = (SBIcon *)icon;
				switch (widget.gridSizeClass) {
					case 1:
						totalWidgetIcons += 4;
						break;
					case 2:
						totalWidgetIcons += 8;
						break;
					case 3:
						totalWidgetIcons += 16;
						break;
				}
			}
		}

		NSInteger iconsInFinalRow = totalIcons % self.iconsInRowForSpacingCalculation;

		if (iconsInFinalRow == 0) {
			return original;
		}

		NSInteger startingIndex = totalIcons - iconsInFinalRow;
		NSInteger currentIndex = ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion >= 16) ?
			(arg1.col - 1) * self.iconsInRowForSpacingCalculation + (arg1.row - 1) :
			(arg1.row - 1) * self.iconsInRowForSpacingCalculation + (arg1.col - 1);

		if (currentIndex >= startingIndex) {
			CGFloat iconWidth = self.alignmentIconSize.width;
			CGFloat leftInset = ([UIDevice currentDevice].orientation == 3 || [UIDevice currentDevice].orientation == 5) ? 
				[[[self layout] layoutConfiguration] landscapeLayoutInsets].left : 
				[[[self layout] layoutConfiguration] portraitLayoutInsets].left;

			CGFloat totalWidth = iconsInFinalRow * iconWidth + (iconsInFinalRow - 1) * self.horizontalIconPadding;
			CGFloat centerOffset = (self.bounds.size.width - totalWidth - leftInset * 2) / 2;

			original.x = original.x + (([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) ? -centerOffset : +centerOffset);
		}

		return original;
	}
%end

static void preferencesChanged() {
	CFPreferencesAppSynchronize((CFStringRef)preferencesIdentifier);

	if ([NSHomeDirectory()isEqualToString:@"/var/mobile"]) {
		CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)preferencesIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

		if (keyList) {
			preferences = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)preferencesIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

			if (!preferences) {
				preferences = [NSDictionary new];
			}

			CFRelease(keyList);
		}
	} else {
		preferences = [NSDictionary dictionaryWithContentsOfFile:preferencesSettingsPath];
	}

	preferenceTweakEnabled = [preferences objectForKey:@"tweakEnabled"] ? [[preferences valueForKey:@"tweakEnabled"] boolValue] : YES;
	preferenceChangeFolderLayout = [preferences objectForKey:@"changeFolderLayout"] ? [[preferences valueForKey:@"changeFolderLayout"] boolValue] : YES;
	preferenceChangeLibraryLayout = [preferences objectForKey:@"changeLibraryLayout"] ? [[preferences valueForKey:@"changeLibraryLayout"] boolValue] : YES;

	if (doneWaitingForLoad) {
		[[[[[%c(SBIconController) sharedInstance] _rootFolderController] rootFolderView] currentIconListView] layoutIconsNow];
	}
}

%ctor {
	preferencesChanged();
	
	CFNotificationCenterAddObserver( CFNotificationCenterGetDarwinNotifyCenter(), &observer, (CFNotificationCallback) preferencesChanged, preferencesSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately );
}