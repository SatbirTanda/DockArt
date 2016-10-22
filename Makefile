ARCHS = armv7 armv7s arm64
GO_EASY_ON_ME = 1

include theos/makefiles/common.mk

TWEAK_NAME = DockArt
DockArt_FILES = Tweak.xm
DockArt_FRAMEWORKS = UIKit
DockArt_LDFLAGS += -Wl,-segalign,4000
DockArt_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += dockart
include $(THEOS_MAKE_PATH)/aggregate.mk
