# Create a disk image Create a disk image in QCOW2 format (qcow2 is slower than the raw format, but uses less disk space).
# cd /home/xb/big/qemu;rm -f ubuntu20.qcow2.bak;mv ubuntu20.qcow2 ubuntu20.qcow2.bak
# /root/project/virt/qemu/build/qemu-img create -f qcow2 ubuntu20.qcow2 16G

cd /root/big/qemu/
/root/project/virt/qemu/build/qemu-img create -f qcow2 ubuntu20.qcow2 16G

# install os
# /root/project/virt/qemu/build/qemu-system-x86_64 -m 4096 -smp 2 --enable-kvm -drive file=/root/big/qemu/ubuntu20.qcow2,format=qcow2 -boot order=d -cdrom /root/big/iso/ubuntu-20.04.6-desktop-amd64.iso

# start vm, need filter log event
# /root/project/virt/qemu/build/qemu-system-x86_64 -device edu -device dma_engine -m 4096 -smp 2 --enable-kvm -trace enable=* -D qemu.log /root/big/qemu/ubuntu20.qcow2
/root/project/virt/qemu/build/qemu-system-x86_64 -m 4G -smp 2 -enable-kvm \
                   -display none \
                   -nic user,hostfwd=tcp::60022-:22 \
                   /root/big/qemu/ubuntu20.qcow2

# /root/project/virt/qemu/build/qemu-system-x86_64 -m 4G -smp 2 -enable-kvm \
#                    -display none \
#                    -nic user,hostfwd=tcp::60022-:22 \
#                    -device edu -device dma_engine \
#                    /root/big/qemu/ubuntu20.qcow2

or:
/root/project/virt/qemu/build/qemu-system-x86_64 -m 4G -smp 2 -enable-kvm -nic user,hostfwd=tcp::60022-:22  -device edu -device dma_engine /root/big/qemu/ubuntu20.qcow2


/root/project/virt/qemu/build/qemu-system-x86_64 -m 4G -smp 2 -enable-kvm -nic user,hostfwd=tcp::60022-:22  -device edu -device dma_engine -virtfs local,path=/root/project/virt/qemu,mount_tag=host_public,id=host0,security_model=mapped-xattr /root/big/qemu/ubuntu20.qcow2

use bridge:
/root/project/virt/qemu/build/qemu-system-x86_64 -m 4G -smp 2 -enable-kvm -netdev bridge,id=hn0,br=br0  -device virtio-net-pci,netdev=hn0,id=nic1 -device edu -device dma_engine -virtfs local,path=/root/project/virt/qemu,mount_tag=host_public,id=host0,security_model=mapped-xattr /root/big/qemu/ubuntu20.qcow2

sudo /root/project/virt/qemu/build/qemu-system-x86_64 -m 4G -smp 2 -enable-kvm -net nic,model=virtio,macaddr=52:54:00:00:00:01 -net bridge,br=br0 -device edu -device dma_engine -virtfs local,path=/root/project/virt/qemu,mount_tag=host_public,id=host0,security_model=mapped-xattr /root/big/qemu/ubuntu20.qcow2

no root:
/root/project/virt/qemu/build/qemu-system-x86_64 -m 4G -smp 2 -enable-kvm -net nic,model=virtio,macaddr=52:54:00:00:00:01 -net bridge,br=br0 -device edu -device dma_engine -virtfs local,path=/root/project/virt/qemu,mount_tag=host_public,id=host0,security_model=mapped-xattr /root/big/qemu/ubuntu20.qcow2

guest_mount share folder:
sudo mount -t 9p -o trans=virtio,version=9p2000.L host_public /root/project/virt/qemu


gdb --args /root/project/virt/qemu/build/qemu-system-x86_64 -m 4G -smp 2 -enable-kvm  -display none -D /home/xb/big/qemu_vm.log -net nic,model=virtio,macaddr=52:54:00:00:00:01 -net bridge,br=br0 -device edu -device dma_engine -virtfs local,path=/root/project/virt/qemu,mount_tag=host_public,id=host0,security_model=mapped-xattr /root/big/qemu/ubuntu20.qcow2




gdb --args /root/project/virt/qemu/build/qemu-system-x86_64 -m 4G -smp 2 -enable-kvm  -display none  -nographic -D /home/xb/big/qemu_vm.log -net nic,model=virtio,macaddr=52:54:00:00:00:01 -net bridge,br=br0 -device edu -device myedu -device dma_engine -virtfs local,path=/root/project/virt/qemu,mount_tag=host_public,id=host0,security_model=mapped-xattr /root/big/qemu/ubuntu20.qcow2


latest:
ps aux|grep qemu|grep -v grep|awk '{print$2}'|xargs -x kill
/root/project/virt/qemu/build/qemu-system-x86_64 -m 8G -smp 2 -enable-kvm  -display none  -nographic -D /home/xb/big/qemu_vm.log -net nic,model=virtio,macaddr=52:54:00:00:00:01 -net bridge,br=br0 -device edu -device myedu,device_id=0x9038 -device dma_engine -virtfs local,path=/root/project/virt/qemu,mount_tag=host_public,id=host0,security_model=mapped-xattr /root/big/qemu/ubuntu20.qcow2



echo -e """
gdb
file ./kernel.sym
target remote:1234
"""
/root/project/virt/qemu/build/qemu-system-x86_64 -m 4096 -enable-kvm -cpu host -smp cores=8,sockets=1 -drive file=/root/big/qemu/ubuntu20.qcow2,if=virtio -nic user,hostfwd=tcp::2222-:22  -device usb-ehci,id=usb,bus=pci.0,addr=0x8 -device usb-tablet -vnc :75

# /root/project/virt/qemu/build/qemu-system-x86_64 -m 4096 -enable-kvm -cpu host -smp cores=8,sockets=1 -drive file=/root/big/qemu/ubuntu20.qcow2,if=virtio -nic user,hostfwd=tcp::2222-:22 -fsdev local,security_model=passthrough,id=fsdev0,path=/root/project/linux/linux-5.15 -device virtio-9p-pci,fsdev=fsdev0,mount_tag=kernelmake -device usb-ehci,id=usb,bus=pci.0,addr=0x8 -device usb-tablet -S -s -vnc :75 -monitor stdio

