#import "Playlist.h"

SBApplication* nowPlayingApp = nil;
NSString* lastSongTitle = nil;

// notification
static BBServer* bbServer = nil;

static dispatch_queue_t getBBServerQueue() {

    static dispatch_queue_t queue;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
    void* handle = dlopen(NULL, RTLD_GLOBAL);
        if (handle) {
            dispatch_queue_t __weak *pointer = (__weak dispatch_queue_t *) dlsym(handle, "__BBServerQueue");
            if (pointer) queue = *pointer;
            dlclose(handle);
        }
    });

    return queue;

}

static void fakeNotification(NSString *sectionID, NSDate *date, NSString *message, bool banner) {
    
	BBBulletin* bulletin = [[%c(BBBulletin) alloc] init];

	bulletin.title = @"Now Playing";
    bulletin.message = message;
    bulletin.sectionID = sectionID;
    bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.publisherBulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
    bulletin.date = date;
    bulletin.defaultAction = [%c(BBAction) actionWithLaunchBundleID:sectionID callblock:nil];
    bulletin.clearable = YES;
    bulletin.showsMessagePreview = YES;
    bulletin.publicationDate = date;
    bulletin.lastInterruptDate = date;

    if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:)]) {
        dispatch_sync(getBBServerQueue(), ^{
            [bbServer publishBulletin:bulletin destinations:15];
        });
    }

}

%group Playlist

%hook SBMediaController

- (void)_setNowPlayingApplication:(id)arg1 { // get the current playing app

	%orig;

	nowPlayingApp = arg1;

}

- (void)setNowPlayingInfo:(id)arg1 { // post notification with the corresponding bundle identifier, title & artist name

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) { // post notification
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;
            if (dict) {
                if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] && dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]) {
					if (![lastSongTitle isEqualToString:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle]])
						fakeNotification([NSString stringWithFormat:@"%@", [nowPlayingApp bundleIdentifier]], [NSDate date], [NSString stringWithFormat:@"%@ By %@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle], [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist]], true);
					
					lastSongTitle = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle];
				}
            }
        }
  	});

}

%end

%hook BBServer

- (id)initWithQueue:(id)arg1 {

    bbServer = %orig;
    
    return bbServer;

}

- (id)initWithQueue:(id)arg1 dataProviderManager:(id)arg2 syncService:(id)arg3 dismissalSyncCache:(id)arg4 observerListener:(id)arg5 utilitiesListener:(id)arg6 conduitListener:(id)arg7 systemStateListener:(id)arg8 settingsListener:(id)arg9 {
    
    bbServer = %orig;

    return bbServer;

}

- (void)dealloc {

    if (bbServer == self) bbServer = nil;

    %orig;

}

%end

%end

%ctor {

	%init(Playlist);

}