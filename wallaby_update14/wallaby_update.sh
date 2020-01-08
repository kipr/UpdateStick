#!/bin/bash

FW_VERSION=14

###############################
#
# stop running services so updates happen faster
#
###############################
#systemctl stop harrogate.service
systemctl stop battlehill.service
systemctl stop chromium.service


###############################
#
# update boot files
#
###############################

#remount root filesystem as read write
mount -o remount,rw /

# mount boot partition
MNT_BOOT=/media/boot
if [ ! -d $MNT_BOOT ];
then
	echo "Creating directory $MNT_BOOT"
	mkdir $MNT_BOOT
fi
mount /dev/mmcblk0p1 $MNT_BOOT

UENV_TXT=${MNT_BOOT}/uEnv.txt
UENV1_TXT=${MNT_BOOT}/uEnv1.txt
UENV2_TXT=${MNT_BOOT}/uEnv2.txt

if [ ! -f $UENV_TXT ];
then
	echo "ERROR: $UENV_TXT is missing"
	exit
else
	echo "Found $UENV_TXT"
fi

# copy extra u-boot environment files
cp files/uEnv1.txt ${UENV1_TXT}
cp files/uEnv2.txt ${UENV2_TXT}

# detect current boot partition and update uEnv.txt
if grep -q "mmcroot=/dev/mmcblk0p3" $UENV_TXT
then
	# currently on partition 2
	BOOT_PART=2
        echo "currently using boot partition 2"
	cp files/uEnv2.txt $UENV_TXT
else
	# currently on partition 1
        echo "currently using boot partition 1"
	BOOT_PART=1
	cp files/uEnv1.txt $UENV_TXT
fi

sync


###############################
#
# update co-processor
#
###############################
/usr/bin/wallaby_flash files/wallaby_v5.bin


###############################
#
# update packages
#
###############################

NUM_PKGS=16
COUNT=0

# battlehill
((COUNT++))
echo "$COUNT/$NUM_PKGS  Removing battlehill..."
smart remove battlehill --quiet

# botball-versions
((COUNT++))
echo "$COUNT/$NUM_PKGS  Updating botball-versions..."
smart install pkgs/botball-versions-1.0-10.0.cortexa8hf_vfp_neon.rpm --quiet

# fonts
((COUNT++))
echo "$COUNT/$NUM_PKGS  Installing extra fonts..."
smart install pkgs/ttf-wqy-zenhei-0.6.26-r4.0.all.rpm --quiet

# libkar
((COUNT++))
echo "$COUNT/$NUM_PKGS  Installing libkar..."
smart install pkgs/libkar-git-3.0.cortexa8hf_vfp_neon.rpm --quiet

# libzbar
((COUNT++))
echo "$COUNT/$NUM_PKGS  Installing libzbar..."
smart install pkgs/libzbar0-0.10-0.20.cortexa8hf_vfp_neon.rpm --quiet

# pcompiler
((COUNT++))
echo "$COUNT/$NUM_PKGS  Installing pcompiler..."
smart install pkgs/pcompiler-git-3.0.cortexa8hf_vfp_neon.rpm --quiet

# chromium-service
((COUNT++))
echo "$COUNT/$NUM_PKGS  Removing chromium-service..."
smart remove chromium-service --quiet

# daylite
((COUNT++))
echo "$COUNT/$NUM_PKGS  Removing daylite..."
smart remove daylite --quiet

# harrogate
((COUNT++))
echo "$COUNT/$NUM_PKGS  Updating harrogate..."
smart install pkgs/harrogate-git-51.0.cortexa8hf_vfp_neon.rpm --quiet

# libwallaby
((COUNT++))
echo "$COUNT/$NUM_PKGS  Updating libwallaby..."
smart install pkgs/libwallaby-git-107.0.cortexa8hf_vfp_neon.rpm --quiet

# libwallaby-dev
((COUNT++))
echo "$COUNT/$NUM_PKGS  Updating libwallaby-dev..."
smart install pkgs/libwallaby-dev-git-107.0.cortexa8hf_vfp_neon.rpm --quiet

# wallaby-estop
((COUNT++))
echo "$COUNT/$NUM_PKGS  Updating wallaby-estop..."
smart install pkgs/wallaby-estop-git-4.0.cortexa8hf_vfp_neon.rpm --quiet

# wallaby-utility
((COUNT++))
echo "$COUNT/$NUM_PKGS  Updating wallaby-utility..."
smart install pkgs/wallaby-utility-1.0-1.5.0.cortexa8hf_vfp_neon.rpm --quiet

# wifi-ap
((COUNT++))
echo "$COUNT/$NUM_PKGS  Updating wifi-ap..."
smart install pkgs/wifi-ap-1.0-2.0.cortexa8hf_vfp_neon.rpm --quiet

# eth-usb-config
((COUNT++))
echo "$COUNT/$NUM_PKGS  Installing eth-usb-config..."
smart install pkgs/eth-usb-config-1.0-0.0.cortexa8hf_vfp_neon.rpm --quiet

# botui
((COUNT++))
echo "$COUNT/$NUM_PKGS  Updating botui..."
smart install pkgs/botui-git-19.0.cortexa8hf_vfp_neon.rpm --quiet


###############################
#
# edit misc files
#
###############################

# most recent co-processor firmware
TARGET=files/wallaby_v5.bin
echo "Copying $TARGET"
cp  $TARGET /home/root

# botball header for default template
TARGET=files/botball.h
echo "Copying $TARGET"
mkdir /usr/include/kipr
cp  $TARGET /usr/include/kipr

# xorg.conf for tslib driver
TARGET=files/10-evdev.conf
echo "Copying $TARGET"
cp  $TARGET /usr/share/X11/xorg.conf.d/10-evdev.conf

# tslib touchscreen calib
TARGET=files/pointercal
echo "Copying $TARGET"
cp  $TARGET /etc/pointercal

# g_ether module update
TARGET=files/g_ether.ko
echo "Copying $TARGET"
cp  $TARGET /lib/modules/3.18.21-custom/kernel/drivers/usb/gadget/legacy/g_ether.ko

# load g_ether by default
TARGET=/etc/modules-load.d/g_ether.conf 
echo "Configuring $TARGET"
echo "g_ether" > $TARGET

# don't load g_cdc by default
TARGET=/etc/modules-load.d/g_cdc.conf 
echo "Removing $TARGET"
rm $TARGET


###############################
#
# sync and reboot
#
###############################
echo "Finshed Wallaby Update #$FW_VERSION"
echo "Rebooting..."
sleep 3
reboot
