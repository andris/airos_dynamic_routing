# Use the default kernel version if the Makefile doesn't override it

ifeq ($(KERNEL),2.4)
  LINUX_VERSION?=2.4.35.4
else
  LINUX_VERSION?=2.6.26.8
endif
LINUX_RELEASE?=1

ifeq ($(LINUX_VERSION),2.4.35.4)
  LINUX_KERNEL_MD5SUM:=34066faff3d8c042df1c7600b08b8070
endif
ifeq ($(LINUX_VERSION),2.6.23.17)
  LINUX_KERNEL_MD5SUM:=a0300a393ac91ce9c64bf31522b45e2e
endif
ifeq ($(LINUX_VERSION),2.6.24.7)
  LINUX_KERNEL_MD5SUM:=40a73780d51525d28d36dec852c680c4
endif
ifeq ($(LINUX_VERSION),2.6.25.20)
  LINUX_KERNEL_MD5SUM:=0da698edccf03e2235abc2830a495114
endif
ifeq ($(LINUX_VERSION),2.6.26.8)
  LINUX_KERNEL_MD5SUM:=05dd0d4f8f110b4219ae6ec7a36c046d
endif

# disable the md5sum check for unknown kernel versions
LINUX_KERNEL_MD5SUM?=x

KERNEL?=2.$(word 2,$(subst ., ,$(strip $(LINUX_VERSION))))
KERNEL_PATCHVER=$(shell echo '$(LINUX_VERSION)' | cut -d. -f1,2,3 | cut -d- -f1)

