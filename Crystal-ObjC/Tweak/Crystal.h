//
//  Crystal.h
//  Crystal
//
//  Created by Alexandra Aurora Göttlicher
//

#import <UIKit/UIKit.h>

NSUserDefaults* preferences;
BOOL pfEnabled;
CGFloat pfVolumeThreshold;
NSString* pfBelowThresholdMode;
NSString* pfAboveThresholdMode;

@interface SBVolumeControl : NSObject
- (float)_effectiveVolume;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
@end

@interface AVOutputDevice : NSObject
- (void)setCurrentBluetoothListeningMode:(NSString *)listeningMode;
@end

@interface MRAVOutputDevice : NSObject
@end

@interface MRAVConcreteOutputDevice : MRAVOutputDevice
@end

@interface MPAVRoute : NSObject
- (MRAVConcreteOutputDevice *)logicalLeaderOutputDevice;
@end

@interface MPAVRoutingController : NSObject
@property(nonatomic, readonly)MPAVRoute* pickedRoute;
@end

void setListeningMode(NSString* mode);
