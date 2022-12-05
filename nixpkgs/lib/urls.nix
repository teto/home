{ lib, fetchTarball, ... }:
{
  # ghcide-nix = https://github.com/hercules-ci/ghcide-nix
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") { };

}
