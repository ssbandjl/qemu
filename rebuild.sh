# rm -rf subprojects/keycodemapdb
set -e

rm -rf build
mkdir build
cd build
# ../configure --help|grep user  #get help, slirp is net user
# ../configure  --enable-slirp --disable-strip --enable-debug-info --enable-sdl --enable-trace-backends=log

# xzhen args
#!/usr/bin/bash
# slirp: used for hostfwd
# spice: used for clipboard sharing
# ../configure --target-list=x86_64-softmmu,x86_64-linux-user \
#     --prefix=/usr/local/qemu \
#     --enable-kvm  \
#     --disable-docs \
#     --enable-debug \
#     --extra-cflags="-gdwarf-4" \
#     --enable-slirp 

../configure --target-list=x86_64-softmmu,x86_64-linux-user \
    --enable-kvm  \
    --disable-docs \
    --enable-debug \
    --extra-cflags="-gdwarf-4" \
    --enable-slirp \
    --enable-virtfs \
    --enable-sdl
#    --enable-spice \
#    --enable-spice-protocol

# ../configure  --disable-werror --disable-slirp --disable-strip --enable-debug --enable-sdl --enable-trace-backends=log

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

