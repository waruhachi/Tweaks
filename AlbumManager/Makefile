TARGET := iphone:clang:14.5:15.0
INSTALL_TARGET_PROCESSES = SpringBoard MobileSlideShow

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AlbumManager

AlbumManager_FILES = src/Tweak.x src/AlbumManager.m
AlbumManager_LIBRARIES = sandy
AlbumManager_CFLAGS = -fobjc-arc -Wno-deprecated

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += preferences
SUBPROJECTS += cctoggle
include $(THEOS_MAKE_PATH)/aggregate.mk
