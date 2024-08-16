# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= Pixelstar

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.strictmode.disable=true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/pixelstar/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/pixelstar/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions 

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/pixelstar/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/pixelstar/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/pixelstar/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Pixelstar-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/pixelstar/prebuilt/common/etc/init/init.pixelstar-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.pixelstar-system_ext.rc

# Display
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    debug.sf.frame_rate_multiple_threshold=60 \
    ro.surface_flinger.enable_frame_rate_override=false

# Enable gestural navigation overlay to match default navigation mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural;com.google.android.systemui.gxoverlay

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable SystemUIDialog volume panel
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    sys.fflag.override.settings_volume_panel_in_systemui=true

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Google Apps
$(call inherit-product, vendor/google/gms/products/gms.mk)

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= $(TARGET_SUPPORTS_64_BIT_APPS)

ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.sense_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Skip boot JAR checks.
SKIP_BOOT_JARS_CHECK := true

# TouchGestures
PRODUCT_PACKAGES += \
    TouchGestures

# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

PRODUCT_PACKAGES += \
    BatteryStatsViewer

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model

# Wallpaper
PRODUCT_PACKAGES += \
    PixelstarWallpaperStub

# GameSpace
PRODUCT_PACKAGES += \
    GameSpace
    
# Charger
ifeq ($(USE_PIXEL_CHARGER),true)
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images \
    product_charger_res_images_vendor
endif

# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Extra tools in Pixelstar
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_PACKAGES += \
    nano_recovery

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so


# Memtag
PRODUCT_PRODUCT_PROPERTIES += \
    arm64.memtag.process.system_server=off \
    persist.arm64.memtag.app.com.android.se=off \
    persist.arm64.memtag.app.com.google.android.bluetooth=off \
    persist.arm64.memtag.app.com.android.nfc=off \
    persist.arm64.memtag.system_server=off

# Neofetch
PRODUCT_COPY_FILES += \
    vendor/pixelstar/tools/neofetch:$(TARGET_COPY_OUT_SYSTEM_EXT)/bin/neofetch

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/pixelstar/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# Disable remote keyguard animation
PRODUCT_SYSTEM_PROPERTIES += \
    persist.wm.enable_remote_keyguard_animation=0

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    NexusLauncherRelease \
    SystemUI \
    Settings

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    vendor/pixelstar/overlay \
    vendor/pixelstar/overlay/no-rro

# Cache clenaer
PRODUCT_PACKAGES += \
    init.cache_cleaner.rc \
    init.cache_cleaner.sh
    
# Protobuf - Workaround for prebuilt Qualcomm HAL
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat \
    libprotobuf-cpp-lite-3.9.1-vendorcompat
    
PRODUCT_PACKAGE_OVERLAYS += \
    vendor/pixelstar/overlay/common \
    vendor/pixelstar/overlay/no-rro

PRODUCT_PACKAGES += \
    ImmersiveNavigationOverlay

PRODUCT_PACKAGES += \
    AndroidBlackThemeOverlay \
    DocumentsUIOverlay \
    DummyCutoutOverlay \
    NoCutoutOverlay \
    AOSPASettingsOverlay 

# Transparent recents in pixel launcher
TARGET_USES_BLUR_RECENT ?= true
ifeq ($(TARGET_USES_BLUR_RECENT), true)
PRODUCT_PACKAGES += \
    PixelLauncherOverlayBlur
endif

# SystemUI Customisation
PRODUCT_PACKAGES += \
    SystemUICustomOverlay

# Settings Customisation
PRODUCT_PACKAGES += \
    SettingsCustomOverlay

# SettingsProvider Customisation
PRODUCT_PACKAGES += \
    SettingsProviderOverlay

PRODUCT_PACKAGES += \
    SystemUIFlagFlipper

# LineageHW permission
PRODUCT_COPY_FILES += \
    vendor/pixelstar/config/permissions/privapp-permissions-lineagehw.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-lineagehw.xml

# Permissions for lineage sdk services
PRODUCT_COPY_FILES += \
    vendor/pixelstar/config/permissions/org.lineageos.health.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.health.xml \
    vendor/pixelstar/config/permissions/org.lineageos.livedisplay.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.livedisplay.xml

include vendor/pixelstar/config/branding.mk

# ThemeOverlays
include packages/overlays/Themes/themes.mk

# Certification
$(call inherit-product-if-exists, vendor/certification/config.mk)

# Enable ThinLTO Source wide Conditionally.
ifeq ($(TARGET_BUILD_WITH_LTO),true)
GLOBAL_THINLTO := true
USE_THINLTO_CACHE := true
SKIP_ABI_CHECKS := true
endif

PRODUCT_COPY_FILES += \
    vendor/pixelstar//rro_overlays/partition_order.xml:$(TARGET_COPY_OUT_PRODUCT)/overlay/partition_order.xml
    
# Vendor configurations
$(call inherit-product, vendor/custom/config.mk)

# Optimisation
$(call inherit-product, vendor/pixelstar/config/common/optimisation.mk)

# Microsoft
$(call inherit-product-if-exists, vendor/microsoft/mms/products/mms.mk)

# Apps
ifeq ($(ADD_CUSTOM_APPS),true)
$(call inherit-product, vendor/apps/apps.mk)
endif

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/pixelstar/config/partner_gms.mk
