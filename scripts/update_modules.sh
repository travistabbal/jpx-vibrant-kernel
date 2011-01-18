#!/bin/bash

cd Kernel
make arch=arm -j4
find . -name *.ko -exec cp {} ../initramfs-voodoo/lib/modules/ \;
chmod 666 ../initramfs-voodoo/lib/modules/*
make arch=arm -j4 
cp arch/arm/boot/zImage ../
cd ..
ls -lh zImage

