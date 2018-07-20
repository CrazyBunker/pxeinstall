#PXE bootloader for automatic installation of Linux OS
1.	generate.sh: downloads gentoo-minimal and syslinux and creates a working directory
2.	mkimage.sh: gets the hard disk image from two partitions / and / home, is passed in as parameters, for example mkimage.sh / dev / sdc1 / dev / sdc6
3.	unpack.sh: unpacks initramfs in the initramfs directory
4.	unsqfs.sh: unpacks the squashfs image from initramfs to the resources directory
