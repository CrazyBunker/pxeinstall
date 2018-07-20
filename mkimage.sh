mkdir -p image
if [ -f image/root.squashfs ]; then
	rm image/root.squashfs -f
fi
if [ -f image/home.squashfs ]; then
	rm image/home.squashfs -f 
fi
if [ -f image/etc.squashfs ]; then
        rm image/etc.squashfs -f 
fi
if [ -f image/etc.squashfs ]; then
        rm image/etc.squashfs -f 
fi
mkdir root
sudo mount $1 root
sudo mksquashfs root image/root.squashfs -e root/tmp root/usr root/etc root/var -comp xz -mem 8G
sudo mksquashfs root/etc image/etc.squashfs -comp xz -mem 8G
sudo mksquashfs root/var image/var.squashfs -comp xz -mem 8G
sudo mksquashfs root/usr image/usr.squashfs -comp xz -mem 8G
sudo mount /dev/$2 root/home
sudo mksquashfs root/home image/home.squashfs -comp xz -mem 8G
