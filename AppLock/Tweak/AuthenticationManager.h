#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface AuthenticationManager : NSObject
    + (id)sharedInstance;
    -(void)authenticateWithMsg:(NSString*)message withCompletion:(void(^)(BOOL isAuthenticated, NSError *authenticationError))completion;
@end