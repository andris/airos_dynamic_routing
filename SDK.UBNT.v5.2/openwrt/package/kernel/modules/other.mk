#
# Copyright (C) 2006-2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# $Id$

OTHER_MENU:=Other modules

define KernelPackage/crc-itu-t
  SUBMENU:=$(OTHER_MENU)
  TITLE:=CRC ITU-T V.41 support
  KCONFIG:=CONFIG_CRC_ITU_T
  FILES:=$(LINUX_DIR)/lib/crc-itu-t.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,20,crc-itu-t)
endef

define KernelPackage/crc-itu-t/description
 Kernel module for CRC ITU-T V.41 support
endef

$(eval $(call KernelPackage,crc-itu-t))


define KernelPackage/crc7
  SUBMENU:=$(OTHER_MENU)
  TITLE:=CRC7 support
  KCONFIG:=CONFIG_CRC7
  FILES:=$(LINUX_DIR)/lib/crc7.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,20,crc7)
endef

define KernelPackage/crc7/description
 Kernel module for CRC7 support
endef

$(eval $(call KernelPackage,crc7))


define KernelPackage/eeprom-93cx6
  SUBMENU:=$(OTHER_MENU)
  TITLE:=EEPROM 93CX6 support
  DEPENDS:=@LINUX_2_6
  KCONFIG:=CONFIG_EEPROM_93CX6
  FILES:=$(LINUX_DIR)/drivers/misc/eeprom_93cx6.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,20,eeprom_93cx6)
endef

define KernelPackage/eeprom-93cx6/description
 Kernel module for EEPROM 93CX6 support
endef

$(eval $(call KernelPackage,eeprom-93cx6))


define KernelPackage/lp
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Parallel port and line printer support
  DEPENDS:=@LINUX_2_4
  KCONFIG:= \
	CONFIG_PARPORT \
	CONFIG_PRINTER \
	CONFIG_PPDEV
  FILES:= \
	$(LINUX_DIR)/drivers/parport/parport.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/char/lp.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/char/ppdev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,parport lp)
endef

$(eval $(call KernelPackage,lp))


define KernelPackage/pcmcia-core
  SUBMENU:=$(OTHER_MENU)
  TITLE:=PCMCIA/CardBus support
  DEPENDS:=@PCMCIA_SUPPORT
  KCONFIG:= \
	CONFIG_PCMCIA \
	CONFIG_CARDBUS \
	CONFIG_PCCARD \
	CONFIG_YENTA \
	CONFIG_PCCARD_NONSTATIC \
	PCMCIA_DEBUG=n
endef

define KernelPackage/pcmcia-core/2.4
#  KCONFIG:= \
#	CONFIG_PCMCIA \
#	CONFIG_CARDBUS
  FILES:= \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia_core.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/ds.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/yenta_socket.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,pcmcia_core yenta_socket ds)
endef

define KernelPackage/pcmcia-core/2.6
#  KCONFIG:= \
#	CONFIG_PCCARD \
#	CONFIG_PCMCIA \
#	CONFIG_YENTA \
#	CONFIG_PCCARD_NONSTATIC \
#	PCMCIA_DEBUG=n
  FILES:= \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia_core.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/rsrc_nonstatic.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/yenta_socket.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,pcmcia_core pcmcia rsrc_nonstatic yenta_socket)
endef

define KernelPackage/pcmcia-core/au1000-2.6
  FILES:= \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia_core.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/pcmcia.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/rsrc_nonstatic.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/pcmcia/au1x00_ss.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,pcmcia_core pcmcia rsrc_nonstatic au1x00_ss)
endef

define KernelPackage/pcmcia-core/description
 Kernel support for PCMCIA/CardBus controllers
endef

$(eval $(call KernelPackage,pcmcia-core))


define KernelPackage/pcmcia-serial
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Serial devices support
  DEPENDS:=kmod-pcmcia-core
  KCONFIG:= \
	CONFIG_PCMCIA_SERIAL_CS \
	CONFIG_SERIAL_8250_CS
  AUTOLOAD:=$(call AutoLoad,45,serial_cs)
endef

define KernelPackage/pcmcia-serial/2.4
#  KCONFIG:=CONFIG_PCMCIA_SERIAL_CS
  FILES:=$(LINUX_DIR)/drivers/char/pcmcia/serial_cs.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/pcmcia-serial/2.6
#  KCONFIG:=CONFIG_SERIAL_8250_CS
  FILES:=$(LINUX_DIR)/drivers/serial/serial_cs.$(LINUX_KMOD_SUFFIX)
endef

define KernelPackage/pcmcia-serial/description
 Kernel support for PCMCIA/CardBus serial devices
endef

$(eval $(call KernelPackage,pcmcia-serial))


define KernelPackage/bluetooth
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Bluetooth support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core
  KCONFIG:= \
	CONFIG_BLUEZ \
	CONFIG_BLUEZ_L2CAP \
	CONFIG_BLUEZ_SCO \
	CONFIG_BLUEZ_RFCOMM \
	CONFIG_BLUEZ_BNEP \
	CONFIG_BLUEZ_HCIUART \
	CONFIG_BLUEZ_HCIUSB \
	CONFIG_BT \
	CONFIG_BT_L2CAP \
	CONFIG_BT_SCO \
	CONFIG_BT_RFCOMM \
	CONFIG_BT_BNEP \
	CONFIG_BT_HCIUSB \
	CONFIG_BT_HCIUART
endef

define KernelPackage/bluetooth/2.4
#  KCONFIG:= \
#	CONFIG_BLUEZ \
#	CONFIG_BLUEZ_L2CAP \
#	CONFIG_BLUEZ_SCO \
#	CONFIG_BLUEZ_RFCOMM \
#	CONFIG_BLUEZ_BNEP \
#	CONFIG_BLUEZ_HCIUART \
#	CONFIG_BLUEZ_HCIUSB
  FILES:= \
	$(LINUX_DIR)/net/bluetooth/bluez.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/l2cap.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/sco.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/rfcomm/rfcomm.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/bnep/bnep.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/bluetooth/hci_uart.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/bluetooth/hci_usb.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,bluez l2cap sco rfcomm bnep hci_uart hci_usb)
endef

define KernelPackage/bluetooth/2.6
#  KCONFIG:= \
#	CONFIG_BT \
#	CONFIG_BT_L2CAP \
#	CONFIG_BT_SCO \
#	CONFIG_BT_RFCOMM \
#	CONFIG_BT_BNEP \
#	CONFIG_BT_HCIUSB \
#	CONFIG_BT_HCIUART
  FILES:= \
	$(LINUX_DIR)/net/bluetooth/bluetooth.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/l2cap.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/sco.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/rfcomm/rfcomm.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/net/bluetooth/bnep/bnep.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/bluetooth/hci_uart.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/bluetooth/hci_usb.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,bluetooth l2cap sco rfcomm bnep hci_uart hci_usb)
endef

define KernelPackage/bluetooth/description
 Kernel support for Bluetooth devices
endef

$(eval $(call KernelPackage,bluetooth))


define KernelPackage/mmc
  SUBMENU:=$(OTHER_MENU)
  TITLE:=MMC/SD Card Support
  DEPENDS:=@LINUX_2_6
  KCONFIG:= \
	CONFIG_MMC \
	CONFIG_MMC_BLOCK \
	CONFIG_MMC_DEBUG=n \
	CONFIG_MMC_UNSAFE_RESUME=n \
	CONFIG_MMC_BLOCK_BOUNCE=y \
	CONFIG_MMC_SDHCI=n \
	CONFIG_MMC_TIFM_SD=n \
	CONFIG_MMC_WBSD=n \
	CONFIG_SDIO_UART=n
  FILES:= \
	$(LINUX_DIR)/drivers/mmc/core/mmc_core.$(LINUX_KMOD_SUFFIX) \
	$(LINUX_DIR)/drivers/mmc/card/mmc_block.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,mmc_core mmc_block)
endef

define KernelPackage/mmc/description
 Kernel support for MMC/SD cards
endef

$(eval $(call KernelPackage,mmc))


define KernelPackage/mmc-at91
  SUBMENU:=$(OTHER_MENU)
  TITLE:=MMC/SD Card Support on AT91
  DEPENDS:=@TARGET_at91 +kmod-mmc
  KCONFIG:=CONFIG_MMC_AT91
  FILES:=$(LINUX_DIR)/drivers/mmc/host/at91_mci.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,at91_mci)
endef

define KernelPackage/mmc-at91/description
 Kernel support for MMC/SD cards on the AT91 target
endef

$(eval $(call KernelPackage,mmc-at91))


# XXX: added a workaround for watchdog path changes
ifeq ($(KERNEL),2.4)
  WATCHDOG_DIR=char
endif
ifeq ($(strip $(call CompareKernelPatchVer,$(KERNEL_PATCHVER),ge,2.6.24)),1)
  WATCHDOG_DIR=watchdog
endif
WATCHDOG_DIR?=char/watchdog

define KernelPackage/atmel-wdt
  SUBMENU:=$(OTHER_MENU)
  TITLE:=AT32AP700x watchdog
  DEPENDS:=@TARGET_avr32
  KCONFIG:=CONFIG_AT32AP700X_WDT
  FILES:=$(LINUX_DIR)/drivers/$(WATCHDOG_DIR)/at32ap700x_wdt.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,at32ap700x_wdt)
endef

define KernelPackage/atmel-wdt/description
 AT32AP700x watchdog
endef

$(eval $(call KernelPackage,atmel-wdt))


define KernelPackage/softdog
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Software watchdog driver
  KCONFIG:=CONFIG_SOFT_WATCHDOG
  FILES:=$(LINUX_DIR)/drivers/$(WATCHDOG_DIR)/softdog.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,softdog)
endef

define KernelPackage/softdog/description
 Software watchdog driver
endef

$(eval $(call KernelPackage,softdog))


define KernelPackage/leds-gpio
  SUBMENU:=$(OTHER_MENU)
  TITLE:=GPIO LED support
  DEPENDS:= @GPIO_SUPPORT
  KCONFIG:=CONFIG_LEDS_GPIO
  FILES:=$(LINUX_DIR)/drivers/leds/leds-gpio.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,leds-gpio)
endef

define KernelPackage/leds-gpio/description
 Kernel module for LEDs on GPIO lines
endef

$(eval $(call KernelPackage,leds-gpio))


define KernelPackage/ledtrig-adm5120-switch
  SUBMENU:=$(OTHER_MENU)
  TITLE:=LED ADM5120 Switch Port Status Trigger
  DEPENDS:=@TARGET_adm5120
  KCONFIG:=CONFIG_LEDS_TRIGGER_ADM5120_SWITCH
  FILES:=$(LINUX_DIR)/drivers/leds/ledtrig-adm5120-switch.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,ledtrig-adm5120-switch)
endef

define KernelPackage/ledtrig-adm5120-switch/description
 Kernel module to allow LEDs to be controlled by the port states
 of the ADM5120 built-in ethernet switch.
endef

$(eval $(call KernelPackage,ledtrig-adm5120-switch))


define KernelPackage/leds-net48xx
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Soekris Net48xx LED support
  DEPENDS:=@TARGET_x86 +kmod-scx200-gpio
  KCONFIG:=CONFIG_LEDS_NET48XX
  FILES:=$(LINUX_DIR)/drivers/leds/leds-net48xx.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,leds-net48xx)
endef

define KernelPackage/leds-net48xx/description
 Kernel module for Soekris Net48xx LEDs
endef

$(eval $(call KernelPackage,leds-net48xx))


define KernelPackage/leds-wrap
  SUBMENU:=$(OTHER_MENU)
  TITLE:=PCengines WRAP LED support
  DEPENDS:=@TARGET_x86 +kmod-scx200-gpio
  KCONFIG:=CONFIG_LEDS_WRAP
  FILES:=$(LINUX_DIR)/drivers/leds/leds-wrap.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,leds-wrap)
endef

define KernelPackage/leds-wrap/description
 Kernel module for PCengines WRAP LEDs
endef

$(eval $(call KernelPackage,leds-wrap))


define KernelPackage/leds-alix
  SUBMENU:=$(OTHER_MENU)
  TITLE:=PCengines ALIX LED support
  DEPENDS:=@TARGET_x86
  KCONFIG:=CONFIG_LEDS_ALIX
  FILES:=$(LINUX_DIR)/drivers/leds/leds-alix.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,leds-alix)
endef

define KernelPackage/leds-alix/description
 Kernel module for PCengines ALIX LEDs
endef

$(eval $(call KernelPackage,leds-alix))


define KernelPackage/ledtrig-netdev
  SUBMENU:=$(OTHER_MENU)
  TITLE:=LED NETDEV Trigger
  KCONFIG:=CONFIG_LEDS_TRIGGER_NETDEV
  FILES:=$(LINUX_DIR)/drivers/leds/ledtrig-netdev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,ledtrig-netdev)
endef

define KernelPackage/ledtrig-netdev/description
 Kernel module to drive LEDs based on network activity.
endef

$(eval $(call KernelPackage,ledtrig-netdev))


define KernelPackage/ledtrig-morse
  SUBMENU:=$(OTHER_MENU)
  TITLE:=LED Morse Trigger
  KCONFIG:=CONFIG_LEDS_TRIGGER_MORSE
  FILES:=$(LINUX_DIR)/drivers/leds/ledtrig-morse.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,ledtrig-morse)
endef

define KernelPackage/ledtrig-morse/description
 Kernel module to show morse coded messages on LEDs.
endef

$(eval $(call KernelPackage,ledtrig-morse))


define KernelPackage/gpio-dev
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Generic GPIO char device support
  DEPENDS:=@GPIO_SUPPORT
  KCONFIG:=CONFIG_GPIO_DEVICE
  FILES:=$(LINUX_DIR)/drivers/char/gpio_dev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,gpio_dev)
endef

define KernelPackage/gpio-dev/description
  Kernel module to allows control of GPIO pins using a character device.
endef

$(eval $(call KernelPackage,gpio-dev))


define KernelPackage/nsc-gpio
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Natsemi GPIO support
  DEPENDS:=@TARGET_x86
  KCONFIG:=CONFIG_NSC_GPIO
  FILES:=$(LINUX_DIR)/drivers/char/nsc_gpio.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,40,nsc_gpio)
endef

define KernelPackage/nsc-gpio/description
 Kernel module for Natsemi GPIO
endef

$(eval $(call KernelPackage,nsc-gpio))


define KernelPackage/scx200-gpio
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Natsemi SCX200 GPIO support
  DEPENDS:=@TARGET_x86 +kmod-nsc-gpio
  KCONFIG:=CONFIG_SCx200_GPIO
  FILES:=$(LINUX_DIR)/drivers/char/scx200_gpio.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,scx200_gpio)
endef

define KernelPackage/scx200-gpio/description
 Kernel module for SCX200 GPIO
endef

$(eval $(call KernelPackage,scx200-gpio))


define KernelPackage/scx200-wdt
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Natsemi SCX200 Watchdog support
  DEPENDS:=@TARGET_x86
  KCONFIG:=CONFIG_SC1200_WDT
  FILES:=$(LINUX_DIR)/drivers/$(WATCHDOG_DIR)/scx200_wdt.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,scx200_wdt)
endef

define KernelPackage/scx200-wdt/description
 Kernel module for SCX200 Watchdog
endef

$(eval $(call KernelPackage,scx200-wdt))


define KernelPackage/input-core
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Input device core
  DEPENDS:=@LINUX_2_6
  KCONFIG:=CONFIG_INPUT
  FILES:=$(LINUX_DIR)/drivers/input/input-core.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,50,input-core)
endef

define KernelPackage/input-core/description
 Kernel modules for support of input device
endef

$(eval $(call KernelPackage,input-core))


define KernelPackage/input-evdev
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Input even device
  DEPENDS:=+kmod-input-core
  KCONFIG:=CONFIG_INPUT_EVDEV
  FILES:=$(LINUX_DIR)/drivers/input/evdev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,evdev)
endef

define KernelPackage/input-evdev/description
 Kernel modules for support of input device events
endef

$(eval $(call KernelPackage,input-evdev))


define KernelPackage/hid
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Input even device
  DEPENDS:=+kmod-input-core +kmod-input-evdev
  KCONFIG:=CONFIG_HID
  FILES:=$(LINUX_DIR)/drivers/hid/hid.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,61,hid)
endef

define KernelPackage/hid/description
 Kernel modules for HID devices
endef

$(eval $(call KernelPackage,hid))


define KernelPackage/input-polldev
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Polled Input device support
  DEPENDS:=+kmod-input-core @LINUX_2_6
  KCONFIG:=CONFIG_INPUT_POLLDEV
  FILES:=$(LINUX_DIR)/drivers/input/input-polldev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,61,input-polldev)
endef

define KernelPackage/input-polldev/description
 Kernel module for support of polled input devices
endef

$(eval $(call KernelPackage,input-polldev))


define KernelPackage/input-gpio-buttons
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Polled GPIO buttons input device
  DEPENDS:=@GPIO_SUPPORT +kmod-input-polldev
  KCONFIG:= \
	CONFIG_INPUT_GPIO_BUTTONS \
	CONFIG_INPUT_MISC=y
  FILES:=$(LINUX_DIR)/drivers/input/misc/gpio_buttons.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,62,gpio_buttons)
endef

define KernelPackage/input-gpio-buttons/description
 Kernel module for support polled GPIO buttons input device
endef

$(eval $(call KernelPackage,input-gpio-buttons))


define KernelPackage/mmc-spi
  SUBMENU:=$(OTHER_MENU)
  TITLE:=MMC/SD over SPI Support
  DEPENDS:=@LINUX_2_6 +kmod-mmc +kmod-crc-itu-t +kmod-crc7
  KCONFIG:=CONFIG_MMC_SPI \
          CONFIG_SPI=y \
          CONFIG_SPI_MASTER=y
  FILES:=$(LINUX_DIR)/drivers/mmc/host/mmc_spi.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,mmc_spi)
endef

define KernelPackage/mmc-spi/description
 Kernel support for MMC/SD over SPI
endef

$(eval $(call KernelPackage,mmc-spi))

define KernelPackage/mmc-atmelmci
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Amtel MMC Support
  DEPENDS:=@TARGET_avr32 +kmod-mmc
  KCONFIG:=CONFIG_MMC_ATMELMCI
  FILES:=$(LINUX_DIR)/drivers/mmc/host/atmel-mci.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,atmel-mci)
endef

define KernelPackage/mmc-atmelmci/description
 Kernel support for  Atmel Multimedia Card Interface.
endef

$(eval $(call KernelPackage,mmc-atmelmci))

define KernelPackage/spi-bitbang
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Serial Peripheral Interface bitbanging library
  DEPENDS:=@LINUX_2_6
  KCONFIG:=CONFIG_SPI_BITBANG \
          CONFIG_SPI=y \
          CONFIG_SPI_MASTER=y
  FILES:=$(LINUX_DIR)/drivers/spi/spi_bitbang.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,91,spi_bitbang)
endef

define KernelPackage/spi-bitbang/description
 This package contains the SPI bitbanging library
endef

$(eval $(call KernelPackage,spi-bitbang))

define KernelPackage/spi-gpio
  SUBMENU:=$(OTHER_MENU)
  TITLE:=GPIO based bitbanging SPI controller
  DEPENDS:=@GPIO_SUPPORT +kmod-spi-bitbang
  KCONFIG:=CONFIG_SPI_GPIO
  FILES:=$(LINUX_DIR)/drivers/spi/spi_gpio.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,92,spi_gpio)
endef

define KernelPackage/spi-gpio/description
 This package contains the GPIO based bitbanging SPI controller driver
endef

$(eval $(call KernelPackage,spi-gpio))

define KernelPackage/spi-dev
  SUBMENU:=$(OTHER_MENU)
  TITLE:=User mode SPI device driver
  DEPENDS:=@LINUX_2_6
  KCONFIG:=CONFIG_SPI_SPIDEV \
          CONFIG_SPI=y \
          CONFIG_SPI_MASTER=y
  FILES:=$(LINUX_DIR)/drivers/spi/spidev.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,91,spidev)
endef

define KernelPackage/spi-dev/description
 This package contains the user mode SPI device driver
endef

$(eval $(call KernelPackage,spi-dev))

define KernelPackage/crypto-dev-ixp4xx
  SUBMENU:=$(OTHER_MENU)
  TITLE:=IXP4xx crypto driver
  DEPENDS:=\
	@TARGET_ixp4xx +kmod-crypto-core +kmod-crypto-des +kmod-crypto-aead \
	+kmod-crypto-authenc
  KCONFIG:=\
	CONFIG_CRYPTO_HW=y \
	CONFIG_CRYPTO_DEV_IXP4XX
  FILES:=$(LINUX_DIR)/drivers/crypto/ixp4xx_crypto.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,90,ixp4xx_crypto)
endef

define KernelPackage/crypto-dev-ixp4xx/description
 Kernel support for the IXP4xx HW crypto engine.
endef

$(eval $(call KernelPackage,crypto-dev-ixp4xx))

define KernelPackage/ar7240-gpio
  SUBMENU:=$(OTHER_MENU)
  TITLE:=AR7240 GPIO driver (Ubiquiti)
  DEPENDS:= @TARGET_ar71xx
  KCONFIG:=CONFIG_AR7240_GPIO
  FILES:=$(LINUX_DIR)/drivers/char/ar7240_gpio.$(LINUX_KMOD_SUFFIX)
  AUTOLOAD:=$(call AutoLoad,60,ar7240_gpio)
endef

define KernelPackage/ar7240-gpio/description
 Kernel module for GPIO lines on AR7240 (Ubiquiti)
endef

$(eval $(call KernelPackage,ar7240-gpio))


