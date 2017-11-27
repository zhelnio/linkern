
LINUX_VERSION = 4.4.0-98-generic

obj-m = hello.o

ifneq ($(KERNRELEASE),)
PWD := $(shell pwd)
else
LINUX_DIR := /usr/src/linux-headers-$(LINUX_VERSION)
endif

modules:
	$(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' modules

clean:
	$(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' clean
