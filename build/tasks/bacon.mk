# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
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

# -----------------------------------------------------------------
# Pixelstar OTA update package

PIXELSTAR_TARGET_PACKAGE := $(PRODUCT_OUT)/pixelstar-$(PIXELSTAR_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

CL_CYN="\033[36m"
CL_PRP="\033[35m"

.PHONY: bacon
bacon: $(BUILT_TARGET_FILES_PACKAGE) $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(PIXELSTAR_TARGET_PACKAGE)
	$(hide) $(SHA256) $(PIXELSTAR_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(PIXELSTAR_TARGET_PACKAGE).sha256sum
	@echo -e ${CL_CYN}""${CL_CYN}
	@echo -e ${CL_PRP}""${CL_CYN}
	@echo -e ${CL_CYN}"  ____ _____  _______ _     ____ _____  _    ____   "${CL_CYN}
	@echo -e ${CL_CYN}" |  _ \_ _\ \/ / ____| |   / ___|_   _|/ \  |  _ \  "${CL_CYN}
	@echo -e ${CL_CYN}" | |_) | | \  /|  _| | |   \___ \ | | / _ \ | |_) | "${CL_CYN}
	@echo -e ${CL_CYN}" |  __/| | /  \| |___| |___ ___) || |/ ___ \|  _ <  "${CL_CYN}
	@echo -e ${CL_CYN}" |_|  |___/_/\_\_____|_____|____/ |_/_/   \_\_| \_\ "${CL_CYN}
	@echo -e ${CL_CYN}""${CL_CYN}
	echo -e ${CL_BLD}${CL_RED}"===============================-Package complete-==============================="${CL_RED}
	$(hide) ./vendor/pixelstar/tools/generate_json_build_info.sh $(TARGET_DEVICE) $(PRODUCT_OUT) pixelstar-$(PIXELSTAR_VERSION).zip $(PLATFORM_VERSION)
	echo -e ${CL_BLD}${CL_CYN}"Datetime :"${CL_PRP}" `cat $(PRODUCT_OUT)/system/build.prop | grep ro.build.date.utc | cut -d'=' -f2 | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"Size:"${CL_PRP}" `du -sh $(PIXELSTAR_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"Filehash: "${CL_PRP}" `md5sum $(PIXELSTAR_TARGET_PACKAGE) | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"Filename: "${CL_PRP} $(PIXELSTAR_TARGET_PACKAGE)${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"ID: "${CL_PRP}" `cat $(PIXELSTAR_TARGET_PACKAGE).sha256sum | awk '{print $$1}' `"${CL_RST}
	echo -e ${CL_BLD}${CL_CYN}"================================================================================"${CL_CYN}
