#!/bin/bash -xe
sudo ./clean.sh
source ./config.cfg
test -z "$tftproot" -o -z "$image" && echo "Usage: $0 <tftproot> <gentoo-iso>" >&2 && exit 1
test -e "$tmp" && echo "Temporary path '$tmp' already exists." >&2 && exit 1

# prepare directories
mkdir -p "$tmp" "$iso" "$initrd/mnt/cdrom"

# extract files from ISO image
sudo mount -o ro,loop "$image" "$iso"
cp "$iso"/{image.squashfs,isolinux/gentoo,isolinux/gentoo.igz} "$tmp"
sudo umount "$iso"

# patch initramfs and add squashfs to it
xz -dc "$tmp/gentoo.igz" | ( cd "$initrd" && sudo cpio -idv )
sudo patch -d "$initrd" -p0 <<'EOF'
--- init.orig	2018-07-21 18:33:34.528587830 +0300
+++ init	2018-07-21 21:08:15.106424520 +0300
@@ -491,9 +491,9 @@
 		CHROOT=${NEW_ROOT}
 	fi
 
-	if [ /dev/nfs != "$REAL_ROOT" ] && [ sgimips != "$LOOPTYPE" ] && [ 1 != "$aufs" ] && [ 1 != "$overlayfs" ]; then
-		bootstrapCD
-	fi
+#	if [ /dev/nfs != "$REAL_ROOT" ] && [ sgimips != "$LOOPTYPE" ] && [ 1 != "$aufs" ] && [ 1 != "$overlayfs" ]; then
+#		bootstrapCD
+#	fi
 
 	if [ "${REAL_ROOT}" = '' ]
 	then
@@ -558,7 +558,7 @@
 					REAL_ROOT="${ROOT_DEV}"
 				else
 					prompt_user "REAL_ROOT" "root block device"
-					got_good_root=0
+					got_good_root=1
 					continue
 				fi
 				;;
@@ -636,7 +636,7 @@
 		else
 			bad_msg "Block device ${REAL_ROOT} is not a valid root device..."
 			REAL_ROOT=""
-			got_good_root=0
+			got_good_root=1
 		fi
 	done
 
@@ -718,7 +718,7 @@
 	[ -z "${LOOP}" ] && find_loop
 	[ -z "${LOOPTYPE}" ] && find_looptype
 
-	cache_cd_contents
+	#cache_cd_contents
 
 	# If encrypted, find key and mount, otherwise mount as usual
 	if [ -n "${CRYPT_ROOT}" ]
EOF
echo "Unpack image squashfs"
sudo ./unsqfs.sh $tmp $tmp/image.squashfs
if [ $auto -eq 1 ]; then
echo "Add Squashfs tool in image"
    sudo ./prepare.sh
	sudo ./mkautostart.sh
	sudo ./pack_image.sh
	sudo ./mkpxeboot.sh
fi
