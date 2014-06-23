# Inherit common SOKP stuff
$(call inherit-product, vendor/sokp/config/common.mk)

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

# Include SOKP audio files
include vendor/sokp/config/cm_audio.mk

# Include SOKP LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/sokp/overlay/dictionaries

# Optional SOKP packages
PRODUCT_PACKAGES += \
    LiveWallpapersPicker \
    PhotoTable \
    SoundRecorder

# Extra tools in SOKP
PRODUCT_PACKAGES += \
    vim
