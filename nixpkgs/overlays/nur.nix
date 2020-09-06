final: prev: {
  nur = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    # url = "https://github.com/nix-community/NUR/archive/cb0033ca5ef1e2db7952919f0f983ce57d8526b0.tar.gz";
    # sha256 = "1yx5g2q0sashbpr2qcqgrgkjsn5440idka1hsppp9a1bwiz35vli";
  }) {
    inherit (prev) pkgs;
  };
}
