#import <UIKit/UIKit.h>
#import<Cephei/HBPreferences.h>

@interface CPAObserver : NSObject
@property(nonatomic, retain)NSString* lastContent;
@property(nonatomic, retain)HBPreferences* preferences;
- (id)init;
- (void)pasteboardUpdated;
@end

BOOL enableRegex;
NSString* regexExpression;
NSInteger regexType;