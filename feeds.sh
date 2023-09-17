#!/bin/bash
# Copyright (c) 2022-2023 Curious <https://www.curious.host>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
# 
# https://github.com/Curious-r/OpenWrtBuildWorkflows
# Description: Automatically check OpenWrt source code update and build it. No additional keys are required.
#-------------------------------------------------------------------------------------------------------
#
#
# This script will run before feeds update, something you want to do at that moment should be written here.
# A common function of this script is to modify the cloned OpenWrt source code. 
#
# For instance, you can edit the feeds.conf.default to induct packages you need.
# This is followed by some editing examples.
# # Clear the feeds.conf.default and append the feed sources you need one by one:
#cat /dev/null > a.txt
#echo 'src-git-full packages https://git.openwrt.org/feed/packages.git;openwrt-22.03' >> feeds.conf.default
#echo 'src-git-full luci https://git.openwrt.org/project/luci.git;openwrt-22.03' >> feeds.conf.default
#echo 'src-git-full routing https://git.openwrt.org/feed/routing.git;openwrt-22.03' >> feeds.conf.default
#echo 'src-git-full telephony https://git.openwrt.org/feed/telephony.git;openwrt-22.03' >> feeds.conf.default
# # Replace a feed source with what you want:
#sed '/feeds-name/'d feeds.conf.default
#echo 'method feed-name path/URL' >> feeds.conf.default
# # Uncomment a feed source:
#sed -i 's/^#\(.*feed-name\)/\1/' feeds.conf.default
# # Replace src-git-full with src-git to reduce the depth of cloning:
#sed -i 's/src-git-full/src-git/g' feeds.conf.default
#
# You can also modify the source code by patching.
# # Here's a template for patching:
#touch example.patch
#cat>example.patch<<EOF
#patch content
#EOF
#git apply example.patch
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages.git;master' >> feeds.conf.default
echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main' >> feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main' >> feeds.conf.default


# 删除自定义源默认的 argon 主题
rm -rf package/lean/luci-theme-argon

# 部分第三方源自带 argon 主题，上面命令删除不掉的请运行下面命令
find ./ -name luci-theme-argon | xargs rm -rf;

# 针对 LEDE 项目拉取 argon 原作者的源码
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# 替换默认主题为 luci-theme-argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

sed -i 's/192.168.1.1/192.168.6.3/g' package/base-files/files/bin/config_generate