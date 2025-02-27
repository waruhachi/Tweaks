#import "CCNoiseControl.h"

@interface BluetoothDevice : NSObject
    - (unsigned)listeningMode;
    - (BOOL)setListeningMode:(unsigned)arg1;
@end

@interface BluetoothManager : NSObject
    + (id)sharedInstance;
    - (id)connectedDevices;
@end

@implementation CCNoiseControl

- (instancetype)init {
    self = [super init];

    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listeningModeUpdated:) name:@"BluetoothAccessorySettingsChanged" object:nil];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)listeningModeUpdated:(id)arg1 {
    [super refreshState];
}

- (NSString*)glyphState {
    return _selected ? @"on" : @"off";
}

- (CCUICAPackageDescription *)glyphPackageDescription {
    NSBundle* bundle=[NSBundle bundleForClass:[self class]];
    CCUICAPackageDescription*description=[objc_getClass("CCUICAPackageDescription") descriptionForPackageNamed:@"CCNoiseControl" inBundle:bundle];
    return description;
}

/**
 * 1 AVOutputDeviceBluetoothListeningModeNormal
 * 2 AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation
 * 3 AVOutputDeviceBluetoothListeningModeAudioTransparency
 */
- (BOOL)isSelected {
    NSArray*connectedDevices=[[objc_getClass("BluetoothManager") sharedInstance] connectedDevices];

    if(![connectedDevices count]) {
        return (_selected = NO);
    }

    _selected = ([connectedDevices[0] listeningMode] == 2);
    return _selected;
}

- (void)setSelected:(BOOL)selected {
    NSArray*connectedDevices=[[objc_getClass("BluetoothManager") sharedInstance] connectedDevices];

    if(![connectedDevices count]) {
        return;
    }

    unsigned listeningMode=selected ? 2 : 3;
    BOOL success=[connectedDevices[0] setListeningMode:listeningMode];

    if(!success) {
        return;
    }

	_selected = selected;

    [super refreshState];
}

@end
