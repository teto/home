https://github.com/libos-nuse/net-next-nuse/blob/nuse/Documentation/virtual/libos-howto.txt

# generer le .config
make defconfig ARCH=lib

# compiler
make library ARCH=lib
