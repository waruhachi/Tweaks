ifeq ($(SIMULATOR),1)
ARCHS = x86_64
TARGET = simulator:clang:latest:7.0
else
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.0:13.0
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EasyAirplaneDisabler
$(TWEAK_NAME)_FILES = Tweak.xm $(wildcard *.m)
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-all::
	/Applications/OSDisplay.app/Contents/MacOS/OSDisplay -m 'Build success' -i 'tick' -d '1'