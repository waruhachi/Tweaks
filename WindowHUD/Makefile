TARGET = iphone:clang:11.2:11.2
ARCHS = arm64
ifeq ($(shell uname -s),Darwin)
	ARCHS += arm64e
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WindowHUDHook
WindowHUDHook_FILES = WindowHUDHook.x
WindowHUDHook_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk


BUNDLE_NAME = WindowHUD
WindowHUD_BUNDLE_EXTENSION = bundle
WindowHUD_FILES = WindowHUD.x
WindowHUD_PRIVATE_FRAMEWORKS = ControlCenterUIKit
WindowHUD_INSTALL_PATH = /Library/ControlCenter/Bundles/

after-install::
	install.exec "sbreload"

include $(THEOS_MAKE_PATH)/bundle.mk
