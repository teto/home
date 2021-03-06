# Copy this to 'local.mk' in the repository root.
# Individual entries must be uncommented to take effect.

# By default, the installation prefix is '/usr/local'.
# CMAKE_EXTRA_FLAGS += -DCMAKE_INSTALL_PREFIX=/usr/local/nvim-latest

# These CFLAGS can be used in addition to those specified in CMakeLists.txt:
# CMAKE_EXTRA_FLAGS="-DCMAKE_C_FLAGS=-ftrapv -Wlogical-op"

# By default, the jemalloc family of memory allocation functions are used.
# Uncomment the following to instead use libc memory allocation functions.
# CMAKE_EXTRA_FLAGS += -DENABLE_JEMALLOC=OFF

# Sets the build type; defaults to Debug. Valid values:
#
# - Debug:          Disables optimizations (-O0), enables debug information and logging.
#
# - Dev:            Enables all optimizations that do not interfere with
#                   debugging (-Og if available, -O2 and -g if not).
#                   Enables debug information and logging.
#
# - RelWithDebInfo: Enables optimizations (-O2) and debug information.
#                   Disables logging.
#
# - MinSizeRel:     Enables all -O2 optimization that do not typically
#                   increase code size, and performs further optimizations
#                   designed to reduce code size (-Os).
#                   Disables debug information and logging.
#
# - Release:        Same as RelWithDebInfo, but disables debug information.
#
# CMAKE_BUILD_TYPE := Debug

# By default, nvim's log level is INFO (1) (unless CMAKE_BUILD_TYPE is
# "Release", in which case logging is disabled).
# The log level must be a number DEBUG (0), INFO (1), WARNING (2) or ERROR (3).
# CMAKE_EXTRA_FLAGS += -DMIN_LOG_LEVEL=1

# By default, nvim uses bundled versions of its required third-party
# dependencies.
# Uncomment these entries to instead use system-wide installations of
# them.
#
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_BUSTED=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_DEPS=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_JEMALLOC=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LIBTERMKEY=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LIBUV=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LIBVTERM=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LUAJIT=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_LUAROCKS=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_MSGPACK=OFF
# DEPS_CMAKE_FLAGS += -DUSE_BUNDLED_UNIBILIUM=OFF

# By default, bundled libraries are statically linked to nvim.
# This has no effect for non-bundled deps, which are always dynamically linked.
# Uncomment these entries to instead use dynamic linking.
#
# CMAKE_EXTRA_FLAGS += -DLIBTERMKEY_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DLIBUNIBILIUM_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DLIBUV_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DLIBVTERM_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DLUAJIT_USE_STATIC=OFF
# CMAKE_EXTRA_FLAGS += -DMSGPACK_USE_STATIC=OFF
#
# The gtest output provider shows verbose details
# that can be useful to diagnose hung tests
# CMAKE_EXTRA_FLAGS += -DBUSTED_OUTPUT_TYPE=gtest
CMAKE_EXTRA_FLAGS += -DBUSTED_OUTPUT_TYPE=nvim
	CPP_EXTRA_ARGS:="/usr/bin/cc -DINCLUDE_GENERATED_DECLARATIONS -D_GNU_SOURCE -Iconfig -I../src -isystem ../.deps/usr/include -Isrc/nvim/auto -Iinclude	 -Wconversion -DNVIM_MSGPACK_HAS_FLOAT32 -g		-Wall -Wextra -pedantic -Wno-unused-parameter -Wstrict-prototypes -std=gnu99 -Wvla -fstack-protector-strong -fdiagnostics-color=auto -I/usr/lib/gcc/x86_64-linux-gnu/6/include -I/usr/local/include -I/usr/lib/gcc/x86_64-linux-gnu/6/include-fixed -I/usr/include/x86_64-linux-gnu -I/usr/include"

.DEFAULT_GOAL := nvim

INTERMEDIATE_FILES := $(shell find build/ -type f -name '*.i')
#
# Run doxygen over the source code.
# Output will be in build/doxygen
#
doxygen:
	doxygen src/Doxyfile

frama-c:

	# No. support for pre-processing in Frama-C is quite basic. That said,
	# it is possible to do something like
	# frama-c -ocode file1.i -cpp-command cmd1 -print file1.c -then -ocode
	# file2.i -cpp-command cmd2 -print file2.c [...] -then -ocode="" file1.i
	# file2.i [analysis options]

	# or of course
	# frama-c -ocode file1.i -cpp-command cmd1 -print file1.c
	# frama-c -ocode file2.i -cpp-command cmd2 -print file2.c
	# ...
	# frama-c file1.i file2.i ...

	# As an aside, unless you really want to change the whole pre-processor,
	# it's usually better to use -cpp-extra-args="-Iinclude-lib -DFOO ..."
	# rather than -cpp-command.
	# or one can use
	# https://lists.gforge.inria.fr/pipermail/frama-c-discuss/2008-October/000600.html
	# frama-c build/*.i
	# -cpp-extra-args="-Iinclude-lib
	# frama-c -cpp-extra-args="$(CPP_EXTRA_ARGS)" $(INTERMEDIATE_FILES)
	frama-c -cpp-command=$(CPP_EXTRA_ARGS) $(INTERMEDIATE_FILES)
