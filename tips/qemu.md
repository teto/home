

# to get a kvmconfig
$ make kvmconfig

# comment voir les partitions a l'interieur d un qcow2 ?

sudo modprobe nbd max_part=8
sudo qemu-nbd --connect=/dev/nbd0 /mnt/ext/libvirt/images/nixops-be57277a-cec0-11e9-836c-001b21dc6258-main.qcow2

sudo qemu-nbd --disconnect /dev/nbd0
https://www.bernhard-ehlers.de/blog/2017/10/26/inspect-modify-qemu-images.html

# Inspect 
$ lsblk --fs /dev/nbd0
NAME     FSTYPE LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINT
nbd0
└─nbd0p1 ext4   nixos 5803335e-f1d2-415e-8cf6-47f654f89b6e
