#import "Tweak.h"

@implementation AlbumManager

+ (instancetype)sharedInstance {
    static AlbumManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        NSFileManager *manager = [NSFileManager defaultManager];
        if(![manager fileExistsAtPath:PREFERENCES_PATH isDirectory:nil]) {
            if(![manager createDirectoryAtPath:PREFERENCES_PATH withIntermediateDirectories:YES attributes:nil error:nil]) {
                NSLog(@"ERROR: Unable to create preferences folder");
                return nil;
            }
        }

        if(![manager fileExistsAtPath:PLIST_PATH isDirectory:nil]) {
            if (![manager createFileAtPath:PLIST_PATH contents:nil attributes:nil]) {
                NSLog(@"ERROR: Unable to create preferences file");
                return nil;
            }

            [[NSDictionary new] writeToURL:[NSURL fileURLWithPath:PLIST_PATH] error:nil];
        }

        _settings = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:PLIST_PATH] error:nil];
        _unlockedAlbums = [NSMutableArray new];
        _unlockedProtections = [NSMutableArray new];

        _defaultSettings = [NSDictionary dictionaryWithObjectsAndKeys:
            @YES, @"enabled",
            @YES, @"rememberUnlock",
            @YES, @"unlockSameAuth",
            @YES, @"showLockedAlbums",
        nil];

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadAlbumManagerSettings, CFSTR("com.noisyflake.albummanager.preferenceupdate"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    }

    return self;
}

static void reloadAlbumManagerSettings() {
    AlbumManager *manager = [NSClassFromString(@"AlbumManager") sharedInstance];
    [manager reloadSettings];
}

- (id)objectForKey:(NSString *)key {
    return [_settings objectForKey:key] ?: [_defaultSettings objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    NSMutableDictionary *settings = [_settings mutableCopy];

    [settings setObject:object forKey:key];
    [settings writeToURL:[NSURL fileURLWithPath:PLIST_PATH] error:nil];

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.noisyflake.albummanager.preferenceupdate", NULL, NULL, YES);
}

-(void)removeObjectForKey:(NSString *)key {
    NSMutableDictionary *settings = [_settings mutableCopy];

    [settings removeObjectForKey:key];
    [settings writeToURL:[NSURL fileURLWithPath:PLIST_PATH] error:nil];

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.noisyflake.albummanager.preferenceupdate", NULL, NULL, YES);
}

-(void)reloadSettings {
    _settings = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:PLIST_PATH] error:nil];
}

-(void)resetSettings {
    _settings = [NSDictionary new];
    [_settings writeToURL:[NSURL fileURLWithPath:PLIST_PATH] error:nil];
}

- (NSString *)uuidForCollection:(PHAssetCollection *)collection {
    return collection.localIdentifier;
}

- (void)tryAccessingAlbumWithUUID:(NSString *)uuid forViewController:(UIViewController *)viewController WithCompletion:(void (^)(BOOL success))completion {
    NSString *protection = [self objectForKey:uuid];

    if (protection == nil ||
        ([[self objectForKey:@"rememberUnlock"] boolValue] && [_unlockedAlbums containsObject:uuid]) ||
        ([[self objectForKey:@"unlockSameAuth"] boolValue] && [_unlockedProtections containsObject:protection])) {
        completion(YES);
        return;
    }

	if ([protection isEqualToString:@"biometrics"]) {
		[self authenticateWithBiometricsForViewController:viewController WithCompletion:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
				if (success) {
                    [_unlockedAlbums addObject:uuid];
                    [_unlockedProtections addObject:protection];
                    completion(YES);
                    return;
                }
			});
		}];
	} else {
		[self authenticateWithPasswordForHash:protection forViewController:viewController WithCompletion:^(BOOL success) {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (success) {
                    [_unlockedAlbums addObject:uuid];
                    [_unlockedProtections addObject:protection];
                    completion(YES);
                    return;
                }
			});
		}];
	}

    completion(NO);
}

- (void)authenticateWithBiometricsForViewController:(UIViewController *)viewController WithCompletion:(void (^)(BOOL success))completion {
    LAContext *context = [[LAContext alloc] init];
    NSError *authError = nil;

    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"View album" reply:^(BOOL success, NSError *error) {
            completion(success);
        }];
    } else {
        NSString *biometryType = context.biometryType == LABiometryTypeFaceID ? @"Face ID" : @"Touch ID";

        UIAlertController *authFailed = [UIAlertController alertControllerWithTitle:@"No authentication method" message:[NSString stringWithFormat:@"%@ is currently unavailable", biometryType] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [authFailed addAction:ok];

        [viewController presentViewController:authFailed animated:YES completion:nil];
        completion(NO);
    }
}

- (void)authenticateWithPasswordForHash:(NSString *)hash forViewController:(UIViewController *)viewController WithCompletion:(void (^)(BOOL success))completion {
    NSString *requestedKeyboard = [hash substringToIndex:1];
    NSString *title = [requestedKeyboard isEqualToString:@"c"] ? @"Album Passcode?" : @"Album Password?";

    UIAlertController *passwordVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    hash = [hash substringFromIndex:1]; // Remove keyboard indicator from hash

    [passwordVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.spellCheckingType = UITextSpellCheckingTypeNo;
        textField.keyboardType = [requestedKeyboard isEqualToString:@"c"] ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    }];

    UIAlertAction *checkPassword = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *enteredPassword = [passwordVC.textFields[0] text];
        if (enteredPassword.length <= 0) return;

        NSString *passwordHash = [self sha256HashForText:enteredPassword];
        if ([passwordHash isEqualToString:hash]) {
            completion(YES);
        } else {
            passwordVC.textFields[0].text = @"";
            [viewController presentViewController:passwordVC animated:YES completion:nil];
        }
        
    }];
    UIAlertAction *cancelPassword = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
    [passwordVC addAction:checkPassword];
    [passwordVC addAction:cancelPassword];

    
    [viewController presentViewController:passwordVC animated:YES completion:nil];
}

-(NSString*)sha256HashForText:(NSString*)text {
    const char* utf8chars = [text UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(utf8chars, (CC_LONG)strlen(utf8chars), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (void)resetUnlocks {
    _unlockedAlbums = [NSMutableArray new];
    _unlockedProtections = [NSMutableArray new];
}

- (BOOL)collectionListWantsLock:(PHCollectionList*)list {
    BOOL wantsLock = NO;

    PHFetchResult *result = [PHCollection fetchCollectionsInCollectionList:list options:nil];

    for (PHCollection *subCollection in result) {
        if ([subCollection isKindOfClass:NSClassFromString(@"PHCollectionList")]) {
            if ([self collectionListWantsLock:(PHCollectionList *)subCollection]) {
                wantsLock = YES;
                break;
            }
        }

        NSString *subUUID = [self uuidForCollection:(PHAssetCollection *)subCollection];
        NSString *subProtection = [self objectForKey:subUUID];
        if (subProtection != nil && 
            (![[self objectForKey:@"rememberUnlock"] boolValue] || ![self.unlockedAlbums containsObject:subUUID]) &&
            (![[self objectForKey:@"unlockSameAuth"] boolValue] || ![self.unlockedProtections containsObject:subProtection])) {
            wantsLock = YES;
            break;
        }
    }

    return wantsLock;
}
@end