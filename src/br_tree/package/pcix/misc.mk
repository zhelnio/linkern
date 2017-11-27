PCIX_MODULE_VERSION = 1.0
PCIX_SITE = ../src/module/03_pcix
PCIX_SITE_METHOD = local
PCIX_LICENSE = GPLv2
PCIX_LICENSE_FILES = COPYING
PCIX_MODULE_MAKE_OPTS = \
        CONFIG_DUMMY1= \
        CONFIG_DUMMY2=y
 
define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' LINUX_DIR='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
endef
 
$(eval $(kernel-module))
$(eval $(generic-package))
