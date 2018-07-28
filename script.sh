#!/bin/bash
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
function failedExit {
    if [ $? -eq 0 ]; then
        $SETCOLOR_SUCCESS
        echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
        $SETCOLOR_NORMAL
        echo
    else
        $SETCOLOR_FAILURE
        echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
        $SETCOLOR_NORMAL
        echo
        exit 1
    fi
}
function failedOk {
    if [ $? -eq 0 ]; then
        $SETCOLOR_SUCCESS
        echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
        $SETCOLOR_NORMAL
        echo
    else
        $SETCOLOR_FAILURE
        echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
        $SETCOLOR_NORMAL
        echo
    fi
}
ip address
net='net'
mkdir /mnt/root
echo "Create table"
(parted /dev/sda mktable msdos -s &>/dev/null
parted /dev/sda mkpart primary 1 20G print free -s &>/dev/null
parted /dev/sda mkpart primary 20G 24G print free -s &>/dev/null
parted /dev/sda mkpart primary 24G 28G print free -s &>/dev/null)
failedExit
parted /dev/sda print -s
echo "MkFS..."
(echo "y" | mkfs.ext4 -U '52324238-502c-4a6c-a8a4-e63480b7d9ea' /dev/sda1 &>/dev/null
echo "y" | mkfs.ext4 -U '18719e4d-7318-4077-876a-2ae6392465d9' /dev/sda3 &>/dev/null
mkswap -U '9ce9eb70-1ec1-46c7-9691-c83e5720ab1e'  /dev/sda2 &>/dev/null)
failedExit
### Mount /dev/sda
echo "Mount disk..."
mount /dev/sda1 /mnt/root &>/dev/null
failedExit
### Unpack Squashfs to /mnt/root
echo "Unpack FS "$i
unsquashfs -d /mnt/root -f /mnt/$net/root.squashfs
failedOk
for i in 'usr' 'var' 'etc'; do
    echo "Unpack FS "$i
    unsquashfs -d /mnt/root/$i -f /mnt/$net/$i.squashfs
    failedOk
done
### Mount /dev/sda3
echo "Unpack FS home"
mount  /dev/sda3 /mnt/root/home &>/dev/null
failedExit
unsquashfs -d /mnt/root/home -f /mnt/$net/home.squashfs
failedOk
echo "Mount Directory"
(mount -o bind /dev /mnt/root/dev &>/dev/null
mount -o bind /proc /mnt/root/proc &>/dev/null
mount -o bind /sys /mnt/root/sys &>/dev/null
chroot /mnt/root grub-install /dev/sda &>/dev/null)
failedExit
echo "Poweroff"
poweroff

