
Look at https://www.nsnam.org/docs/dce/manual/html/getting-started.html to see how to compile with kernel stack or 
https://plus.google.com/+HajimeTazaki/posts/1QUmR3n3vNA


Pour pouvoir charger le noyau mptcp dans DCE, il faut se placer dans le noyau mptcp et faire un merge
avec next-next-sim (qui est basé sur le noyuau upstream)
# Clone net-next-sim
git clone https://github.com/thehajime/net-next-sim.git
cd net-next-sim
# Select a kernel version
git checkout sim-ns3-3.10.0-branch
# Configure and build
make defconfig OPT=yes ARCH=sim
make library OPT=yes ARCH=sim
cd ..

memcpy (buf->sysname, m_sysName.c_str (), std::min ((int) m_sysName.length (), 64));
memcpy (buf->sysname, m_sysName.c_str (), std::min ((int) m_sysName.length (), 64));

# Download, configure, build and install DCE

TODO refaire une passe pr que ca compile avec clang++
CXX="clang++"
-include sstream
-Wno-deprecated-declarations
```
CXX="g++" CXXFLAGS=" -g -Wno-reorder -Wno-unused-variable -std=c++11 " \
./waf configure --with-ns3=$HOME/ns3off/install \
--enable-kernel-stack=$HOME/whichone/arch \
--with-glibc=$HOME/glibc/include \
--prefix=$HOME/dce/build
```


Il n'y a pas non plus de checks sur --enable-kernel-stack ?


# Test one's protocol under DCE:


You have to compile with the flags:

    Compile your objects using this gcc flag: -fPIC for exemple: gcc -fPIC -c foo.c

        (option) Some application needs to be compile with -U_FORTIFY_SOURCE so that the application doesn’t use alternative symbols including __chk (like memcpy_chk).

    Link your executable using this gcc flag: -pie and -rdynamic for exemple: gcc -o foo -pie -rdynamic foo.o

CFLAGS=-fPIC -U_FORTIFY_SOURCE LDFLAGS=-pie -rdynamic


Running tests:
- Invalid test name: cannot contain any of '"/\|?': Check that process "test-empty(ns3)" completes correctly.

./waf --run "test-runner --test-name=netlink-socket --verbose"


 CXXFLAGS="-g -std=c++11 -Wno-deprecated-declarations" ./waf configure --with-ns3=$HOME/ns3off/install
