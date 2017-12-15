#!/bin/sh
# http://stackoverflow.com/questions/4980819/what-are-the-gcc-default-include-directories
# u can modify them via
echo "Usage: $0 [<compiler>]"
echo "Compiler"

echo " -xc pour le C, -xc++ pour le C++"
gcc -xc -E -v < /dev/null

# echo | gcc -Wp,-v -x c++ - -fsyntax-only

# for C++ gcc -xc++ -E -v -
