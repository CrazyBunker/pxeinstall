if [ -f pxeboot.tar.gz  ]; then
	echo "Remove old archive"
	rm pxeboot.tar.gz
fi
tar -cvpf pxeboot.tar.gz srv

