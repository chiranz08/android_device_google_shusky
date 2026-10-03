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
$(call inherit-product-if-exists, vendor/chiranz/config.mk)

# Pixelify
ASCP_MAINTAINER := chiranz

# GApps ship com.google.android.extservices, which disables build/make's guard and makes Soong
# demand Google-internal *.google.contributions.prebuilt modules. Build mainline from source.
PRODUCT_BUILD_IGNORE_APEX_CONTRIBUTION_CONTENTS := true

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="shiba-user 17 CP2A.260805.005 15828068 release-keys" \
    BuildFingerprint=google/shiba/shiba:17/CP2A.260805.005/15828068:user/release-keys \
    BuildSystemFingerprint=google/generic_system_google/generic:17/CP2A.260805.005/15828068:user/release-keys \
    DeviceProduct=$(DEVICE_CODENAME)

$(call inherit-product, $(VENDOR_PATH)/$(DEVICE_CODENAME)-vendor.mk)
