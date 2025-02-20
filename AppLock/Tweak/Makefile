TWEAK_NAME = AppLock

$(TWEAK_NAME)_FILES = $(TWEAK_NAME).x AuthenticationManager.m
$(TWEAK_NAME)_FRAMEWORKS = UIKit LocalAuthentication
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = Preferences MobileCoreServices
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
