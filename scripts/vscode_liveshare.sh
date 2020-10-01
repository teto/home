#! /usr/bin/env nix-shell
#! nix-shell -i sh -p dotnetCorePackages.netcore_3_1 icu patchelf gcc gcr liburcu openssl krb5 zlib gnome3.gnome-keyring libsecret desktop-file-utils xorg.xprop

# patch ELF loaders where needed
GCCLIB=$(dirname $(gcc -print-file-name=libstdc++.so.6))
LOADER=$(dirname $(gcc -print-file-name=ld-linux-x86-64.so.2))
find ~/.vscode/extensions/ ~/.config/Code -type f -perm -100 -print0 | xargs -0 file \
| grep 'interpreter /lib' | cut -d: -f1 | while read f; do
	echo "Patching $f" >&2
	patchelf --set-interpreter "$LOADER" "$f"
	RPATH=$(patchelf --print-rpath "$f")
	patchelf --set-rpath "${RPATH+RPATH:}$GCCLIB" "$f"
done
# Provide all libraries
export LD_LIBRARY_PATH=$(echo "$NIX_LDFLAGS" | sed -E -e 's/\s*(-rpath|-L)\s*/:/g' -e 's/^://')
# It seems VSLS downloads dotnet itself so this may not be needed
export DOTNET_ROOT=$(dirname $(type -p dotnet))/..
# Don't know how to tell dotnet about ICU
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
exec code  "$@"
