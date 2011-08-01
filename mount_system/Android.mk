# mount_system 
# This executable is used to mount the /system partition
# Author: nobodyAtall @ xda

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
MY_LOCAL_PATH := $(LOCAL_PATH)
LOCAL_SRC_FILES := mtdutils.c
LOCAL_MODULE := mount_system
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES += libstdc++ libc
LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)

