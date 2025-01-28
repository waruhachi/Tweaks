#import <ControlCenterUIKit/CCUIToggleModule.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface WindowHUD : CCUIToggleModule {
  BOOL _selected;
}
@end

@interface UIRootSceneWindow : UIView
+(UIRootSceneWindow*)sharedInstance;
@end

@interface FBRootWindow : UIView
+(FBRootWindow*)sharedInstance;
@end
