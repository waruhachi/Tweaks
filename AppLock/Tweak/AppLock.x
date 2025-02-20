#import "AppLock.h"

#define kTWEAK_PREF_PATH @"/var/jb/var/mobile/Library/Preferences/com.p2kdev.applock.plist"
const char *kSpringBoardServiceLib = "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices";

void (*g_ptrSBSSuspendFrontmostApplication)();

NSMutableArray *protectedApps;
NSMutableArray *authenticatedApps;

void initSpringService(void) {
   void *sbServices = dlopen(kSpringBoardServiceLib, RTLD_LAZY);
   if (!sbServices) {
      /* fail to load the library */
      NSLog(@">>>> [daemonn] dlopen error: %s", dlerror());
      return;
   }
   g_ptrSBSSuspendFrontmostApplication = (void(*)())dlsym(sbServices, "SBSSuspendFrontmostApplication");
}

//bundle IDs of switches enabled to lock apps
void refreshProtectedApps() {
   NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:kTWEAK_PREF_PATH];
   if (prefs)
      protectedApps = [[prefs objectForKey:@"protectedApps"] mutableCopy];
   else
      protectedApps = [NSMutableArray new];
}

void updatedProtectedAppsForBundleID(NSString *bundleID) {
   NSMutableDictionary *prefs = [NSMutableDictionary new];

   if ([protectedApps containsObject:bundleID])
      [protectedApps removeObject:bundleID];
   else
      [protectedApps addObject:bundleID];

   [prefs setObject:protectedApps forKey:@"protectedApps"];

   [prefs writeToFile:kTWEAK_PREF_PATH atomically:YES];
}

%hook SBIconView

   - (NSArray *)applicationShortcutItems
   {
      NSArray *orig = %orig;

      NSString *applicationID;
      if ([self respondsToSelector:@selector(applicationBundleIdentifier)]) {
         applicationID = [self applicationBundleIdentifier];
      }
      else if ([self respondsToSelector:@selector(applicationBundleIdentifierForShortcuts)]) {
         applicationID = [self applicationBundleIdentifierForShortcuts];
      }

      if (!applicationID) {
         return orig;
      }

      BOOL isProtectionEnabled = [protectedApps containsObject:applicationID];

      SBSApplicationShortcutItem *appLockItem = [[%c(SBSApplicationShortcutItem) alloc] init];
      NSString *imageName;

      if (isProtectionEnabled) {
         appLockItem.localizedTitle = @"Don't Require Face ID";
         imageName = @"lock.open";
      }
      else {
         appLockItem.localizedTitle = @"Require Face ID";
         imageName = @"lock";
      }

      appLockItem.icon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImageData:UIImagePNGRepresentation([UIImage systemImageNamed:imageName]) dataType:0 isTemplate:1];

      appLockItem.bundleIdentifierToLaunch = nil;
      appLockItem.type = @"com.p2kdev.applock.toggleProtection";

      return [orig arrayByAddingObject:appLockItem];
   }

   + (void)activateShortcut:(SBSApplicationShortcutItem *)item withBundleIdentifier:(NSString *)bundleID forIconView:(id)iconView
   {
      if ([[item type] isEqualToString:@"com.p2kdev.applock.toggleProtection"]) {

         if ([protectedApps containsObject:bundleID]) {
            [[%c(AuthenticationManager) sharedInstance] authenticateWithMsg:@"Face ID Required to Remove Protection" withCompletion:^(BOOL isAuthenticated, NSError *authenticationError) {
               @try {
                  if(isAuthenticated)
                     updatedProtectedAppsForBundleID(bundleID);
               } @catch(NSException *e) {}
            }];
         }
         else
            updatedProtectedAppsForBundleID(bundleID);

         return;
      }

      %orig;
   }

%end

//Springboard
%hook SBMainWorkspace

   - (void)setCurrentTransaction:(SBWorkspaceTransaction *)trans {
      NSLog(@"KPD %@",trans);

      if (!trans)
         return %orig;

      // if([[[trans transitionRequest] eventLabel] isEqualToString:@"ActivateSwitcherNoninteractive"])
      //    return %orig;

      if ([trans isKindOfClass:objc_getClass("SBAppToAppWorkspaceTransaction")]) {
         NSArray *activatingApplications = [[[trans transitionRequest] toApplicationSceneEntities] allObjects];
         if (activatingApplications.count == 0)
            return %orig;

         SBApplication *app = [(SBApplicationSceneEntity*)activatingApplications[0] application];
         NSString *bundle = [app bundleIdentifier];
         NSString *name = [app displayName];

         BOOL isApplicationLocked = [protectedApps containsObject:bundle];

         if (!isApplicationLocked || [authenticatedApps containsObject:bundle])
            return %orig;

         [[%c(AuthenticationManager) sharedInstance] authenticateWithMsg:[NSString stringWithFormat:@"Face ID Required to open %@",name] withCompletion:^(BOOL isAuthenticated, NSError *authenticationError) {
            @try {
               if(isAuthenticated) {
                  [authenticatedApps addObject:bundle];
                  %orig;
               }
            } @catch(NSException *e) {}
         }];
      }
      else
         %orig;
   }
%end

%hook SBLockScreenManager
   -(void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 {
      %orig;
      [authenticatedApps removeAllObjects];
   }

   -(BOOL)unlockUIFromSource:(int)arg1 withOptions:(id)arg2 {
      BOOL orig = %orig;

	   SBApplication *app = [[objc_getClass("SpringBoard") sharedApplication] _accessibilityFrontMostApplication];
	   NSString *bundle = [app bundleIdentifier];

      if ([protectedApps containsObject:bundle]) {
         if (!g_ptrSBSSuspendFrontmostApplication)
            initSpringService();

         if (g_ptrSBSSuspendFrontmostApplication) {
            g_ptrSBSSuspendFrontmostApplication();
         }
      }
      return orig;
   }
%end

%hook SBApplication

   -(void)_didExitWithContext:(id)arg1 {
      if ([authenticatedApps containsObject:self.bundleIdentifier])
         [authenticatedApps removeObject:self.bundleIdentifier];

      %orig;
   }

%end

%ctor {
   authenticatedApps = [NSMutableArray new];
   refreshProtectedApps();
}
