
Pour tester un libos perso, ca peut etre bien d'avoir:
$ git clone git://sourceware.org/git/glibc.git 

Move to new directory:
$ mkdir release && cd release
$ ../configure --prefix=$HOME/glibc_test --with-headers=PATH_TO_TARGET_KERNEL
$ make
