#import <UIKit/UIKit.h>
#import "CPAObserver.h"
#import "CPAView.h"
#import "CPAManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SparkAppList.h"
#import <Cephei/HBPreferences.h>

HBPreferences* preferences;

BOOL enabled;

CPAView* cpaView;
CPAObserver* cpaObserver;
UISwipeGestureRecognizer* upSwipe;

// style
BOOL darkMode;

// activation
BOOL useSwipeUpSwitch;
BOOL useDictationKeySwitch;
BOOL useKeyboardInputModeSwitch;

// style
NSInteger styleValue;
BOOL blurryBackgroundSwitch;
BOOL showNamesSwitch;
BOOL showIconsSwitch;
BOOL alwaysShowChevronSwitch;
BOOL hideChevronSwitch;
BOOL useBackgroundImageSwitch;
double backgroundAlphaValue;

// behavior
BOOL dismissAfterPasteSwitch;
BOOL hapticFeedbackSwitch;
CGFloat heightValue;
NSInteger numberOfItemsValue;

@interface UIInputWindowController : UIViewController
@end

@interface UIKeyboardLayoutStar : UIView
@end

@interface UIKBTree : NSObject
@property(nonatomic, retain)NSString* name;
@property(nonatomic, retain)NSMutableDictionary* properties;
@end

@interface UIKeyboardImpl : UIView
+ (id)activeInstance;
- (void)insertText:(NSString *)text;
+ (Class)layoutClassForCurrentInputMode;
@end

@interface UIKeyboardInputMode : NSObject
- (NSString *)identifier;
+ (id)keyboardInputModeWithIdentifier:(id)arg1;
@end