HELLO_MODULE_VERSION = 1.0
HELLO_SITE = ../src/module/00_hello
HELLO_SITE_METHOD = local
HELLO_LICENSE = GPLv2
HELLO_LICENSE_FILES = COPYING
HELLO_MODULE_MAKE_OPTS = \
        CONFIG_DUMMY1= \
        CONFIG_DUMMY2=y
 
define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' LINUX_DIR='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
endef
 
$(eval $(kernel-module))
$(eval $(generic-package))
