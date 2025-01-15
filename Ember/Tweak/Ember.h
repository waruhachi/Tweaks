#import <Foundation/Foundation.h>

@interface DNDModeAssertionService : NSObject
+ (id)serviceForClientIdentifier:(id)arg1;
- (id)takeModeAssertionWithDetails:(id)arg1 error:(id *)arg2;
- (BOOL)invalidateAllActiveModeAssertionsWithError:(id *)arg1;
@end

@interface DNDModeAssertionDetails : NSObject
+ (id)userRequestedAssertionDetailsWithIdentifier:(id)arg1 modeIdentifier:(id)arg2 lifetime:(id)arg3;
@end