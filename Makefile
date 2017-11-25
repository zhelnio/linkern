
help:
	$(info make help      - show this message)
	$(info make init      - init action after git clone)
	$(info make buildroot - build the buildroot)
	@true

.PHONY: buildroot menuconfig

init:
	git submodule update --init
	
obj:
	mkdir obj

BROBJ = ../obj/buildroot
BRIMG =  ./obj/buildroot/images
BRCFG = ../src/config/buildroot_defconfig

BROPT  = -C buildroot
BROPT += O=$(BROBJ)
BROPT += BR2_EXTERNAL=../src/br_tree

# reset buildroot config with default one
cf_reset: obj
	$(MAKE) $(BROPT) qemu_x86_64_defconfig
	$(MAKE) $(BROPT) savedefconfig BR2_DEFCONFIG=$(BRCFG)

# edit current buildroot config
cf_menu: 
	$(MAKE) $(BROPT) menuconfig 

# load buildroot config from config/*_defconfig
cf_load:
	$(MAKE) $(BROPT) defconfig BR2_DEFCONFIG=$(BRCFG)

# save current buildroot config as config/*_defconfig
cf_save: 
	$(MAKE) $(BROPT) savedefconfig BR2_DEFCONFIG=$(BRCFG)

hello:
	$(MAKE) $(BROPT) hello-dirclean
	$(MAKE) $(BROPT) hello-rebuild

pci:
	$(MAKE) $(BROPT) pci-dirclean
	$(MAKE) $(BROPT) pci-rebuild

misc:
	$(MAKE) $(BROPT) misc-dirclean
	$(MAKE) $(BROPT) misc-rebuild

xilpci:
	$(MAKE) $(BROPT) xilpci-dirclean
	$(MAKE) $(BROPT) xilpci-rebuild

# build the buildroot
buildroot:
	$(MAKE) $(BROPT) all

# rebuild all
all: hello pci misc buildroot

clean_all:
	rm -rf obj

#################################
#run the simulation with QEMU

KFLAGS  = norandmaps  
KFLAGS += printk.devkmsg=on
KFLAGS += printk.time=y
KFLAGS += console=ttyS0
#KFLAGS += init=/bin/sh

QFLAGS  = -m 128M
QFLAGS += -monitor telnet::45454,server,nowait
QFLAGS += -netdev user,hostfwd=tcp::45455-:45455,id=net0
QFLAGS += -smp 1

QFLAGS += -M pc
QFLAGS += -append 'root=/dev/vda nopat $(KFLAGS)'
QFLAGS += -device edu
# QFLAGS += -device lkmc_pci_min
QFLAGS += -device virtio-net-pci,netdev=net0
QFLAGS += -drive file=$(BRIMG)/rootfs.ext2,if=virtio,format=raw
QFLAGS += -kernel $(BRIMG)/bzImage 

QFLAGS += -nographic

run:
	qemu-system-x86_64 $(QFLAGS)

