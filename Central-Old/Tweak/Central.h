#include <UIKit/UIKit.h>

static void *observer = NULL;
static NSDictionary *preferences = nil;

static BOOL doneWaitingForLoad = NO;

static BOOL preferenceTweakEnabled = YES;
static BOOL preferenceChangeFolderLayout = YES;
static BOOL preferenceChangeLibraryLayout = YES;

static CFStringRef const preferencesIdentifier = CFSTR("com.falcon.central.preferences");
static CFStringRef const preferencesSettingsChangedNotification = CFSTR("com.falcon.central.preferences.changed");

static NSString * const preferencesSettingsPath = @"/var/mobile/Library/Preferences/com.falcon.central.preferences.plist";


@interface SBIcon : NSObject
	@property (nonatomic, assign) NSInteger gridSizeClass;
@end

@interface SBIconListGridLayoutConfiguration : NSObject
	@property (assign, nonatomic) UIEdgeInsets portraitLayoutInsets;
	@property (assign, nonatomic) UIEdgeInsets landscapeLayoutInsets;
@end

@interface SBIconListGridLayout
	@property (nonatomic, copy, readonly) SBIconListGridLayoutConfiguration * layoutConfiguration;
@end

@interface SBIconListView : UIView
	@property (nonatomic, retain) NSString *iconLocation;

	@property (nonatomic, assign) NSUInteger firstFreeSlotIndex;
	@property (nonatomic, assign) NSInteger iconsInRowForSpacingCalculation;

	@property (nonatomic, readonly) CGSize alignmentIconSize; 
	@property (nonatomic, readonly) SBIconListGridLayout* layout; 

	@property (nonatomic, assign, getter=isEditing) BOOL editing;

	- (NSArray *) icons;
	- (NSArray *) visibleIcons;

	- (void) layoutIconsNow;
	
	- (double) horizontalIconPadding;
@end

@interface SBRootFolderView : UIView
	- (SBIconListView *) currentIconListView;
@end

@interface SBRootFolderController : UIViewController
	- (SBRootFolderView *) rootFolderView;
@end

@interface SBIconController : UIViewController
	+ (SBIconController *) sharedInstance;

	- (SBRootFolderController *) _rootFolderController;
@end

typedef struct SBIconCoordinate {
	NSInteger row;
	NSInteger col;
} SBIconCoordinate;