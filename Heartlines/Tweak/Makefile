TWEAK_NAME := Heartlines

$(TWEAK_NAME)_FILES := $(TWEAK_NAME).x HLSLocalization.m $(wildcard ../Vendor/**/*.m)
$(TWEAK_NAME)_CFLAGS := -fobjc-arc -DTHEOS_LEAN_AND_MEAN
$(TWEAK_NAME)_FRAMEWORKS := EventKit
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS := AppSupport MediaRemote
$(TWEAK_NAME)_EXTRA_FRAMEWORKS := Cephei
$(TWEAK_NAME)_LIBRARIES := gcuniversal


include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk