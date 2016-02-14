
clang with C++11 support
==

CXX="clang++" CXXFLAGS="-g -Wno-potentially-evaluated-expression -Wno-reorder -std=c++11" ./waf configure --prefix=install --build-profile=debug


g++ with C++11 support
==

WARNING !! Add to CXX flags missing things !

Sur la derniere Ubuntu, avec gcc 5 il y a un ABI breakage et donc pour supprimer l'erreur:
/usr/bin/../lib/gcc/x86_64-linux-gnu/5.2.1/../../../../include/c++/5.2.1/sstream:300:14: error: '__xfer_bufptrs' redeclared with 'public' access
cf https://gcc.gnu.org/bugzilla/show_bug.cgi?id=65899
on peut ajouter -include sstream aux flags  !
-std=c++14

```
./waf configure --prefix=$HOME/ns3off/install --build-profile=debug --enable-tests CXX="g++" CXXFLAGS="-g -Wno-reorder -Wno-unused-variable -std=c++11 -include sstream"
```

Pour voir la config (flags/compilo etc...) actuelle, aller dans build/c4che/_cache.py


To run tests and see results
./waf --run "test-runner --test-name=node-scheduling --stop-on-failure --fullness=QUICK --verbose"
