#import "../headers/AlbumManager/Preferences.h"

@implementation AlbumManagerRootListController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    AlbumManager *manager = [NSClassFromString(@"AlbumManager") sharedInstance];
    return [manager objectForKey:specifier.properties[@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *key = specifier.properties[@"key"];

    AlbumManager *manager = [NSClassFromString(@"AlbumManager") sharedInstance];
    [manager setObject:value forKey:key];


	if ([key isEqualToString:@"rememberUnlock"] && ![value boolValue]) {
		// For whatever reason, we need to manually reload the settings here.
		// Probably because it's not fast enough via notifications, and we would otherwise access the old settings object instead
		[manager reloadSettings];
		[manager setObject:@(NO) forKey:@"unlockSameAuth"];
		[manager reloadSettings];
		[self reloadSpecifiers];
	}

	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.noisyflake.albummanager.preferenceupdate", NULL, NULL, YES);

	if ([key isEqualToString:@"showLockedAlbums"]) {
		[self killPhotosApp];
	}
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

    self.navigationItem.navigationBar.tintColor = kAlbumManagerColor;

	[self setupHeader];
	[self setupFooterVersion];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	self.navigationItem.navigationBar.tintColor = nil;
}

-(void)setupHeader {
	UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 122)];

	UILabel *tweakName = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 40)];
	[tweakName layoutIfNeeded];
	tweakName.numberOfLines = 1;
	tweakName.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	tweakName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:34.0f];
	tweakName.textColor = kAlbumManagerColor;
	tweakName.textAlignment = NSTextAlignmentCenter;

	NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"AlbumManager"];
	[attrString beginEditing];
	[attrString addAttribute:NSFontAttributeName
				value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:34.0f]
				range:NSMakeRange(0, 5)];

	[attrString endEditing];
	tweakName.attributedText = attrString;

	UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 15)];
	subtitle.numberOfLines = 1;
	subtitle.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	subtitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
	subtitle.textColor = UIColor.systemGrayColor;
	subtitle.textAlignment = NSTextAlignmentCenter;
	subtitle.text = [NSString stringWithFormat:@"Organize. Hide. Protect."];

	[header addSubview:tweakName];
	[header addSubview:subtitle];

	self.table.tableHeaderView = header;
}

-(void)setupFooterVersion {
	NSString *firstLine = [NSString stringWithFormat:@"AlbumManager %@", PACKAGE_VERSION];

	NSMutableAttributedString *fullFooter =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\nwith \u2665 by NoisyFlake", firstLine]];

	[fullFooter beginEditing];
	[fullFooter addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, [firstLine length])];
	[fullFooter endEditing];
	
	UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
	footerLabel.font = [UIFont systemFontOfSize:13];
	footerLabel.textColor = UIColor.systemGrayColor;
	footerLabel.numberOfLines = 2;
	footerLabel.attributedText = fullFooter;
	footerLabel.textAlignment = NSTextAlignmentCenter;
	self.table.tableFooterView = footerLabel;
}

-(void)resetSettings {
	AlbumManager *manager = [NSClassFromString(@"AlbumManager") sharedInstance];
	[manager resetSettings];
	[self killPhotosApp];

	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.noisyflake.albummanager.preferenceupdate", NULL, NULL, YES);
	[self reload];
}

-(void)twitter {
	NSURL *twitter = [NSURL URLWithString:@"twitter://user?screen_name=NoisyFlake"];
	NSURL *web = [NSURL URLWithString:@"http://www.twitter.com/NoisyFlake"];
	
	if ([[UIApplication sharedApplication] canOpenURL:twitter]) {
        [[UIApplication sharedApplication] openURL:twitter options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:web options:@{} completionHandler:nil];
    }
}

-(void)paypal {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.paypal.me/NoisyFlake"] options:@{} completionHandler:nil];
}

-(void)setTweakEnabled:(id)value specifier:(PSSpecifier *)specifier {
	[self setPreferenceValue:value specifier:specifier];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
}

-(void)respring {
	NSURL *relaunchURL = [NSURL URLWithString:@"prefs:root=AlbumManager"];
	SBSRelaunchAction *restartAction = [NSClassFromString(@"SBSRelaunchAction") actionWithReason:@"RestartRenderServer" options:SBSRelaunchActionOptionsFadeToBlackTransition targetURL:relaunchURL];
	[[NSClassFromString(@"FBSSystemService") sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
}

-(void)killPhotosApp {
	pid_t pid;
	int status;
	const char* args[] = {"killall", "-9", "MobileSlideShow", NULL};
	posix_spawn(&pid, ROOT_PATH("/usr/bin/killall"), NULL, NULL, (char* const*)args, NULL);
	waitpid(pid, &status, WEXITED);
}
@end