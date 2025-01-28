TARGET := iphone:clang:14.5:15.0
INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AlbumManager

AlbumManager_FILES = $(wildcard AlbumManagerRootListController.m CustomCells/*.m ../src/AlbumManager.m)
AlbumManager_PRIVATE_FRAMEWORKS = Preferences
AlbumManager_INSTALL_PATH = $(THEOS_PACKAGE_INSTALL_PREFIX)/Library/PreferenceBundles
AlbumManager_CFLAGS = -fobjc-arc -DPACKAGE_VERSION='@"$(THEOS_PACKAGE_BASE_VERSION)"'

include $(THEOS_MAKE_PATH)/bundle.mk