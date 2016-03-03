https://github.com/libos-nuse/net-next-nuse/blob/nuse/Documentation/virtual/libos-howto.txt

# generer le .config
make defconfig ARCH=lib

# compiler
make library ARCH=lib

If you have problems compiling nuse, you can disable it. see d9232b0caeb05e96d51dc9c5e07873170fb1cb84
(Makefile, target "library").



testbin: bake check_pkgs
  @cp ../../../arch/lib/tools/bakeconf-linux.xml bake/bakeconf.xml
  @mkdir -p buildtop/build/bin_dce
  cd buildtop ; \
  ../bake/bake.py configure -e dce-linux-inkernel $(BAKECONF_PARAMS)
  cd buildtop ; \
  ../bake/bake.py show --enabledTree | grep -v  -E "pygoocanvas|graphviz|python-dev" | grep Missing && (echo "required packages are missing") || echo ""
  cd buildtop ; \
  ../bake/bake.py download ; \
  ../bake/bake.py update ; \
  ../bake/bake.py build $(BAKEBUILD_PARAMS)


    <module name="dce-linux-inkernel">
      <source type="mercurial">
        <attribute name="url" value="http://code.nsnam.org/ns-3-dce"/>
        <attribute name="module_directory" value="ns-3-dce"/>
  <!-- Fri Oct 09 16:37:01 2015 +0900 add a NATIVE call dl_itera_phdr.patch (after dce-1.7) -->
        <attribute name="revision" value="99f67c809a00"/>
      </source>
      <depends_on name="dce-meta-1.7" optional="False"/>
      <depends_on name="iproute2-dev" optional="False"/>
      <depends_on name="iputils" optional="False"/>
      <build type="waf" objdir="yes" sourcedir="ns-3-dce">
        <attribute name="supported_os" value="linux;linux2"/>
        <!-- assume the bake.py build is executed under arch/sim/test/buildtop/ -->
        <attribute name="configure_arguments" value="configure --prefix=$INSTALLDIR --with-ns3=$INSTALLDIR --with-elf-loader=$INSTALLDIR/lib --with-libaspect=$INSTALLDIR --enable-kernel-stack=$SRCDIR/../../../../../../arch/"/>
         <attribute name="post_installation" value="mkdir -p $INSTALLDIR/bin_dce; cd $INSTALLDIR/bin_dce; ln -s -f $SRCDIR/../../../../../../arch/lib/tools/libsim-linux.so liblinux.so;  ln -s -f $SRCDIR/../../../../../../arch/lib/tools/libsim-linux.so libsim-linux.so"/>
      </build>
    </module>
