#import <Foundation/Foundation.h>

// hooks below are little 12's code put into a single little tweak

%group AppareilPhoto

%hook CAMCaptureCapabilities

- (BOOL)isCTMSupported {

    return YES;

}

%end

%hook CAMViewfinderViewController

- (BOOL)_wantsHDRControlsVisible {

    return NO;

}

%end

%hook CAMViewfinderViewController

- (BOOL)_shouldUseZoomControlInsteadOfSlider {

    return YES;

}

%end

%end

%ctor {

	%init(AppareilPhoto);

}