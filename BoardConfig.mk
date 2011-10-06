-include device/semc/msm7x27-common/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := shakira
TARGET_SPECIFIC_HEADER_PATH := device/semc/shakira/include

TARGET_OTA_ASSERT_DEVICE := E15i,E15a,E16i,E16a,shakira

-include device/semc/msm7x27-common/Android.mk
