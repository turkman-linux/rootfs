#!/bin/bash
set -ex
mkdir /output -p
if ! which ympstrap >/dev/null ; then
    wget https://gitlab.com/turkman/devel/sources/ymp/-/raw/master/scripts/ympstrap -O /bin/ympstrap
    chmod +x /bin/ympstrap
fi
# create rootfs
if [[ ! -f rootfs/etc/os-release ]] ; then
    ympstrap rootfs
fi

# set permissions
chmod 1777 rootfs/tmp
chmod 700 rootfs/data/user/root
chown root:root rootfs/data/user/root
mount --bind /proc rootfs/proc
chroot rootfs ymp clean --allow-oem
echo "##### $(date) #####" > /output/turkman-rootfs-minimal.revdeb-rebuild
chroot rootfs ymp rbd --allow-oem >> /output/turkman-rootfs-minimal.revdeb-rebuild
umount -lf rootfs/proc

tar --gzip -cf /output/turkman-rootfs-minimal.tar.gz rootfs/*
