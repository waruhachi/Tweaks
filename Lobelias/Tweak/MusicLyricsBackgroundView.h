@interface _LSQueryResult : NSObject
@end

@interface LSResourceProxy : _LSQueryResult
@property (nonatomic,readonly) NSDictionary * iconsDictionary;
@end

@interface LSBundleProxy : LSResourceProxy
@property (nonatomic,readonly) NSURL * bundleURL;
@property (nonatomic,readonly) NSString * canonicalExecutablePath;
+(id)bundleProxyForIdentifier:(id)arg1 ;
@end

@interface LSApplicationProxy : LSBundleProxy
@property (nonatomic,readonly) NSString * applicationIdentifier;
+(LSApplicationProxy *)applicationProxyForIdentifier:(id)arg1 ;
@end

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(id)allInstalledApplications;
@end

@interface MPArtworkCatalog : NSObject
+(id)staticArtworkCatalogWithImage:(id)arg1 ;
@end

@interface MusicLyricsBackgroundView : UIView
@property (nonatomic, readwrite, retain) MPArtworkCatalog *backgroundArtworkCatalog;
-(void)setBackgroundArtworkCatalog:(MPArtworkCatalog *)arg1 ;
@end