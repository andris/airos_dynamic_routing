#
# Copyright (C) 2006-2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id$

BLOCK_MENU:=Block Devices

define KernelPackage/ata-core
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=Serial and Parallel ATA support
  DEPENDS:=@PCI_SUPPORT @LINUX_2_6 +kmod-scsi-core
  KCONFIG:=CONFIG_ATA
  FILES:=$(LINUX_DIR)/drivers/ata/libata.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,21,libata)
endef

$(eval $(call KernelPackage,ata-core))


define KernelPackage/ata-ahci
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=AHCI Serial ATA support
  DEPENDS:=kmod-ata-core
  KCONFIG:=CONFIG_SATA_AHCI
  FILES:=$(LINUX_DIR)/drivers/ata/ahci.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,41,ahci)
endef

define KernelPackage/ata-ahci/description
 Support for AHCI Serial ATA controllers.
endef

$(eval $(call KernelPackage,ata-ahci))


define KernelPackage/ata-artop
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=ARTOP 6210/6260 PATA support
  DEPENDS:=kmod-ata-core
  KCONFIG:=CONFIG_PATA_ARTOP
  FILES:=$(LINUX_DIR)/drivers/ata/pata_artop.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,41,pata_artop)
endef

define KernelPackage/ata-artop/description
 PATA support for ARTOP 6210/6260 host controllers.
endef

$(eval $(call KernelPackage,ata-artop))


define KernelPackage/ata-ixp4xx-cf
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=IXP4XX Compact Flash support
  DEPENDS:=kmod-ata-core
  KCONFIG:=CONFIG_PATA_IXP4XX_CF
  FILES:=$(LINUX_DIR)/drivers/ata/pata_ixp4xx_cf.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,41,pata_ixp4xx_cf)
endef

define KernelPackage/ata-ixp4xx-cf/description
 IXP4XX Compact Flash support.
endef

$(eval $(call KernelPackage,ata-ixp4xx-cf))


define KernelPackage/ata-nvidia-sata
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=Nvidia Serial ATA support
  DEPENDS:=kmod-ata-core
  KCONFIG:=CONFIG_SATA_NV
  FILES:=$(LINUX_DIR)/drivers/ata/sata_nv.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,41,sata_nv)
endef

$(eval $(call KernelPackage,ata-nvidia-sata))


define KernelPackage/ata-piix
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=Intel PIIX PATA/SATA support
  DEPENDS:=kmod-ata-core
  KCONFIG:=CONFIG_ATA_PIIX
  FILES:=$(LINUX_DIR)/drivers/ata/ata_piix.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,41,ata_piix)
endef

define KernelPackage/ata-piix/description
 SATA support for Intel ICH5/6/7/8 series host controllers and
 PATA support for Intel ESB/ICH/PIIX3/PIIX4 series host controllers.
endef

$(eval $(call KernelPackage,ata-piix))


define KernelPackage/ata-via-sata
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=VIA SATA support
  DEPENDS:=kmod-ata-core
  KCONFIG:=CONFIG_SATA_VIA
  FILES:=$(LINUX_DIR)/drivers/ata/sata_via.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,41,sata_via)
endef

define KernelPackage/ata-via-sata/description
 This option enables support for VIA Serial ATA.
endef

$(eval $(call KernelPackage,ata-via-sata))


define KernelPackage/ide-core
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=IDE (ATA/ATAPI) device support
  DEPENDS:=@PCI_SUPPORT
  KCONFIG:= \
	CONFIG_IDE \
	CONFIG_IDE_GENERIC \
	CONFIG_BLK_DEV_GENERIC \
	CONFIG_BLK_DEV_IDE \
	CONFIG_BLK_DEV_IDEDISK \
	CONFIG_BLK_DEV_IDEDMA_PCI=y \
	CONFIG_BLK_DEV_IDEPCI=y
  FILES:= \
	$(LINUX_DIR)/drivers/ide/ide-core.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/ide/ide-disk.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,20,ide-core) $(call AutoLoad,40,ide-disk)
endef

define KernelPackage/ide-core/2.4
  FILES+=$(LINUX_DIR)/drivers/ide/ide-detect.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD+=$(call AutoLoad,30,ide-detect)
endef

ifeq ($(strip $(call CompareKernelPatchVer,$(KERNEL_PATCHVER),ge,2.6.26)),1)
  define KernelPackage/ide-core/2.6
    FILES+=$(LINUX_DIR)/drivers/ide/pci/ide-pci-generic.$(LINUX_KMOD_SUFFIX)
    AUTOLOAD+=$(call AutoLoad,30,ide-pci-generic)
  endef
else
  define KernelPackage/ide-core/2.6
    FILES+=$(LINUX_DIR)/drivers/ide/ide-generic.$(LINUX_KMOD_SUFFIX)
    AUTOLOAD+=$(call AutoLoad,30,ide-generic)
  endef
endif

define KernelPackage/ide-core/description
 Kernel support for IDE, useful for usb mass storage devices (e.g. on WL-HDD)
 Includes:
 - ide-core
 - ide-detect
 - ide-disk
endef

$(eval $(call KernelPackage,ide-core))


define KernelPackage/ide-aec62xx
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=Acard AEC62xx IDE driver
  DEPENDS:=@PCI_SUPPORT +kmod-ide-core
  KCONFIG:=CONFIG_BLK_DEV_AEC62XX
  FILES:=$(LINUX_DIR)/drivers/ide/pci/aec62xx.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,aec62xx)
endef

define KernelPackage/ide-aec62xx/description
 Support for Acard AEC62xx (Artop ATP8xx) IDE controllers.
endef

$(eval $(call KernelPackage,ide-aec62xx))


define KernelPackage/ide-magicbox
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=Magicbox 2.0 IDE CF driver
  DEPENDS:=@TARGET_magicbox +kmod-ide-core
  KCONFIG:=CONFIG_BLK_DEV_MAGICBOX_IDE
  FILES:=$(LINUX_DIR)/drivers/ide/ppc/magicbox_ide.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,magicbox_ide)
endef

define KernelPackage/ide-magicbox/description
 Support for Magicbox 2.0 onboard CF slot.
endef

$(eval $(call KernelPackage,ide-magicbox))


define KernelPackage/ide-pdc202xx
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=Promise PDC202xx IDE driver
  DEPENDS:=@LINUX_2_4 +kmod-ide-core
  KCONFIG:=CONFIG_BLK_DEV_PDC202XX_OLD
  FILES:=$(LINUX_DIR)/drivers/ide/pci/pdc202xx_old.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,pdc202xx_old)
endef

define KernelPackage/ide-pdc202xx/description
 Support for the Promise Ultra 33/66/100 (PDC202{46|62|65|67|68}) IDE
 controllers.
endef

$(eval $(call KernelPackage,ide-pdc202xx))


define KernelPackage/scsi-core
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=SCSI device support
  KCONFIG:= \
	CONFIG_SCSI \
	CONFIG_BLK_DEV_SD
  FILES:= \
	$(LINUX_DIR)/drivers/scsi/scsi_mod.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/scsi/sd_mod.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,20,scsi_mod) $(call AutoLoad,40,sd_mod)
endef

$(eval $(call KernelPackage,scsi-core))


define KernelPackage/scsi-generic
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=Kernel support for SCSI generic
  KCONFIG:= \
	CONFIG_CHR_DEV_SG
  FILES:= \
	$(LINUX_DIR)/drivers/scsi/sg.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,65,sg)
endef

$(eval $(call KernelPackage,scsi-generic))


define KernelPackage/loop
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=Loopback device support
  KCONFIG:= \
	CONFIG_BLK_DEV_LOOP \
	CONFIG_BLK_DEV_CRYPTOLOOP=n
  FILES:=$(LINUX_DIR)/drivers/block/loop.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,loop)
endef

define KernelPackage/loop/description
 Kernel module for loopback device support
endef

$(eval $(call KernelPackage,loop))


define KernelPackage/nbd
  SUBMENU:=$(BLOCK_MENU)
  TITLE:=Network block device support
  KCONFIG:=CONFIG_BLK_DEV_NBD
  FILES:=$(LINUX_DIR)/drivers/block/nbd.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,nbd)
endef

define KernelPackage/nbd/description
 Kernel module for network block device support
endef

$(eval $(call KernelPackage,nbd))


define KernelPackage/pata-rb153-cf
  SUBMENU:=$(BLOCK_MENU)
  DEPENDS:=kmod-ata-core @TARGET_adm5120_router_le
  TITLE:=RouterBOARD 153 CF Slot support
  KCONFIG:=CONFIG_PATA_RB153_CF
  FILES:=$(LINUX_DIR)/drivers/ata/pata_rb153_cf.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,30,pata_rb153_cf)
endef

define KernelPackage/pata-rb153-cf/description
  Kernel support for the RouterBoard 153 CF slot.
endef

$(eval $(call KernelPackage,pata-rb153-cf))
