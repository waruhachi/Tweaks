#import <Foundation/Foundation.h>

%group ProudLock

%hook SBFUserAuthenticationController

- (BOOL)hasPasscodeSet {

	return YES;

}

%end

%end

%ctor {

	%init(ProudLock);

}