
#import <UIKit/UIKit.h>
#import <AltList/LSApplicationProxy+AltList.h>
#include <dlfcn.h>
#include <objc/runtime.h>
// #import <MobileCoreServices/LSApplicationWorkspace.h> ios 12 uses MobileCoreServices
#import <MobileCoreServices/LSApplicationWorkspace.h> //ios 15 uses CoreServices in public frameworks
#import <LocalAuthentication/LocalAuthentication.h>
#import "AuthenticationManager.h"

@interface SBHApplicationIcon
@property(readonly, copy, nonatomic) NSString *applicationBundleID;
@end

@interface UIApplication (private)
-(void)launchApplicationWithIdentifier:(NSString *)arg1 suspended:(BOOL)arg2;
@end

@interface SBIconView: UIView
@property(readonly, copy, nonatomic) NSString *applicationBundleIdentifierForShortcuts;
- (NSString *)applicationBundleIdentifier;
- (NSString *)applicationBundleIdentifierForShortcuts;
@end

@interface SBUIController : NSObject 
@end

@interface SBHomeScreenViewController: UIViewController
-(void)showAlertControllerPasswordChecker:(void(^)(NSString *alertViewText))completion;
@end

@interface SBWorkspaceTransitionRequest :NSObject
    @property (nonatomic,copy) NSString * eventLabel;
    -(NSSet *)toApplicationSceneEntities;
@end

@interface SBWorkspaceTransaction : NSObject
    @property (nonatomic,readonly) SBWorkspaceTransitionRequest * transitionRequest;
    -(BOOL)isComplete;
@end

@interface SBToAppsWorkspaceTransaction
    @property (nonatomic,readonly) NSSet * toApplicationSceneEntities;
    -(void)activateApplications;
@end

@interface SBCoverSheetToAppsWorkspaceTransaction : SBToAppsWorkspaceTransaction
@end

@interface FBProcess
    @property (nonatomic, readonly, copy) NSString *name;
    - (bool)executableLivesOnSystemPartition;
@end

@interface FBSystemServiceOpenApplicationRequest
    @property (nonatomic, copy) NSString *bundleIdentifier;
    - (FBProcess *)clientProcess;
@end

@interface SBApplication
    @property (nonatomic,readonly) NSString * bundleIdentifier;
    @property (nonatomic, readonly) NSString *displayName;
    -(BOOL)icon:(id)arg1 launchFromLocation:(id)arg2 context:(id)arg3 ;
@end

@interface SBApplicationSceneEntity
    -(SBApplication *)application;
@end

@interface SBSApplicationShortcutIcon : NSObject
@end

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
    - (id)initWithImageData:(id)arg1 dataType:(long long)arg2 isTemplate:(bool)arg3;
@end

@interface SBSApplicationShortcutItem : NSObject
    @property (nonatomic,copy) NSString *type;
    @property (nonatomic,copy) NSString *localizedTitle;
    @property (nonatomic,copy) NSString *localizedSubtitle;
    @property (nonatomic,copy) SBSApplicationShortcutIcon *icon;
    @property (nonatomic,copy) NSDictionary *userInfo; 
    @property (assign,nonatomic) NSUInteger activationMode;
    @property (nonatomic,copy) NSString *bundleIdentifierToLaunch;
@end

@interface SpringBoard
    +(instancetype)sharedApplication;
    -(SBApplication *)_accessibilityFrontMostApplication;
    -(void)_simulateHomeButtonPressWithCompletion:(id)arg1;
@end
