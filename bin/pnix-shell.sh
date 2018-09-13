#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# For more information, please refer to <http://unlicense.org>

# https://gist.github.com/aherrmann/51b56283f9ed5853747908fbab907316

pnix-shell() {
  _usage() {
    cat >&2 <<EOF
pnix-shell generates and opens a persistent nix-shell

Usage: pnix-shell [-h|--help] [-c|--clean] [<shellfile>]

  Use the given \`<shellfile>' or \`./shell.nix'.  Generate a persistent
  nix-shell in \`<shellfile>'s directory under \`.<shellfile>.deps/',
  or use an existing one.  Then enter the nix-shell.

Options:
  -h|--help    display this help message
  -c|--clean   delete any preexisting \`.shell.drv'
  <shellfile>  nix-shell description file [default: shell.nix]

EOF
  }

  local key clean shellfile

  # Parse arguments
  # TODO: --arg --argstr --command --run
  while [[ $# -gt 0 ]]; do
    key=$1
    case $key in
      -h|--help)
        _usage
        return
        ;;
      -c|--clean)
        clean=1
        ;;
      *)
        if [[ -v shellfile ]]; then
          echo "Shell desciption specified more than once" >&2
          return 1
        fi
        shellfile=$(realpath -m "$1")
        ;;
    esac
    shift
  done

  # Set defaults if not set by arguments
  : ${shellfile=$PWD/shell.nix}

  # Shell dependencies directory
  local depsdir="$(dirname "$shellfile")/.$(basename "$shellfile").deps"
  local drvfile="$depsdir/shell.drv"

  # Check for command
  _hascmd() {
    hash "$1" 2>/dev/null \
    || { echo "command not found: $1" >&2; return 1; }
  }

  # Require nix-shell, nix-store, nix-instantiate
  { _hascmd nix-shell && _hascmd nix-instantiate && _hascmd nix-store; } \
  || { return 1; }

  _shellexists () {
    if [[ ! -f "$shellfile" ]]; then
      echo "No shell description found in \`$shellfile'." >&2
      return 1
    fi
  }

  # Clean
  if [[ "$clean" -eq 1 ]]; then
    _shellexists || return 1
    rm -rf "$depsdir"
  fi

  # Use prebuilt shell if it exists
  if [[ -a "$drvfile" ]]; then
    exec nix-shell "$drvfile"
  else
    _shellexists || return 1
    mkdir -p "$depsdir"
    # HACK: Set \`IN_NIX_SHELL=1'.
    #       Make nix believe that the instantiation happens in a nix-shell.
    #       This will trigger `pkgs.lib.inNixShell' to return true, which
    #       will automatically select the `env' attribute in cabal2nix
    #       generated shell descriptions.
    IN_NIX_SHELL=1 nix-instantiate \
      --add-root "$drvfile" --indirect \
      "$shellfile" \
    || { echo "nix-instantiate failed" >&2; return 1; }
    nix-store \
      -r $(nix-store --query --references "$drvfile") \
      --add-root "$depsdir/dep" --indirect \
    || { echo "nix-store failed" >&2; return 1; }
    exec nix-shell "$drvfile"
  fi
}

pnix-shell "$@"
