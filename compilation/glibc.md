
Pour tester un libos perso, ca peut etre bien d'avoir:
$ git clone git://sourceware.org/git/glibc.git 

Par defaut ca génère les versions dynamique/statique ainsi que PIC/non-PIC


Move to new directory:
$ mkdir release && cd release
$ LD_LIBRARY_PATH="" ../configure --prefix=$HOME/glibc_test 
--enable-static-nss
--with-headers=PATH_TO_TARGET_KERNEL
$ make
