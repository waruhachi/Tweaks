#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <ControlCenterUIKit/CCUICAPackageView.h>
#import <ControlCenterUIKit/CCUICAPackageDescription.h>

@interface CCNoiseControlProvider : NSObject {
    NSMutableDictionary* _moduleInstancesByIdentifier;
}
@end
