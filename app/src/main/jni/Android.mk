LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := SMS4JNI
LOCAL_SRC_FILES := jnisms4.cpp sms4.cpp

include $(BUILD_SHARED_LIBRARY)