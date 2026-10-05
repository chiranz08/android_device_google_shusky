#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: The Calyx Institute
# SPDX-License-Identifier: Apache-2.0
#
# Pixelify-AOSP (ASCP) product for Pixel 8 (shiba), adapted from lineage_shiba.mk.
# Pixelify has no vendor/lineage; it inherits vendor/custom instead.

# Inherit some common stuff
$(call inherit-product, vendor/custom/config/common_full_phone.mk)

# Inherit device configuration
DEVICE_CODENAME := shiba
DEVICE_PATH := device/google/shusky
VENDOR_PATH := vendor/google/shiba
$(call inherit-product, $(DEVICE_PATH)/aosp_$(DEVICE_CODENAME).mk)

# Device identifier. This must come after all inclusions
PRODUCT_NAME := ascp_$(DEVICE_CODENAME)
PRODUCT_SYSTEM_BRAND := google
PRODUCT_SYSTEM_MANUFACTURER := Google
PRODUCT_SYSTEM_NAME := generic_system_google

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Google face unlock instead of the ROM's software one (ParanoidSense). Must be set here: the
# product makefile is parsed before vendor/custom/config/common.mk, which uses ?=.
TARGET_FACE_UNLOCK_SUPPORTED := false
$(call inherit-product-if-exists, vendor/google/faceunlock/config.mk)

# Google Camera (overrides Aperture)
$(call inherit-product-if-exists, vendor/google/camera/camera.mk)

# Our shared additions. Pixelify's GApps don't ship the Pixel Launcher APK.
CHIRANZ_PIXEL_LAUNCHER := true
CHIRANZ_JAMESDSP := true
CHIRANZ_GOOGLE_STOCK := true
CHIRANZ_GAPPS_SET := true
CHIRANZ_CLEAR_CALLING := true
$(call inherit-product-if-exists, vendor/chiranz/config.mk)

# Pixelify
ASCP_MAINTAINER := chiranz

# GApps ship com.google.android.extservices, which disables build/make's guard and makes Soong
# demand Google-internal *.google.contributions.prebuilt modules. Build mainline from source.
PRODUCT_BUILD_IGNORE_APEX_CONTRIBUTION_CONTENTS := true

# zuma's aosp_common.mk enforces generic_system artifact paths (relaxed). Exact system files
# Pixelify/GApps add. The second group failed the Make-stage check on the 2026-09-27 ASCP build of
# this same manifest (3d6c1ba); listed up front to avoid a rebuild round per stage.
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/apex/com.google.android.extservices.apex \
    system/app/GoogleExtShared/GoogleExtShared.apk \
    system/app/GooglePrintRecommendationService/GooglePrintRecommendationService.apk \
    system/priv-app/DocumentsUIGoogle/DocumentsUIGoogle.apk \
    system/priv-app/TagGoogle/TagGoogle.apk \
    system/etc/init/custom-ota.rc \
    system/etc/init/init.openssh.rc \
    system/etc/init/keystore-compat.rc \
    system/etc/permissions/privapp-permissions-google.xml \
    system/etc/permissions/privapp_allowlist_com.google.android.ext.services.xml \
    system/etc/sysconfig/custom-power-whitelist.xml

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="shiba-user 17 CP2A.260805.005 15828068 release-keys" \
    BuildFingerprint=google/shiba/shiba:17/CP2A.260805.005/15828068:user/release-keys \
    BuildSystemFingerprint=google/generic_system_google/generic:17/CP2A.260805.005/15828068:user/release-keys \
    DeviceProduct=$(DEVICE_CODENAME)

$(call inherit-product, $(VENDOR_PATH)/$(DEVICE_CODENAME)-vendor.mk)
