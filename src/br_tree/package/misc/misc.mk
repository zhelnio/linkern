MISC_MODULE_VERSION = 1.0
MISC_SITE = ../src/module/02_misc
MISC_SITE_METHOD = local
MISC_LICENSE = GPLv2
MISC_LICENSE_FILES = COPYING
MISC_MODULE_MAKE_OPTS = \
        CONFIG_DUMMY1= \
        CONFIG_DUMMY2=y
 
define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' LINUX_DIR='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
endef
 
$(eval $(kernel-module))
$(eval $(generic-package))
