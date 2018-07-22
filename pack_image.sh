#!/bin/bash -xe
source ./config.cfg
sudo mksquashfs $tmp/root $tmp/image.squashfs
cp "$tmp/image.squashfs" "$initrd/mnt/cdrom"
( cd "$initrd" && find . -print | cpio -o -H newc | gzip -9 -c - ) > "$tmp/initramfs.gz"

# prepare boot data
if [ ! -d $tftproot/pxelinux.cfg ]; then
 mkdir -p "$tftproot/pxelinux.cfg"
fi
cat > "$tftproot/pxelinux.cfg/default" <<'EOF'
default Gentoo
label Gentoo
kernel gentoo
append initrd=initramfs.gz root=/dev/ram0 init=/linuxrc loop=image.squashfs looptype=squashfs cdroot=1 real_root=/
EOF
cp "$tmp"/{gentoo,initramfs.gz} "$tftproot/"
#
## cleanup
sudo rm -rf "$tmp"
