if [ -f pxeboot.tar.gz  ]; then
	echo "Remove old archive"
	rm pxeboot.tar.gz
fi
cp "tftp"/gentoo "srv/pxeboot/"
cp "tftp"/initramfs.gz "srv/pxeboot/"
cp "tftp"/pxelinux.cfg/default "srv/pxeboot/pxelinux.cfg/"
chown nobody:nogroup srv/pxeboot/* -R
tar -cvpf pxeboot.tar.gz srv

