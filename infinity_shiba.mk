#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: The Calyx Institute
# SPDX-License-Identifier: Apache-2.0
#
# Project Infinity X product for Pixel 8 (shiba), adapted from lineage_shiba.mk.

# Inherit some common stuff
$(call inherit-product, vendor/infinity/config/common_full_phone.mk)

# Inherit device configuration
DEVICE_CODENAME := shiba
DEVICE_PATH := device/google/shusky
VENDOR_PATH := vendor/google/shiba
$(call inherit-product, $(DEVICE_PATH)/aosp_$(DEVICE_CODENAME).mk)

# Device identifier. This must come after all inclusions
PRODUCT_NAME := infinity_$(DEVICE_CODENAME)
PRODUCT_SYSTEM_BRAND := google
PRODUCT_SYSTEM_MANUFACTURER := Google
PRODUCT_SYSTEM_NAME := generic_system_google

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Google face unlock instead of the ROM's software one. Must be set here: the product makefile is
# parsed before vendor/infinity/config/common.mk, which only adds FaceUnlock if this isn't false.
TARGET_FACE_UNLOCK_SUPPORTED := false
$(call inherit-product-if-exists, vendor/google/faceunlock/config.mk)

# Google Camera (overrides Aperture)
$(call inherit-product-if-exists, vendor/google/camera/camera.mk)

# Our shared additions. Infinity's GApps don't ship the Pixel Launcher APK.
CHIRANZ_PIXEL_LAUNCHER := true
CHIRANZ_JAMESDSP := true
CHIRANZ_POWERINSIGHT := true
CHIRANZ_GOOGLE_STOCK := true
CHIRANZ_FIREWALL := true
$(call inherit-product-if-exists, vendor/chiranz/config.mk)

# Infinity X
INFINITY_MAINTAINER := chiranz
TARGET_HAS_UDFPS := true
WITH_GAPPS := true
# About-phone props (values with spaces) live in shiba/system.prop.

# GApps ship com.google.android.extservices, which disables build/make's guard and makes Soong
# demand Google-internal *.google.contributions.prebuilt modules. Build mainline from source.
PRODUCT_BUILD_IGNORE_APEX_CONTRIBUTION_CONTENTS := true

# zuma's aosp_common.mk enforces generic_system artifact paths (relaxed). These are the exact
# system files Infinity/GApps add on top; listed explicitly so the check stays meaningful.
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/apex/com.google.android.extservices.apex \
    system/etc/permissions/privapp-permissions-google.xml \
    system/media/bootanimation.zip \
    system/app/GoogleExtShared/GoogleExtShared.apk \
    system/app/GooglePrintRecommendationService/GooglePrintRecommendationService.apk \
    system/lib64/libtensorflowlite_gpu_jni.so \
    system/lib64/libtensorflowlite_jni.so \
    system/priv-app/OmniStyle/OmniStyle.apk \
    system/priv-app/TagGoogle/TagGoogle.apk

# vendor/infinity has no Lineage version vars; build_kernel uses them to pick the
# LineageOS kernel manifest branch (lineage-24.0).
PRODUCT_VERSION_MAJOR := 24
PRODUCT_VERSION_MINOR := 0

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="shiba-user 17 CP2A.260805.005 15828068 release-keys" \
    BuildFingerprint=google/shiba/shiba:17/CP2A.260805.005/15828068:user/release-keys \
    BuildSystemFingerprint=google/generic_system_google/generic:17/CP2A.260805.005/15828068:user/release-keys \
    DeviceProduct=$(DEVICE_CODENAME)

$(call inherit-product, $(VENDOR_PATH)/$(DEVICE_CODENAME)-vendor.mk)
