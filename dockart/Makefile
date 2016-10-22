ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = DockArt
DockArt_FILES = DockArt.mm
DockArt_INSTALL_PATH = /Library/PreferenceBundles
DockArt_FRAMEWORKS = Foundation UIKit CoreGraphics MobileCoreServices
DockArt_PRIVATE_FRAMEWORKS = Preferences
DockArt_LDFLAGS += -Wl,-segalign,4000
DockArt_CFLAGS = -Wno-error

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DockArt.plist$(ECHO_END)
