#!/bin/bash

cd Kernel
make arch=arm -j4
cp arch/arm/boot/zImage ../
cd ..
ls -lh zImage
