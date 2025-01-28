#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <rootless.h>

#import "../Photos+Private.h"

@interface AlbumManager : NSObject

@property (nonatomic, retain) NSDictionary *settings;
@property (nonatomic, retain) NSDictionary *defaultSettings;
@property (nonatomic, retain) NSMutableArray *unlockedAlbums;
@property (nonatomic, retain) NSMutableArray *unlockedProtections;

+ (instancetype)sharedInstance;
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (void)reloadSettings;
- (void)resetSettings;
- (NSString *)uuidForCollection:(PHAssetCollection *)collection;
- (void)tryAccessingAlbumWithUUID:(NSString *)uuid forViewController:(UIViewController *)viewController WithCompletion:(void (^)(BOOL success))completion;
- (void)authenticateWithBiometricsForViewController:(UIViewController *)viewController WithCompletion:(void (^)(BOOL success))completion;
- (void)authenticateWithPasswordForHash:(NSString *)hash forViewController:(UIViewController *)viewController WithCompletion:(void (^)(BOOL success))completion;
- (NSString*)sha256HashForText:(NSString*)text;
- (void)resetUnlocks;
- (BOOL)collectionListWantsLock:(PHCollectionList*)list;
@end

#define PREFERENCES_PATH           ROOT_PATH_NS_VAR(@"/var/mobile/Library/Preferences/")
#define PLIST_PATH                 ROOT_PATH_NS_VAR(@"/var/mobile/Library/Preferences/com.noisyflake.albummanager.plist")