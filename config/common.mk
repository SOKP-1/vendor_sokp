PRODUCT_BRAND ?= SOKP

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/sokp/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/sokp/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/sokp/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.semc.sound_effects_enabled=true \
    ro.semc.xloud.supported=true \
    media.xloud.enable=1 \
    media.xloud.supported=true \
    ro.semc.enhance.supported=true

PRODUCT_PROPERTY_OVERRIDES += \
    persist.service.enhance.enable=1 \
    ro.semc.clearaudio.supported=true \
    persist.service.clearaudio.enable=1 \
    ro.sony.walkman.logger=1 \
    persist.service.walkman.enable=1 \
    ro.somc.clearphase.supported=true \
    persist.service.clearphase.enable=1 \
    af.resampler.quality=255

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product-res-path=framework/SemcGenericUxpRes.apk \
    af.resampler.quality=255 \
    ro.somc.clearphase.supported=true \
    ro.semc.xloud.supported=true \
    ro.somc.sforce.supported=true \
    ro.service.swiqi3.supported=true \
    persist.service.swiqi3.enable=1 \
    tunnel.decode=true

PRODUCT_PROPERTY_OVERRIDES += \
    tunnel.audiovideo.decode=true \
    persist.speaker.prot.enable=false \
    media.aac_51_output_enabled=true \
    dev.pm.dyn_samplingrate=1 \
    ro.HOME_APP_ADJ=1 \
    persist.sys.use_dithering=1 \
    presist.sys.font_clarity=0

PRODUCT_PROPERTY_OVERRIDES += \
    persist.audio.fluence.mode=endfire \
    persist.audio.hp=true \
    persist.htc.audio.pcm.samplerate=44100 \
    persist.htc.audio.pcm.channels=2 \
    htc.audio.swalt.mingain=14512 \
    htc.audio.swalt.enable=1 \
    htc.audio.alc.enable=1
    
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/sokp/CHANGELOG.mkdn:system/etc/CHANGELOG-SOKP.txt

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/sokp/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/sokp/prebuilt/common/bin/50-backupScript.sh:system/addon.d/50-backupScript.sh

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/bin/otasigcheck.sh:system/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/sokp/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# SOKP-specific init file
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/etc/init.local.rc:root/init.sokp.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/sokp/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/sokp/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is CM Based!
PRODUCT_COPY_FILES += \
    vendor/sokp/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# T-Mobile theme engine
include vendor/sokp/config/themes_common.mk

# Required SOKP packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt

# Optional SOKP packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji

# Custom SOKP packages
PRODUCT_PACKAGES += \
    SonicPapers \
    GPSOptimizer \
    libcyanogen-dsp \
    audio_effects.conf \
    Apollo \
    CMAccount \
    SOKPStats \
    EOSWeather \
    AndroidKernelTweaker \
    CMFileManager \
    LockClock 
    

# SOKP Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in CM
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

#OmniRom Packages
PRODUCT_PACKAGES += \
    OmniSwitch

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Screen recorder
PRODUCT_PACKAGES += \
    ScreenRecorder \
    libscreenrecorder

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)

PRODUCT_PACKAGES += \
    procmem \
    procrank \
    Superuser \
    su

# Terminal Emulator
#PRODUCT_COPY_FILES +=  \
    #vendor/sokp/proprietary/Term.apk:system/app/Term.apk \
    #vendor/sokp/proprietary/lib/armeabi/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=1
else

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

endif

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/sokp/overlay/common

PRODUCT_VERSION_MAJOR = KK444
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0-RC0

# Set SOKP_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef SOKP_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "SOKP_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^SOKP_||g')
        SOKP_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(SOKP_BUILDTYPE)),)
    SOKP_BUILDTYPE :=
endif

ifdef SOKP_BUILDTYPE
    ifneq ($(SOKP_BUILDTYPE), SNAPSHOT)
        ifdef SOKP_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            SOKP_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from CM_EXTRAVERSION
            SOKP_EXTRAVERSION := $(shell echo $(SOKP_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to SOKP_EXTRAVERSION
            SOKP_EXTRAVERSION := -$(SOKP_EXTRAVERSION)
        endif
    else
        ifndef SOKP_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            SOKP_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from SOKP_EXTRAVERSION
            SOKP_EXTRAVERSION := $(shell echo $(CM_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to SOKP_EXTRAVERSION
            SOKP_EXTRAVERSION := -$(SOKP_EXTRAVERSION)
        endif
    endif
else
    # If SOKP_BUILDTYPE is not defined, set to UNOFFICIAL
    SOKP_BUILDTYPE := UNOFFICIAL
    SOKP_EXTRAVERSION :=
endif

ifeq ($(SOKP_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        SOKP_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(SOKP_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        SOKP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(SOKP_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            SOKP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(SOKP_BUILD)
        else
            SOKP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(SOKP_BUILD)
        endif
    endif
else
    ifeq ($(PRODUCT_VERSION_MINOR),0)
        SOKP_VERSION := $(PRODUCT_VERSION_MAJOR)-$(shell date -u +%Y%m%d)-$(SOKP_BUILDTYPE)$(SOKP_EXTRAVERSION)-$(SOKP_BUILD)
    else
        SOKP_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(SOKP_BUILDTYPE)$(SOKP_EXTRAVERSION)-$(SOKP_BUILD)
    endif
endif

SOKP_Version=KK444-KTU84Q-V-01
SOKP_MOD_VERSION := SOKP-$(SOKP_Version)-$(shell date -u +%Y%m%d)$(SOKP_EXTRAVERSION)-$(SOKP_BUILD)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.sokp.version=SOKP-$(SOKP_Version)-$(SOKP_BUILD)-$(shell date -u +%Y%m%d)$(SOKP_EXTRAVERSION) \
  ro.modversion=$(SOKP_MOD_VERSION) \
  ro.cmlegal.url=http://sonic-developers.com/?page_id=154

-include vendor/cm-priv/keys/keys.mk

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

# Add su support
#PRODUCT_COPY_FILES += \
    #vendor/sokp/prebuilt/common/su/su:system/xbin/su \
    #vendor/sokp/prebuilt/common/su/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon \
    #vendor/sokp/prebuilt/common/su/daemonsu:system/xbin/daemonsu \
    #vendor/sokp/prebuilt/common/su/install-recovery.sh:system/etc/install-recovery.sh \
    #vendor/sokp/prebuilt/common/su/.installed_su_daemon:system/etc/.installed_su_daemon \
    #vendor/sokp/prebuilt/common/su/Superuser.apk:system/app/Superuser.apk

# statistics identity
PRODUCT_PROPERTY_OVERRIDES += \
    ro.romstats.url=http://stats.sonic-developers.com/ \
    ro.romstats.name=SOKP \
    ro.romstats.version=-$(SOKP_Version) \
    ro.romstats.askfirst=0 \
    ro.romstats.tframe=1

# SOKP Files
PRODUCT_COPY_FILES += \
    vendor/sokp/prebuilt/common/app/Audio_Fx_Widget_1.1.5-signed.apk:system/app/Audio_Fx_Widget_1.1.5-signed.apk \
    vendor/sokp/prebuilt/common/app/com.krabappel2548.dolbymobile-signed.apk:system/app/com.krabappel2548.dolbymobile-signed.apk \
    vendor/sokp/prebuilt/common/app/Hexo.apk:system/app/Hexo.apk \
    vendor/sokp/prebuilt/common/app/HexoIcons.apk:system/app/HexoIcons.apk \
    vendor/sokp/prebuilt/common/app/ApexLauncher_v2.5.0.apk:system/app/ApexLauncher_v2.5.0.apk \
    vendor/sokp/prebuilt/common/etc/fallback_fonts.xml:system/etc/fallback_fonts.xml \
    vendor/sokp/prebuilt/common/fonts/SamColorEmoji.ttf:system/fonts/SamColorEmoji.ttf 
 
