# Copyright (C) 2016-2017 AOSiP
# Copyright (C) 2020 Fluid
# Copyright (C) 2021 Pixelstar
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Versioning System
PIXELSTAR_CODENAME := uday
PIXELSTAR_NUM_VER := 3.6-LTS

TARGET_PRODUCT_SHORT := $(subst pixelstar_,,$(PIXELSTAR_BUILD_TYPE))

PIXELSTAR_BUILD_TYPE ?= unofficial

# Only include Updater for official  build
ifeq ($(filter-out official,$(PIXELSTAR_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        Updater

PRODUCT_COPY_FILES += \
    vendor/pixelstar/prebuilt/common/etc/init/init.pixelstar-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.pixelstar-updater.rc
endif

# Signing
ifneq (eng,$(TARGET_BUILD_VARIANT))
ifneq (,$(wildcard vendor/pixelstar/signing/keys/releasekey.pk8))
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/pixelstar/signing/keys/releasekey
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
endif
ifneq (,$(wildcard vendor/pixelstar/signing/keys/otakey.x509.pem))
PRODUCT_OTA_PUBLIC_KEYS := vendor/pixelstar/signing/keys/otakey.x509.pem
endif
endif

# Set all versions
BUILD_DATE := $(shell date -u +%Y%m%d)
BUILD_TIME := $(shell date -u +%H%M)
PIXELSTAR_BUILD_VERSION := $(PIXELSTAR_NUM_VER)-$(PIXELSTAR_CODENAME)
PIXELSTAR_VERSION := $(PIXELSTAR_BUILD_VERSION)-$(PIXELSTAR_BUILD)-$(PIXELSTAR_BUILD_TYPE)-$(BUILD_TIME)-$(BUILD_DATE)
ROM_FINGERPRINT := pixelstar/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(BUILD_TIME)
PIXELSTAR_DISPLAY_VERSION := $(PIXELSTAR_VERSION)
RELEASE_TYPE := $(PIXELSTAR_BUILD_TYPE)
