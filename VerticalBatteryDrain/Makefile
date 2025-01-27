TARGET := iphone:16.5:14.0
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VerticalBatteryDrain

VerticalBatteryDrain_FILES = $(shell find Sources/VerticalBatteryDrain -name '*.swift') $(shell find Sources/VerticalBatteryDrainC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
VerticalBatteryDrain_SWIFTFLAGS = -ISources/VerticalBatteryDrainC/include
VerticalBatteryDrain_CFLAGS = -fobjc-arc -ISources/VerticalBatteryDrainC/include

include $(THEOS_MAKE_PATH)/tweak.mk
