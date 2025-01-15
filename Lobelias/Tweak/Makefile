TWEAK_NAME = Lobelias
$(TWEAK_NAME)_FILES = Tweak.x MarqueeLabel.m
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = AudioToolbox
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = MediaRemote
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei
$(TWEAK_NAME)_LIBRARIES = kitten sparkcolourpicker
ADDITIONAL_CFLAGS += -DTHEOS_LEAN_AND_MEAN

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
