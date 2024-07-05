# rm -rf subprojects/keycodemapdb
set -e

# sudo apt-get install -y git python3 python3-pip build-essential ninja-build pkg-config  libglib2.0-dev  libpixman-1-dev libslirp-dev

rm -rf build
mkdir build
cd build
# ../configure --help|grep user  #get help, slirp is net user
# ../configure  --enable-slirp --disable-strip --enable-debug-info --enable-sdl --enable-trace-backends=log
../configure  --disable-werror --disable-slirp --disable-strip --enable-debug --enable-sdl --enable-trace-backends=log
# ../configure  --enable-slirp --disable-strip --enable-debug-info --enable-sdl --enable-trace-backends=log --enable-kvm --enable-virtfs
make -j$(nproc)
# make CONFIG_EDU=y CONFIG_DMA_ENGINE=y -j$(nproc)

# change own
# sudo chown -R root:root /home/xb/project/virt/qemu/build/qemu-bridge-helper
# sudo chmod 4755 /home/xb/project/virt/qemu/build/qemu-bundle/usr/local/libexec/qemu-bridge-helper

# mkdir -p /home/xb/project/virt/qemu/build/qemu-bundle/usr/local/etc/qemu
# touch /home/xb/project/virt/qemu/build/qemu-bundle/usr/local/etc/qemu/bridge.conf
# tee<<EOF>>/home/xb/project/virt/qemu/build/qemu-bundle/usr/local/etc/qemu/bridge.conf
# allow br0
# EOF
