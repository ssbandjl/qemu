# taskset -c 2,3 qemu-system-x86_64 \
#   --enable-kvm \
#   -cpu host -smp 2 \
#   -m 1G -object memory-backend-file,id=mem0,size=1G,mem-path=/dev/hugepages,share=on -numa node,memdev=mem0 \
#   -drive file=guest_os_image.qcow2,if=none,id=disk \
#   -device ide-hd,drive=disk,bootindex=0 \
#   -chardev socket,id=spdk_vhost_scsi0,path=/var/tmp/vhost.0 \
#   -device vhost-user-scsi-pci,id=scsi0,chardev=spdk_vhost_scsi0,num_queues=2 \
#   -chardev socket,id=spdk_vhost_blk0,path=/var/tmp/vhost.1 \
#   -device vhost-user-blk-pci,chardev=spdk_vhost_blk0,num-queues=2


# spdk:
HUGEMEM=4096 scripts/setup.sh
build/bin/vhost -S /var/tmp -m 0x3

./scripts/rpc.py bdev_malloc_create 128 4096 -b Malloc0
./scripts/rpc.py vhost_create_scsi_controller --cpumask 0x1 vhost.0  # -> /var/tmp/vhost.0
./scripts/rpc.py vhost_scsi_controller_add_target vhost.0 1 Malloc0

# qemu:
/root/project/virt/qemu/build/qemu-system-x86_64 \
    -enable-kvm -cpu host -smp cores=8,sockets=1 \
    -m 1G -object memory-backend-file,id=mem0,size=1G,mem-path=/dev/hugepages,share=on -numa node,memdev=mem0 \
    -drive file=/root/big/qemu/ubuntu20.qcow2,if=virtio \
    -chardev socket,id=spdk_vhost_scsi0,path=/var/tmp/vhost.0 \
    -device vhost-user-scsi-pci,id=scsi0,chardev=spdk_vhost_scsi0,num_queues=2 \
    -nic user,hostfwd=tcp::2222-:22  -device usb-ehci,id=usb,bus=pci.0,addr=0x8 \
    -device usb-tablet -vnc :75

gdb --args /root/project/virt/qemu/build/qemu-system-x86_64 \
    -enable-kvm -cpu host -smp cores=8,sockets=1 \
    -m 1G -object memory-backend-file,id=mem0,size=1G,mem-path=/dev/hugepages,share=on -numa node,memdev=mem0 \
    -drive file=/root/big/qemu/ubuntu20.qcow2,if=virtio \
    -chardev socket,id=spdk_vhost_scsi0,path=/var/tmp/vhost.0 \
    -device vhost-user-scsi-pci,id=scsi0,chardev=spdk_vhost_scsi0,num_queues=2 \
    -nic user,hostfwd=tcp::2222-:22  -device usb-ehci,id=usb,bus=pci.0,addr=0x8 \
    -device usb-tablet -vnc :75

handle SIGPIPE stop print //截获SIGPIPE信号，程序停止并打印信息 
handle SIGUSR1 nostop noprint //忽略SIGUSR1信号 
handle SIG5 nostop pass
handle all nostop

# show blk:
lsblk --output "NAME,KNAME,MODEL,HCTL,SIZE,VENDOR,SUBSYSTEMS"
ls -alh /sys/class/scsi_host/xxx


