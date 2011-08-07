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

# These is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.
DEVICE_PACKAGE_OVERLAYS += device/semc/shakira/overlay

# These are the hardware-specific configuration files
PRODUCT_COPY_FILES += \
	device/semc/shakira/prebuilt/media_profiles.xml:system/etc/media_profiles.xml 

# Init files
PRODUCT_COPY_FILES += \
    device/semc/shakira/prebuilt/bootrec:root/sbin/bootrec 

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=160 \

# shakira uses high-density artwork where available
PRODUCT_LOCALES += mdpi



