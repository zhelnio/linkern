PCI_MODULE_VERSION = 1.0
PCI_SITE = ../src/module/01_pci
PCI_SITE_METHOD = local
PCI_LICENSE = GPLv2
PCI_LICENSE_FILES = COPYING
PCI_MODULE_MAKE_OPTS = \
        CONFIG_DUMMY1= \
        CONFIG_DUMMY2=y
 
define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' LINUX_DIR='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
endef
 
$(eval $(kernel-module))
$(eval $(generic-package))
