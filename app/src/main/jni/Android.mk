LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := SMS4JNI
LOCAL_SRC_FILES := jnisms4.cpp nenosms4.cpp inverse.s s0.s s1.s s2.s s3.s trans.s

include $(BUILD_SHARED_LIBRARY)