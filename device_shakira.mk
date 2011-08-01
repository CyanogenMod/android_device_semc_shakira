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

PRODUCT_PACKAGES += \
    mount_system \
    hostap \
    librs_jni \
    gralloc.shakira \
    copybit.shakira \
    gps.shakira \
    lights.shakira \
    libOmxCore \
    libmm-omxcore \
    com.android.future.usb.accessory


PRODUCT_SPECIFIC_DEFINES += TARGET_PRELINKER_MAP=$(TOP)/device/semc/shakira/prelink-linux-arm-x8.map

# These is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.
DEVICE_PACKAGE_OVERLAYS += device/semc/shakira/overlay

# These are the hardware-specific configuration files
PRODUCT_COPY_FILES += \
	device/semc/shakira/prebuilt/media_profiles.xml:system/etc/media_profiles.xml \
	device/semc/shakira/prebuilt/gps.conf:system/etc/gps.conf 

# Init files
PRODUCT_COPY_FILES += \
    device/semc/shakira/prebuilt/init.delta.rc:root/init.delta.rc \
    device/semc/shakira/prebuilt/ueventd.delta.rc:root/ueventd.delta.rc \
    device/semc/shakira/prebuilt/hw_config.sh:system/etc/hw_config.sh \
    device/semc/shakira/prebuilt/bootrec:root/sbin/bootrec \
    device/semc/shakira/recovery.fstab:root/recovery.fstab \
    device/semc/shakira/prebuilt/vold.fstab:system/etc/vold.fstab \
    device/semc/shakira/prebuilt/initlogo.rle:root/initlogo.rle \

    
#xrecovery
PRODUCT_COPY_FILES += \
    device/semc/shakira/prebuilt/chargemon:system/bin/chargemon \
    device/semc/shakira/prebuilt/ramdisk.tar:system/bin/ramdisk.tar \
    device/semc/shakira/prebuilt/sh:system/xbin/sh

#WIFI modules and configs
PRODUCT_COPY_FILES += \
    device/semc/shakira/prebuilt/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    device/semc/shakira/prebuilt/hostapd.conf:system/etc/wifi/softap/hostapd.conf \
    device/semc/shakira/prebuilt/tiwlan_ap.ini:system/etc/wifi/softap/tiwlan_ap.ini \
    device/semc/shakira/modules/sdio.ko:system/lib/modules/sdio.ko \
    device/semc/shakira/modules/tiwlan_drv.ko:system/lib/modules/tiwlan_drv.ko
#    device/semc/shakira/modules/tiap_drv.ko:system/lib/modules/tiap_drv.ko \

#recovery resources
PRODUCT_COPY_FILES += \
    bootable/recovery/res/images/icon_clockwork.png:root/res/images/icon_clockwork.png \
    bootable/recovery/res/images/icon_error.png:root/res/images/icon_error.png \
    bootable/recovery/res/images/icon_installing.png:root/res/images/icon_installing.png \
    bootable/recovery/res/images/indeterminate1.png:root/res/images/indeterminate1.png \
    bootable/recovery/res/images/indeterminate2.png:root/res/images/indeterminate2.png \
    bootable/recovery/res/images/indeterminate3.png:root/res/images/indeterminate3.png \
    bootable/recovery/res/images/indeterminate4.png:root/res/images/indeterminate4.png \
    bootable/recovery/res/images/indeterminate5.png:root/res/images/indeterminate5.png \
    bootable/recovery/res/images/indeterminate6.png:root/res/images/indeterminate6.png \
    bootable/recovery/res/images/progress_empty.png:root/res/images/progress_empty.png \
    bootable/recovery/res/images/progress_fill.png:root/res/images/progress_fill.png

PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

#Kernel modules
PRODUCT_COPY_FILES += \
    device/semc/shakira/modules/ax8_smartass.ko:system/lib/modules/ax8_smartass.ko \
    device/semc/shakira/modules/x8mddi.ko:system/lib/modules/x8mddi.ko \
    device/semc/shakira/modules/dm-mod.ko:system/lib/modules/dm-mod.ko \
    device/semc/shakira/modules/dm-crypt.ko:system/lib/modules/dm-crypt.ko \
    device/semc/shakira/modules/twofish.ko:system/lib/modules/twofish.ko \
    device/semc/shakira/modules/twofish_common.ko:system/lib/modules/twofish_common.ko 

#crappy headset
PRODUCT_COPY_FILES += \
    vendor/semc/shakira/proprietary/hal_seport.default.so:system/lib/hw/hal_seport.shakira.so \
    device/semc/shakira/prebuilt/SystemConnector.apk:system/app/SystemConnector.apk \
    vendor/semc/shakira/proprietary/libuinputdevicejni.so:system/lib/libsystemconnector/libuinputdevicejni.so \
    vendor/semc/shakira/proprietary/libsystemconnector_hal_jni.so:system/lib/libsystemconnector_hal_jni.so 


PRODUCT_COPY_FILES += \
    device/semc/shakira/prebuilt/AutoVolumeControl.txt:system/etc/AutoVolumeControl.txt \
    device/semc/shakira/prebuilt/AudioFilter.csv:system/etc/AudioFilter.csv

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


PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/lib/libril-qc-1.so \
    rild.libargs=-d/dev/smd0 \
    ro.ril.hsxpa=1 \
    ro.ril.gprsclass=10 \
    ro.telephony.default_network=0 \
    ro.telephony.call_ring.multiple=false \
    wifi.interface=tiwlan0 \
    wifi.supplicant_scan_interval=15 \
    ro.sf.lcd_density=160 \
    ro.sf.hwrotation=180 \
    keyguard.no_require_sim=true \
    ro.com.google.locationfeatures=1 \
    dalvik.vm.dexopt-flags=m=y \
    dalvik.vm.heapsize=24m \
    dalvik.vm.dexopt-data-only=1 \
    dalvik.vm.lockprof.threshold=500 \
    dalvik.vm.execution-mode=int:jit \
    dalvik.vm.checkjni=false \
    ro.kernel.android.checkjni=0 \
    ro.opengles.version=131072  \
    ro.compcache.default=0 \
    ro.product.locale.language=en \
    ro.product.locale.region=US \
    BUILD_UTC_DATE=0

# shakira uses high-density artwork where available
#PRODUCT_LOCALES += mdpi

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise


