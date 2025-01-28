#import "../headers/HeadersPreferences.h"
@interface UINavigationItem (Velvet)
@property (assign,nonatomic) UINavigationBar * navigationBar;
@end

@implementation Velvet2PreviewController

- (NSMutableArray*)visibleSpecifiersFromPlist:(NSString*)plist {
	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];

	NSMutableArray *mutableSpecifiers = [[self loadSpecifiersFromPlistName:plist target:self] mutableCopy];

	for (PSSpecifier *specifier in [mutableSpecifiers reverseObjectEnumerator]) {
		NSString *requirement = specifier.properties[@"require"];

		if (requirement) {
			NSArray *requirementList = [requirement componentsSeparatedByString:@"&"];
			for (NSString *singleRequirement in requirementList) {
				if ([singleRequirement containsString:@"="]) {
					NSArray *kv = [singleRequirement componentsSeparatedByString:@"="];
					if (![[manager settingForKey:kv[0] withIdentifier:self.identifier] isEqual:kv[1]]) {
						[mutableSpecifiers removeObject:specifier];
						break;
					} 
				} else {
					NSString *firstChar = [singleRequirement substringToIndex:1];

					if ([firstChar isEqualToString:@"!"]) {
						if ([[manager settingForKey:[singleRequirement substringFromIndex:1] withIdentifier:self.identifier] boolValue]) {
							[mutableSpecifiers removeObject:specifier];
							break;
						}
					} else {
						if (![[manager settingForKey:singleRequirement withIdentifier:self.identifier] boolValue]) {
							[mutableSpecifiers removeObject:specifier];
							break;
						}
					}
					
				}
			}
		}
	}

	return mutableSpecifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	BOOL skipSaving = NO;
	if (self.identifier) {
		NSString *fullKey = [NSString stringWithFormat:@"%@_%@", specifier.properties[@"key"], self.identifier];

		Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];
		NSString *globalValue = [manager settingForKey:specifier.properties[@"key"] withIdentifier:nil];
		
		if ([globalValue isEqual:value]) {
			skipSaving = YES;
			[manager removeObjectForKey:fullKey];
		}

		specifier.properties[@"key"] = fullKey;
	}

	
	if (!skipSaving) {
		[super setPreferenceValue:value specifier:specifier];
	}

	[self.preview updatePreview];

	// This wouldn't usually be necessary, but I don't want to write the update string into every Specifier in the plist
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.noisyflake.velvet2/preferenceUpdate", NULL, NULL, YES);

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
		[self reloadSpecifiers];
	});
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];
	return [manager settingForKey:specifier.properties[@"key"] withIdentifier:self.identifier];
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	if ([self.view.subviews count] > 1) return;

	CGFloat notificationWidth = self.table.subviews[0].frame.size.width;

	CGRect previewFrame = CGRectMake(0, self._contentOverlayInsets.top, self.view.frame.size.width, 93 + 30 + 8);
	self.preview = [[Velvet2PreviewView alloc] initWithFrame:previewFrame notificationWidth:notificationWidth identifier:self.identifier];

	if ([self.navigationController.previousViewController isKindOfClass:NSClassFromString(@"Velvet2SettingsController")]) {
		// Use the same icon that our parent displayed
		[self.preview updateAppIconWithIdentifier:((Velvet2SettingsController *)self.navigationController.previousViewController).preview.currentIconIdentifier];
	}

	[self.view insertSubview:self.preview atIndex:1];

	// Need additional space if we don't have a group label first
	CGFloat additionalHeight = [self specifierAtIndex:0].name ? 0 : 32;

	self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, notificationWidth, 93 + additionalHeight + 16 + 12)];
}

-(BOOL)appSettingForKeyExists:(NSString *)key {
	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];
	return [manager objectForKey:[NSString stringWithFormat:@"%@_%@", key, self.identifier]] != nil;
}
@end