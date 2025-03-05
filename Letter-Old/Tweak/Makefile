TWEAK_NAME = Letter
$(TWEAK_NAME)_FILES = $(TWEAK_NAME).x $(wildcard ../Vendor/**/*.m)
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
$(TWEAK_NAME)_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
