#!/sbin/busybox sh
# filesystem patcher
# Copyright SztupY, Licence: GPLv3

# /sbin/busybox ln -s /lib /system/lib

# initialize graphic and storage modules
/sbin/busybox insmod /modules/pvrsrvkm.ko
/sbin/busybox insmod /modules/s3c_lcd.ko
/sbin/busybox insmod /modules/s3c_bc.ko

/sbin/busybox insmod /lib/modules/fsr.ko
/sbin/busybox insmod /lib/modules/fsr_stl.ko
/sbin/busybox insmod /lib/modules/rfs_glue.ko
/sbin/busybox insmod /lib/modules/rfs_fat.ko
/sbin/busybox insmod /lib/modules/j4fs.ko
/sbin/busybox insmod /lib/modules/param.ko

/sbin/busybox mkdir /dev
/sbin/busybox mkdir /proc
/sbin/busybox mkdir /sys
/sbin/busybox mkdir /system
/sbin/busybox mkdir /data

# mount and create most of the device nodes. This is done by init, but unfortunately, we're running before init...
/sbin/busybox mount -t proc proc /proc
/sbin/busybox mount -t sysfs sys /sys

/sbin/busybox mkdir /tmp
/sbin/busybox mount -t tmpfs tmpfs /tmp

/sbin/busybox mkdir /dev/block
/sbin/busybox mkdir /dev/snd

/sbin/busybox mknod /dev/null c 1 3
/sbin/busybox mknod /dev/zero c 1 5

# internal and external sd card
/sbin/busybox mknod /dev/block/mmcblk0 b 179 0
/sbin/busybox mknod /dev/block/mmcblk0p1 b 179 1
/sbin/busybox mknod /dev/block/mmcblk0p2 b 179 2

/sbin/busybox mknod /dev/block/mmcblk1 b 179 8
/sbin/busybox mknod /dev/block/mmcblk1p1 b 179 9

# ROM blocks
/sbin/busybox mknod /dev/block/stl1 b 138 1
/sbin/busybox mknod /dev/block/stl2 b 138 2
/sbin/busybox mknod /dev/block/stl3 b 138 3
/sbin/busybox mknod /dev/block/stl4 b 138 4
/sbin/busybox mknod /dev/block/stl5 b 138 5
/sbin/busybox mknod /dev/block/stl6 b 138 6
/sbin/busybox mknod /dev/block/stl7 b 138 7
/sbin/busybox mknod /dev/block/stl8 b 138 8
/sbin/busybox mknod /dev/block/stl9 b 138 9
/sbin/busybox mknod /dev/block/stl10 b 138 10
/sbin/busybox mknod /dev/block/stl11 b 138 11
/sbin/busybox mknod /dev/block/stl12 b 138 12

# loop devices. loop0 will be unused to keep it free for mods
/sbin/busybox mknod /dev/block/loop0 b 7 0
/sbin/busybox mknod /dev/block/loop1 b 7 1
/sbin/busybox mknod /dev/block/loop2 b 7 2
/sbin/busybox mknod /dev/block/loop3 b 7 3

# framebuffer for the graphsh command if needed
/sbin/busybox mkdir /dev/graphics
/sbin/busybox mknod /dev/graphics/fb0 c 29 0
/sbin/busybox mknod /dev/graphics/fb1 c 29 1
/sbin/busybox mknod /dev/graphics/fb2 c 29 2
/sbin/busybox mknod /dev/graphics/fb3 c 29 3
/sbin/busybox mknod /dev/graphics/fb4 c 29 4

/sbin/busybox mkdir /dev/input
/sbin/busybox mknod /dev/input/event0 c 13 64
/sbin/busybox mknod /dev/input/event1 c 13 65
/sbin/busybox mknod /dev/input/event2 c 13 66
/sbin/busybox mknod /dev/input/event3 c 13 67
/sbin/busybox mknod /dev/input/mice c 13 63
/sbin/busybox mknod /dev/input/mouse0 c 13 32

# busybox is already a symlink to CWM's recovery. Now create the remaining part
# We will delete these links including the symlink to busybox post-init, so they won't interfere with the installed busybox on the device
/sbin/busybox ln -s /sbin/busybox "/sbin/["
/sbin/busybox ln -s /sbin/busybox "/sbin/[["
/sbin/busybox ln -s /sbin/recovery /sbin/amend
/sbin/busybox ln -s /sbin/busybox /sbin/ash
/sbin/busybox ln -s /sbin/busybox /sbin/awk
/sbin/busybox ln -s /sbin/busybox /sbin/basename
/sbin/busybox ln -s /sbin/busybox /sbin/bbconfig
/sbin/busybox ln -s /sbin/busybox /sbin/bunzip2
/sbin/busybox ln -s /sbin/busybox /sbin/bzcat
/sbin/busybox ln -s /sbin/busybox /sbin/bzip2
/sbin/busybox ln -s /sbin/busybox /sbin/cal
/sbin/busybox ln -s /sbin/busybox /sbin/cat
/sbin/busybox ln -s /sbin/busybox /sbin/catv
/sbin/busybox ln -s /sbin/busybox /sbin/chgrp
/sbin/busybox ln -s /sbin/busybox /sbin/chmod
/sbin/busybox ln -s /sbin/busybox /sbin/chown
/sbin/busybox ln -s /sbin/busybox /sbin/chroot
/sbin/busybox ln -s /sbin/busybox /sbin/cksum
/sbin/busybox ln -s /sbin/busybox /sbin/clear
/sbin/busybox ln -s /sbin/busybox /sbin/cmp
/sbin/busybox ln -s /sbin/busybox /sbin/cp
/sbin/busybox ln -s /sbin/busybox /sbin/cpio
/sbin/busybox ln -s /sbin/busybox /sbin/cut
/sbin/busybox ln -s /sbin/busybox /sbin/date
/sbin/busybox ln -s /sbin/busybox /sbin/dc
/sbin/busybox ln -s /sbin/busybox /sbin/dd
/sbin/busybox ln -s /sbin/busybox /sbin/depmod
/sbin/busybox ln -s /sbin/busybox /sbin/devmem
/sbin/busybox ln -s /sbin/busybox /sbin/df
/sbin/busybox ln -s /sbin/busybox /sbin/diff
/sbin/busybox ln -s /sbin/busybox /sbin/dirname
/sbin/busybox ln -s /sbin/busybox /sbin/dmesg
/sbin/busybox ln -s /sbin/busybox /sbin/dos2unix
/sbin/busybox ln -s /sbin/busybox /sbin/du
/sbin/busybox ln -s /sbin/recovery /sbin/dump_image
/sbin/busybox ln -s /sbin/busybox /sbin/echo
/sbin/busybox ln -s /sbin/busybox /sbin/egrep
/sbin/busybox ln -s /sbin/busybox /sbin/env
/sbin/busybox ln -s /sbin/recovery /sbin/erase_image
/sbin/busybox ln -s /sbin/busybox /sbin/expr
/sbin/busybox ln -s /sbin/busybox /sbin/false
/sbin/busybox ln -s /sbin/busybox /sbin/fdisk
/sbin/busybox ln -s /sbin/busybox /sbin/fgrep
/sbin/busybox ln -s /sbin/busybox /sbin/find
/sbin/busybox ln -s /sbin/recovery /sbin/flash_image
/sbin/busybox ln -s /sbin/busybox /sbin/fold
/sbin/busybox ln -s /sbin/busybox /sbin/free
/sbin/busybox ln -s /sbin/busybox /sbin/freeramdisk
/sbin/busybox ln -s /sbin/busybox /sbin/fuser
/sbin/busybox ln -s /sbin/busybox /sbin/getopt
/sbin/busybox ln -s /sbin/busybox /sbin/grep
/sbin/busybox ln -s /sbin/busybox /sbin/gunzip
/sbin/busybox ln -s /sbin/busybox /sbin/gzip
/sbin/busybox ln -s /sbin/busybox /sbin/head
/sbin/busybox ln -s /sbin/busybox /sbin/hexdump
/sbin/busybox ln -s /sbin/busybox /sbin/id
/sbin/busybox ln -s /sbin/busybox /sbin/insmod
/sbin/busybox ln -s /sbin/busybox /sbin/install
/sbin/busybox ln -s /sbin/busybox /sbin/kill
/sbin/busybox ln -s /sbin/busybox /sbin/killall
/sbin/busybox ln -s /sbin/busybox /sbin/killall5
/sbin/busybox ln -s /sbin/busybox /sbin/length
/sbin/busybox ln -s /sbin/busybox /sbin/less
/sbin/busybox ln -s /sbin/busybox /sbin/ln
/sbin/busybox ln -s /sbin/busybox /sbin/losetup
/sbin/busybox ln -s /sbin/busybox /sbin/ls
/sbin/busybox ln -s /sbin/busybox /sbin/lsmod
/sbin/busybox ln -s /sbin/busybox /sbin/lspci
/sbin/busybox ln -s /sbin/busybox /sbin/lsusb
/sbin/busybox ln -s /sbin/busybox /sbin/lzop
/sbin/busybox ln -s /sbin/busybox /sbin/lzopcat
/sbin/busybox ln -s /sbin/busybox /sbin/md5sum
/sbin/busybox ln -s /sbin/busybox /sbin/mkdir
/sbin/busybox ln -s /sbin/busybox /sbin/mkfifo
/sbin/busybox ln -s /sbin/busybox /sbin/mknod
/sbin/busybox ln -s /sbin/busybox /sbin/mkswap
/sbin/busybox ln -s /sbin/busybox /sbin/mktemp
/sbin/busybox ln -s /sbin/recovery /sbin/mkyaffs2image
/sbin/busybox ln -s /sbin/busybox /sbin/modprobe
/sbin/busybox ln -s /sbin/busybox /sbin/more
/sbin/busybox ln -s /sbin/busybox /sbin/mount
/sbin/busybox ln -s /sbin/busybox /sbin/mountpoint
/sbin/busybox ln -s /sbin/busybox /sbin/mv
/sbin/busybox ln -s /sbin/recovery /sbin/nandroid
/sbin/busybox ln -s /sbin/busybox /sbin/nice
/sbin/busybox ln -s /sbin/busybox /sbin/nohup
/sbin/busybox ln -s /sbin/busybox /sbin/od
/sbin/busybox ln -s /sbin/busybox /sbin/patch
/sbin/busybox ln -s /sbin/busybox /sbin/pgrep
/sbin/busybox ln -s /sbin/busybox /sbin/pidof
/sbin/busybox ln -s /sbin/busybox /sbin/pkill
/sbin/busybox ln -s /sbin/busybox /sbin/printenv
/sbin/busybox ln -s /sbin/busybox /sbin/printf
/sbin/busybox ln -s /sbin/busybox /sbin/ps
/sbin/busybox ln -s /sbin/busybox /sbin/pwd
/sbin/busybox ln -s /sbin/busybox /sbin/rdev
/sbin/busybox ln -s /sbin/busybox /sbin/readlink
/sbin/busybox ln -s /sbin/busybox /sbin/realpath
/sbin/busybox ln -s /sbin/recovery /sbin/reboot
/sbin/busybox ln -s /sbin/busybox /sbin/renice
/sbin/busybox ln -s /sbin/busybox /sbin/reset
/sbin/busybox ln -s /sbin/busybox /sbin/rm
/sbin/busybox ln -s /sbin/busybox /sbin/rmdir
/sbin/busybox ln -s /sbin/busybox /sbin/rmmod
/sbin/busybox ln -s /sbin/busybox /sbin/run-parts
/sbin/busybox ln -s /sbin/busybox /sbin/sed
/sbin/busybox ln -s /sbin/busybox /sbin/seq
/sbin/busybox ln -s /sbin/busybox /sbin/setsid
/sbin/busybox ln -s /sbin/busybox /sbin/sh
/sbin/busybox ln -s /sbin/busybox /sbin/sha1sum
/sbin/busybox ln -s /sbin/busybox /sbin/sha256sum
/sbin/busybox ln -s /sbin/busybox /sbin/sha512sum
/sbin/busybox ln -s /sbin/busybox /sbin/sleep
/sbin/busybox ln -s /sbin/busybox /sbin/sort
/sbin/busybox ln -s /sbin/busybox /sbin/split
/sbin/busybox ln -s /sbin/busybox /sbin/stat
/sbin/busybox ln -s /sbin/busybox /sbin/strings
/sbin/busybox ln -s /sbin/busybox /sbin/stty
/sbin/busybox ln -s /sbin/busybox /sbin/swapoff
/sbin/busybox ln -s /sbin/busybox /sbin/swapon
/sbin/busybox ln -s /sbin/busybox /sbin/sync
/sbin/busybox ln -s /sbin/busybox /sbin/sysctl
/sbin/busybox ln -s /sbin/busybox /sbin/tac
/sbin/busybox ln -s /sbin/busybox /sbin/tail
/sbin/busybox ln -s /sbin/busybox /sbin/tar
/sbin/busybox ln -s /sbin/busybox /sbin/tee
/sbin/busybox ln -s /sbin/busybox /sbin/test
/sbin/busybox ln -s /sbin/busybox /sbin/time
/sbin/busybox ln -s /sbin/busybox /sbin/top
/sbin/busybox ln -s /sbin/busybox /sbin/touch
/sbin/busybox ln -s /sbin/busybox /sbin/tr
/sbin/busybox ln -s /sbin/busybox /sbin/true
/sbin/busybox ln -s /sbin/recovery /sbin/truncate
/sbin/busybox ln -s /sbin/busybox /sbin/tty
/sbin/busybox ln -s /sbin/busybox /sbin/umount
/sbin/busybox ln -s /sbin/busybox /sbin/uname
/sbin/busybox ln -s /sbin/busybox /sbin/uniq
/sbin/busybox ln -s /sbin/busybox /sbin/unix2dos
/sbin/busybox ln -s /sbin/busybox /sbin/unlzop
/sbin/busybox ln -s /sbin/recovery /sbin/unyaffs
/sbin/busybox ln -s /sbin/busybox /sbin/unzip
/sbin/busybox ln -s /sbin/busybox /sbin/uptime
/sbin/busybox ln -s /sbin/busybox /sbin/usleep
/sbin/busybox ln -s /sbin/busybox /sbin/uudecode
/sbin/busybox ln -s /sbin/busybox /sbin/uuencode
/sbin/busybox ln -s /sbin/busybox /sbin/watch
/sbin/busybox ln -s /sbin/busybox /sbin/wc
/sbin/busybox ln -s /sbin/busybox /sbin/which
/sbin/busybox ln -s /sbin/busybox /sbin/whoami
/sbin/busybox ln -s /sbin/busybox /sbin/xargs
/sbin/busybox ln -s /sbin/busybox /sbin/yes
/sbin/busybox ln -s /sbin/busybox /sbin/zcat

PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

# umount everything to be sure
echo Unmounting filesystems
# cache
/sbin/busybox umount /dev/block/stl11
# dbdata
/sbin/busybox umount /dev/block/stl10
# data
/sbin/busybox umount /dev/block/mmcblk0p2

# create mount points
echo Creating mount points
/sbin/busybox mkdir /cache
/sbin/busybox mkdir /dbdata
/sbin/busybox mkdir /data
/sbin/busybox mkdir /system
# this will hold the original partitions
/sbin/busybox mkdir /res/odbdata
/sbin/busybox mkdir /res/odata
/sbin/busybox mkdir /res/ocache
/sbin/busybox chmod 700 /res/odbdata
/sbin/busybox chmod 700 /res/odata
/sbin/busybox chmod 700 /res/ocache

# mount and check /system. Some modules are needed from /system/lib
echo Checking /system

# if mounting system fails this will allow adb to run
/sbin/busybox mkdir /system
/sbin/busybox mkdir /system/bin
/sbin/busybox ln /sbin/recovery /system/bin/sh

# first try it as rfs
SYSTEM_FS_TYPE=rfs
/sbin/busybox mount -t rfs /dev/block/stl9 /system

if /sbin/busybox [ -z "`/sbin/busybox mount | /sbin/busybox grep /dev/block/stl9 | /sbin/busybox grep rfs`" ]; then
  /sbin/fsck.ext4 -p /dev/block/stl9
  /sbin/busybox mount -t ext4 /dev/block/stl9 /system
  SYSTEM_FS_TYPE=ext4
fi
/sbin/busybox rm /system/bin/fat.format

/sbin/busybox ln -s /system/etc /etc
cp /res/misc/mke2fs.conf /etc

DATA_FS_TYPE=rfs
CACHE_FS_TYPE=rfs
DBDATA_FS_TYPE=rfs
BIND_DATA_TO_DBDATA=false
DATA_LOOP=false
CACHE_LOOP=false
DBDATA_LOOP=false
echo checking filesystem and creating lagfix config
# jfs needs to checked or else it won't mount
fsck.jfs -p /dev/block/mmcblk0p2
fsck.jfs -p /dev/block/stl10
fsck.jfs -p /dev/block/stl11
# we don't vant rfs get mounted in vfat mode, as it might break things
/sbin/busybox mount -t rfs -o nosuid,nodev,check=no /dev/block/mmcblk0p2 /data
/sbin/busybox mount -t rfs -o nosuid,nodev,check=no /dev/block/stl10 /dbdata
/sbin/busybox mount -t rfs -o nosuid,nodev,check=no /dev/block/stl11 /cache
# all other filesystems can detect themselves
/sbin/busybox mount /dev/block/mmcblk0p2 /data
/sbin/busybox mount /dev/block/stl10 /dbdata
/sbin/busybox mount /dev/block/stl11 /cache

# params $1 blockname
filesystem_check() {
  CHECK_RESULT=rfs
  if /sbin/busybox [ "`/sbin/busybox mount | /sbin/busybox grep $1 | /sbin/busybox grep jfs`" ]; then
    CHECK_RESULT=jfs
  fi

  if /sbin/busybox [ "`/sbin/busybox mount | /sbin/busybox grep $1 | /sbin/busybox grep ext[24]`" ]; then
    CHECK_RESULT=ext4
  fi
}

filesystem_check /dev/block/mmcblk0p2
DATA_FS_TYPE=$CHECK_RESULT
filesystem_check /dev/block/stl10
DBDATA_FS_TYPE=$CHECK_RESULT
filesystem_check /dev/block/stl11
CACHE_FS_TYPE=$CHECK_RESULT

echo check for loop files
if /sbin/busybox [ -f "/data/.extfs" ]; then
  DATA_LOOP=ext2
fi
if /sbin/busybox [ -f "/dbdata/.extfs" ]; then
  DBDATA_LOOP=ext2
fi
if /sbin/busybox [ -f "/cache/.extfs" ]; then
  CACHE_LOOP=ext2
fi

echo check for bind mounts
# if dbdata has a loop device bind to that
if /sbin/busybox [ $DBDATA_LOOP == "ext2" ]; then
  /sbin/busybox mkdir /testtmp
  /sbin/busybox losetup /dev/block/loop0 /dbdata/.extfs
  /sbin/busybox mount /dev/block/loop0 /testtmp
  if /sbin/busybox [ -d "/testtmp/.data" ]; then
    BIND_DATA_TO_DBDATA=data
  fi
  /sbin/busybox umount /testtmp
  /sbin/busybox losetup -d /dev/block/loop0
  /sbin/busybox rmdir /testtmp
else
  if /sbin/busybox [ -d "/dbdata/.data" ]; then
    BIND_DATA_TO_DBDATA=data
  fi
fi;

/sbin/busybox echo -e -n "DATA_FS=$DATA_FS_TYPE\nCACHE_FS=$CACHE_FS_TYPE\nDBDATA_FS=$DBDATA_FS_TYPE\nDATA_LOOP=$DATA_LOOP\nCACHE_LOOP=$CACHE_LOOP\nDBDATA_LOOP=$DBDATA_LOOP\nBIND_DATA_TO_DBDATA=$BIND_DATA_TO_DBDATA\n" > /system/etc/lagfix.conf.old
if /sbin/busybox [ ! -f "/system/etc/lagfix.conf" ]; then
  /sbin/busybox cat /system/etc/lagfix.conf.old > /system/etc/lagfix.conf
fi
echo The actual config is:
/sbin/busybox cat /system/etc/lagfix.conf.old
/sbin/busybox umount /data
/sbin/busybox umount /dbdata
/sbin/busybox umount /cache

# mounts a block device, and formats it to jfs or ext2/4 if needed
# params: $1 block $2 mount point $3 format to
mount_block() {
  echo "Trying to mount $1 to $2"
  /sbin/busybox mount -t $3 $1 $2
  if /sbin/busybox [ -z "`/sbin/busybox mount | /sbin/busybox grep $1 | /sbin/busybox grep $3`" ]; then
    echo Could not mount as $3. First trying to fsck it, maybe its corrigable
    /sbin/busybox umount $1
    /sbin/fsck.$3 -p $1
    /sbin/busybox mount -t $3 $1 $2
    if /sbin/busybox [ -z "`/sbin/busybox mount | /sbin/busybox grep $1 | /sbin/busybox grep $3`" ]; then
      echo Still doesnt work. Destroy and re-create it
      /sbin/busybox touch /res/fatal.error
      /sbin/busybox umount $1
      /sbin/mkfs.$3 $1
    else
      echo It works now, umount it
      /sbin/busybox umount $1
    fi;
  else
    echo Run a filesystem check on it
    /sbin/busybox umount $1
    /sbin/fsck.$3 -p $1
  fi;
}

# mounts a loop device on another block
# params: $1 block $2 mount point of block $3 name of loop device $4 mount point of loop device $5 size of desired file $6 filesystem
mount_loop() {
  echo "Trying to mount $1 to $2"
  /sbin/busybox mount -t $6 $1 $2
  if /sbin/busybox [ -z "`/sbin/busybox mount | /sbin/busybox grep $1 | /sbin/busybox grep $6`" ]; then
    echo "Something went very wrong while mounting $1 $2 $3 $4 $5 $6"
    /sbin/busybox touch /res/fatal.error
  else
    echo "Checking for the loop file"
    if /sbin/busybox [ ! -f "$2/.extfs" ]; then
      echo "Loop file not found, creating it"
      /sbin/busybox touch "$2/.extfs"
      /sbin/busybox truncate "$2/.extfs" $5
    fi;
    echo "Loop device $3 setup"
    /sbin/busybox losetup $3 "$2/.extfs"
    echo "Initialising filesystem on $3"
    mount_block $3 $4 ext2
  fi;
}

# mounts the device for real now
# params: $1 block_normal $2 block_loop $3 point_normal $4 point_loop $5 fs_type $6 loop_type
final_mount() {
  if /sbin/busybox [ $5 == "rfs" ]; then
    if /sbin/busybox [ $6 == "ext2" ]; then
      /sbin/busybox mount -t ext2 -o noatime,nodiratime $2 $3
    else
      /sbin/busybox mount -t rfs -o nosuid,nodev,check=no $1 $3
    fi
  else
    if /sbin/busybox [ $6 == "ext2" ]; then
      /sbin/busybox mount -t ext2 -o noatime,nodiratime $2 $3
    else
      if /sbin/busybox [ $5 == "ext2" ]; then
        /sbin/busybox mount -t ext2 -o noatime,nodiratime $1 $3
      elif /sbin/busybox [ $5 == "ext4" ]; then
        /sbin/busybox mount -t ext4 -o noatime,barrier=0,noauto_da_alloc $1 $3
      else
        /sbin/busybox mount -t jfs -o noatime,nodiratime,errors=continue $1 $3
      fi
    fi
  fi
}

if /sbin/busybox [ "`/sbin/busybox diff /system/etc/lagfix.conf /system/etc/lagfix.conf.old`" ]; then
  echo Configs differ, load the lagfixer
  /sbin/busybox diff /system/etc/lagfix.conf /system/etc/lagfix.conf.old
  /sbin/busybox ln -s /sbin/recovery /sbin/lagfixer
  /sbin/busybox ln -s /sbin/recovery /sbin/graphchoice
  /sbin/busybox mkdir -p /mnt/sdcard
  /sbin/busybox ln -s /mnt/sdcard /sdcard
  /sbin/busybox ln -s /sbin/recovery /sbin/reboot
  echo "Starting choice app"
  /sbin/graphchoice "Configs differ. Continue with conversion?" "Yes, with backup and restore" "Yes, with factory reset after backup" "Yes, with factory reset without backup" "No, enter recovery mode" "No, remove the new config"
  RESULT=$?
  echo "Choice was: $RESULT"
  LFOPTS="br"
  if /sbin/busybox [ $RESULT == "1" ]; then
    RESULT="0"
    LFOPTS="b"
  fi
  if /sbin/busybox [ $RESULT == "2" ]; then
    RESULT="0"
    LFOPTS="fr"
  fi
  if /sbin/busybox [ $RESULT == "0" ]; then
    /sbin/lagfixer $LFOPTS > /res/lagfix.log 2>&1
    /sbin/busybox sleep 5
    # only reboot if we're not in recovery mode for debug purposes
    if /sbin/busybox [ -z "`/sbin/busybox grep 'bootmode=2' /proc/cmdline`" ]; then
      /sbin/busybox cp /res/pre-init.log /sdcard/
      /sbin/busybox cp /res/lagfix.log /sdcard/
      /sbin/reboot -f
    fi
  else
    if /sbin/busybox [ $RESULT == "4" ]; then
      rm /system/etc/lagfix.conf
      rm /system/etc/lagfix.conf.old
      /sbin/reboot recovery
    fi
    if /sbin/busybox [ -z "`/sbin/busybox grep 'bootmode=2' /proc/cmdline`" ]; then
      /sbin/recovery
      /sbin/reboot recovery
    fi
  fi
else
  echo "Configs are the same, load up the mounts"

  echo running filesystem checks
  # mount everything non-rfs to see they are fine
  if /sbin/busybox [ $DATA_FS_TYPE != "rfs" ]; then
    mount_block /dev/block/mmcblk0p2 /res/odata $DATA_FS_TYPE
  fi
  if /sbin/busybox [ $DBDATA_FS_TYPE != "rfs" ]; then
    mount_block /dev/block/stl10 /res/odbdata $DBDATA_FS_TYPE
  fi
  if /sbin/busybox [ $CACHE_FS_TYPE != "rfs" ]; then
    mount_block /dev/block/stl11 /res/ocache $CACHE_FS_TYPE
  fi

  # mount loop devices
  if /sbin/busybox [ $DATA_LOOP == "ext2" ]; then
    mount_loop /dev/block/mmcblk0p2 /res/odata /dev/block/loop1 /data 1831634944 $DATA_FS_TYPE
  fi
  if /sbin/busybox [ $DBDATA_LOOP == "ext2" ]; then
    mount_loop /dev/block/stl10 /res/odbdata /dev/block/loop2 /dbdata 128382976 $DBDATA_FS_TYPE
  fi
  if /sbin/busybox [ $CACHE_LOOP == "ext2" ]; then
    mount_loop /dev/block/stl11 /res/ocache /dev/block/loop3 /cache 29726720 $CACHE_FS_TYPE
  fi

  final_mount /dev/block/mmcblk0p2 /dev/block/loop1 /data /res/odata $DATA_FS_TYPE $DATA_LOOP
  final_mount /dev/block/stl10 /dev/block/loop2 /dbdata /res/odbdata $DBDATA_FS_TYPE $DBDATA_LOOP
  final_mount /dev/block/stl11 /dev/block/loop3 /cache /res/ocache $CACHE_FS_TYPE $CACHE_LOOP

  # create mount bindings
  if /sbin/busybox [ $BIND_DATA_TO_DBDATA == "data" ]; then
    /sbin/busybox mkdir /data/data
    #/sbin/busybox mkdir /data/dalvik-cache
    /sbin/busybox mount -o bind /dbdata/.data/data /data/data
    #/sbin/busybox mount -o bind /dbdata/.data/dalvik-cache /data/dalvik-cache
  fi
fi
