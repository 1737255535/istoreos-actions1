#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改openwrt登陆地址,把下面的 192.168.10.1 修改成你想要的就可以了
#sed -i 's/192.168.100.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i 's/OpenWrt/iStore OS/g' package/base-files/files/bin/config_generate

# ttyd 自动登录
# sed -i "s?/bin/login?/usr/libexec/login.sh?g" ${GITHUB_WORKSPACE}/openwrt/package/feeds/packages/ttyd/files/ttyd.config

# 添加自定义软件包
# echo '
# CONFIG_PACKAGE_luci-app-mosdns=y
# CONFIG_PACKAGE_luci-app-adguardhome=y
# CONFIG_PACKAGE_luci-app-openclash=y
# ' >> .config

# ============================================================================================================
# Panther X2 (RK3566) 支持
# ============================================================================================================

# 复制 Panther X2 DTS 到内核源码树
cp -f ${GITHUB_WORKSPACE}/rk35xx/rk3566-panther-x2.dts target/linux/rockchip/dts/rk3568/

# 添加 Panther X2 设备定义到 legacy.mk
cat >> target/linux/rockchip/image/legacy.mk << 'MKEOF'

define Device/panther_x2
$(call Device/Legacy/rk3566,$(1))
  DEVICE_VENDOR := Panther
  DEVICE_MODEL := X2
  DEVICE_DTS := rk3568/rk3566-panther-x2
  SUPPORTED_DEVICES += panther,x2
  DEVICE_PACKAGES += kmod-brcmfmac cypress-firmware-43455-sdio brcmfmac-nvram-43455-sdio-generic
endef
TARGET_DEVICES += panther_x2
MKEOF

echo "Panther X2 device support added successfully!"
