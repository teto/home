#!/bin/sh
# http://stackoverflow.com/questions/4980819/what-are-the-gcc-default-include-directories
# u can modify them via 

echo "Pour le C"
gcc -xc -E -v -

# echo | gcc -Wp,-v -x c++ - -fsyntax-only

# for C++ gcc -xc++ -E -v -
