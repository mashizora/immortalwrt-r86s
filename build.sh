#!/bin/bash


# install dependencies
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -qq update
sudo -E apt-get -qq install libncurses5-dev libncursesw5-dev gettext xsltproc
sudo -E apt-get -qq autoremove --purge
sudo -E apt-get -qq clean


# download imagebuilder
VERSION=$(<VERSION)
IMAGEBUILDER_URL="https://downloads.immortalwrt.org/releases/$VERSION/targets/x86/64/immortalwrt-imagebuilder-$VERSION-x86-64.Linux-x86_64.tar.xz"
echo $IMAGEBUILDER_URL
curl -L $IMAGEBUILDER_URL -o imagebuilder.tar.xz
tar --xz -xf imagebuilder.tar.xz --strip-components=1
rm -f imagebuilder.tar.xz


# patch build config
sed -i '/CONFIG_ISO_IMAGES/d' .config
sed -i '/CONFIG_VDI_IMAGES/d' .config
sed -i '/CONFIG_GRUB_IMAGES/d' .config
sed -i '/CONFIG_VHDX_IMAGES/d' .config
sed -i '/CONFIG_VMDK_IMAGES/d' .config
sed -i '/CONFIG_QCOW2_IMAGES/d' .config
sed -i '/CONFIG_TARGET_ROOTFS_EXT4FS/d' .config


# build with imagebuilder
make image FILES="files" PACKAGES="luci-app-openclash"
