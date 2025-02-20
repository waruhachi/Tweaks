#import "AuthenticationManager.h" 

@implementation AuthenticationManager

    + (id)sharedInstance {
        static AuthenticationManager *sharedInstance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] init];
        });
        return sharedInstance;
    }

    -(void)authenticateWithMsg:(NSString*)message withCompletion:(void(^)(BOOL isAuthenticated, NSError *authenticationError))completion {

        LAContext *laContext = [[LAContext alloc]init];
        NSError *evaluatePolicyError;

        BOOL isBiometricsAvailable = [laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&evaluatePolicyError];
        if (isBiometricsAvailable) {
            [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics 
                    localizedReason:message 
                    reply:^(BOOL success, NSError *error) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        completion(success, error);
                    });
            }];
        } else {
            UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
            NSString *alertTitle = @"Error";
            NSString *alertMessage = @"No biometrics detected, please enabled FaceID or TouchID in settings";
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertTitle
                                        message:alertMessage
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action) 
                {
                    
                }];
            
            

            [alert addAction:defaultAction];
            [rootVC presentViewController:alert animated:YES completion:nil];
        }
    }

@end