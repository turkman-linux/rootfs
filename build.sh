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

tar --gzip -cfv rootfs/* /output/turkman-rootfs-minimal.tar.gz 
