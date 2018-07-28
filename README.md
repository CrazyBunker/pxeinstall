# PXE bootloader for automatic installation of Linux OS, description on [site author](https://vlad.krasnodar-it-service.ru)
1.	generate.sh: downloads gentoo-minimal and syslinux and creates a working directory
2.	mkimage.sh: gets the hard disk image from two partitions / and / home, is passed in as parameters, for example mkimage.sh / dev / sdc1 / dev / sdc6
3.	unsqfs.sh: unpacks the squashfs image from initramfs to the resources directory
4.  config.cfg: configuration file
5.  mkautostart.sh: add command in /root/.bashrc for mount share disk and run script auto parted disk
6.  mkpxeboot.sh: create tar archive with tftp boot
7.  pack_image.sh: build image
8.  prepare.sh: install package
# config.cfg  
  #### Directory for tftp  
  tftproot="tftp"  
  #### Path to iso image gentoo-minimal  
  image="source/install-x86-minimal-20180718T214502Z.iso"  
  archivesqfs="source/squashfs-tools-4.3-x86_64-1.txz  
  #### Path to tmp directory  
  tmp="./tmp"  
  #### Path to temporary iso gentoo minimal  
  iso="$tmp/iso"  
  #### Path to temporary initrd directory   
  initrd="$tmp/initrd.dir"  
  #### Auto mode, run prepare.sh, mkautostart.sh, pack_image.sh  
  auto=1  
 # Generate tftp
 To create the kernel and the initrd image, create the source directory, place the gentoo-minimal image, the slackware squashfs-tool package, the script provides an automatic mode (in the "auto" config file), it starts the decompression of the necessary components from gentoo-minimal, dissects and packs into a new image.
In manual mode, run generate.sh (create the tmp directory) then prepare.sh (install the squashfs-tools package), then mkautostart.sh (Add the necessary items in .bashrc), at the end of pack_image.sh, it will create gentoo and initramfs.gz
# script.sh
  script.sh - script auto-markup, unpacking squashfs images and generating a boot record
