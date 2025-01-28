TARGET := iphone:clang:14.5:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AlbumManagerCCToggle
AlbumManagerCCToggle_BUNDLE_EXTENSION = bundle
AlbumManagerCCToggle_FILES = AlbumManagerCCToggle.m ../src/AlbumManager.m
AlbumManagerCCToggle_CFLAGS = -fobjc-arc
AlbumManagerCCToggle_FRAMEWORKS = UIKit
AlbumManagerCCToggle_PRIVATE_FRAMEWORKS = ControlCenterUIKit
AlbumManagerCCToggle_INSTALL_PATH = $(THEOS_PACKAGE_INSTALL_PREFIX)/Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk
