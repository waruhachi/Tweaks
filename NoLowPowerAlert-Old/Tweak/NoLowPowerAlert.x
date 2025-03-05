#import <Foundation/Foundation.h>

%group NoLowPowerAlert

%hook SBLowPowerAlertItem

+ (void)initialize {

	return;

}

%end

%end

%ctor {

	%init(NoLowPowerAlert);

}