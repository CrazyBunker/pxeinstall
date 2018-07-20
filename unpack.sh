#!/bin/bash
rm -rf initramfs
mkdir -p initramfs
cat $1 |gzip -d -9|sudo cpio -i --directory=initramfs
