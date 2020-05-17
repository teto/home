final: prev:
let
  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (p: t: prev.lib.cleanSourceFilter p t && baseNameOf p != "build");

in
rec {

  # TODO override extraLibs instead
  i3pystatus-perso = (prev.i3pystatus.override({
    extraLibs = with final.pkgs.python3Packages; [ pytz notmuch dbus-python ];
  })).overrideAttrs (oldAttrs: {
    name = "i3pystatus-dev";
    # src = null; # prev.lib.cleanSource ~/i3pystatus;
    # propagatedBuildInputs = with final.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
    src = builtins.fetchGit {
      url = https://github.com/teto/i3pystatus;
      ref = "nix_backend";
    };
    # src = prev.fetchFromGitHub {
    #   repo = "i3pystatus";
    #   owner = "teto";
    #   rev="0597577a21761fe5d0ce66082137c65c13354d15";
    #   sha256 = "0fbcj3ps83n7v8ybihc6wk8x61l8rkqg6077zh9v58gk4j6wdyhq";
    # };
  });

  protocol-local = prev.protocol.overrideAttrs (oldAttrs: {
    src=/home/teto/protocol;
  });


  # nixVeryUnstable = prev.nixUnstable.overrideAttrs(o: {
  #   src = fetchGit https://github.com/NixOS/nix;
  #   nativeBuildInputs = with prev.pkgs; (o.nativeBuildInputs or []) ++ [
  #     autoreconfHook autoconf-archive bison flex libxml2 libxslt
  #     docbook5 docbook5_xsl
  #   ];
  #   buildInputs = (o.buildInputs or []) ++ [ boost ];
  # });

  # src = prev.fetchFromGitLab {
  #   rev = "9f9948732a0153a54f7324873fdb5cafbcd9d2d6";
  #   # rev = "master";
  #   domain = "gitlab.marlam.de";
  #   # group
  #   owner = "marlam";
  #   repo = "msmtp";
  #   sha256 = "17f9qq8gnim6glqlrg7187my4d5y40v76cbpaqgpvrhpyc7z9vf6";
  # };

  # triggers a build of chrome
  # xdg_utils = prev.xdg_utils.overrideAttrs(oa: {
  #   pname = "xdg-utils-custom";
  #   name = "xdg-utils-custom-matt";
  #   # version = "matt";
  #   patches = [
  #     ./patches/xdg_utils_symlink.diff
  #   ];
  # });

  nixops-dev = prev.nixops.overrideAttrs ( oa: {
    # src = prev.fetchFromGitHub {
    #   owner = "teto";
    #   repo = "nixops";
    #   rev = "7c71333a3ff6dc636d0b2547f07b105571a3027b";
    #   sha256 = "0fc0ix468n2s97p9nfdl3bxi3i9hwf60j4k2mabrnxfhladsygzm";
    # };
    # version = "1.7";
    name = "nixops-dev";
    # version = "
    src = builtins.fetchGit {
      url = /home/teto/nixops;
      # rev = "7c71333a3ff6dc636d0b2547f07b105571a3027b";
    };
  });
}
