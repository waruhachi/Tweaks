export THEOS_DEVICE_IP=192.168.3.46

# export FINALPACKAGE=1
# USB=1

#Rootful (uncomment following lines)
PREFIX="/Users/antho/Documents/Programmation/iOSTweaks/Xcode11Toolchain/XcodeDefault.xctoolchain/usr/bin/"

#Rootless (uncomment following lines)
# export THEOS_PACKAGE_SCHEME=rootless


ifeq ($(USB),1)
	export THEOS_DEVICE_IP=localhost
	export THEOS_DEVICE_PORT=2222
endif

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += Tweak

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
ifeq ($(RESPRING),1)
	install.exec "killall -9 backboardd"
endif
	/Applications/OSDisplay.app/Contents/MacOS/OSDisplay -m 'Install success' -i 'tick' -d '1'