$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

# proprietary side of the device
$(call inherit-product-if-exists, vendor/semc/shakira/shakira-vendor.mk)


# Discard inherited values and use our own instead.
PRODUCT_NAME := E15i
PRODUCT_DEVICE := shakira
PRODUCT_MODEL := E15i

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/semc/shakira/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

-include device/semc/msm7x27-common/msm7x27.mk

PRODUCT_PACKAGES += \
    lights.shakira 

# These is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.
DEVICE_PACKAGE_OVERLAYS += device/semc/shakira/overlay

# These are the hardware-specific configuration files
PRODUCT_COPY_FILES += \
	device/semc/shakira/prebuilt/tiwlan.ini:system/etc/wifi/tiwlan.ini \
	device/semc/shakira/prebuilt/tiwlan_ap.ini:system/etc/wifi/softap/tiwlan_ap.ini \
	device/semc/shakira/prebuilt/media_profiles.xml:system/etc/media_profiles.xml \
	device/semc/msm7x27-common/prebuilt/initlogo_mdpi.rle:root/initlogo.rle \
       device/semc/shakira/prebuilt/AudioFilter.csv:system/etc/AudioFilter.csv

# Init files
PRODUCT_COPY_FILES += \
    device/semc/shakira/prebuilt/bootrec:root/sbin/bootrec 


PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=160 \

# shakira uses high-density artwork where available
PRODUCT_LOCALES += mdpi


#new charging animations
PRODUCT_COPY_FILES += \
    device/semc/shakira/prebuilt/animations/anim1.rle:system/etc/semc/chargemon/anim1.rle \
    device/semc/shakira/prebuilt/animations/anim2.rle:system/etc/semc/chargemon/anim2.rle \
    device/semc/shakira/prebuilt/animations/anim3.rle:system/etc/semc/chargemon/anim3.rle \
    device/semc/shakira/prebuilt/animations/anim4.rle:system/etc/semc/chargemon/anim4.rle \
    device/semc/shakira/prebuilt/animations/anim5.rle:system/etc/semc/chargemon/anim5.rle \
    device/semc/shakira/prebuilt/animations/anim6.rle:system/etc/semc/chargemon/anim6.rle \
    device/semc/shakira/prebuilt/animations/anim7.rle:system/etc/semc/chargemon/anim7.rle \
    device/semc/shakira/prebuilt/animations/anim8.rle:system/etc/semc/chargemon/anim8.rle 

