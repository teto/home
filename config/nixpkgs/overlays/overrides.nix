self: super:
let
  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");

in
rec {

  # termite-unwrapped = super.termite-unwrapped.overrideAttrs(oa: {
  #   postBuild = ''
  #     substituteInPlace termite.terminfo \
  #       --replace "smcup=\E[?1049h," "smcup=\E[?1049h\E[22;0;0t," \
  #       --replace "rmcup=\E[?1049l," "rmcup=\E[?1049l\E[23;0;0t"
  #   '';
  # });

  direnv = super.direnv.overrideAttrs (oa: {
    src = builtins.fetchGit {
      url = https://github.com/direnv/direnv.git;
    };
  });

  i3-local = let i3path = ~/i3; in
  if (builtins.pathExists i3path) then
    super.i3.overrideAttrs (oldAttrs: {
	  name = "i3-dev";
	  src = super.lib.cleanSource i3path;
    })
    else null;

    # TODO override extraLibs instead
   i3pystatus-perso = super.i3pystatus.overrideAttrs (oldAttrs: {
	  name = "i3pystatus-dev";
	  # src = null; # super.lib.cleanSource ~/i3pystatus;
      # propagatedBuildInputs = with self.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
      src = super.fetchFromGitHub {
        repo = "i3pystatus";
        owner = "teto";
        rev="0597577a21761fe5d0ce66082137c65c13354d15";
        sha256 = "0fbcj3ps83n7v8ybihc6wk8x61l8rkqg6077zh9v58gk4j6wdyhq";
      };
	});

  protocol-local = super.protocol.overrideAttrs (oldAttrs: {
    src=/home/teto/protocol;
  });

  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};

  # nixVeryUnstable = super.nixUnstable.overrideAttrs(o: {
  #   src = fetchGit https://github.com/NixOS/nix;
  #   nativeBuildInputs = with super.pkgs; (o.nativeBuildInputs or []) ++ [
  #     autoreconfHook autoconf-archive bison flex libxml2 libxslt
  #     docbook5 docbook5_xsl
  #   ];
  #   buildInputs = (o.buildInputs or []) ++ [ boost ];
  # });

    # src = super.fetchFromGitLab {
    #   rev = "9f9948732a0153a54f7324873fdb5cafbcd9d2d6";
    #   # rev = "master";
    #   domain = "gitlab.marlam.de";
    #   # group
    #   owner = "marlam";
    #   repo = "msmtp";
    #   sha256 = "17f9qq8gnim6glqlrg7187my4d5y40v76cbpaqgpvrhpyc7z9vf6";
    # };

    # careful doesnt detect TLS
    # msmtp = super.msmtp.overrideAttrs(oa: {
    #   buildInputs = [ super.pkgs.texinfo ];

    #   src = builtins.fetchurl {
    #     url = "https://gitlab.marlam.de/marlam/msmtp/repository/archive.tar.gz?ref=9f9948732a0153a54f7324873fdb5cafbcd9d2d6"; 
    #     sha256 = "1b0062h1ik5i78wv26vmfsgk4bl434dlci62l6pz148hvw6nkpjp";
    #   };
    # });

  xdg_utils = super.xdg_utils.overrideAttrs(oa: {
    pname = "xdg-utils-custom";
    name = "xdg-utils-custom-matt";
    # version = "matt";
    patches = [
      ./patches/xdg_utils_symlink.diff
    ];
  });

  nixops-dev = super.nixops.overrideAttrs ( oa: {
    # src = super.fetchFromGitHub {
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

  luarocks-nix = super.luarocks-nix.overrideAttrs(oa: {
    name = "luarocks-local";
    src = /home/teto/luarocks;
    # src = builtins.fetchGit {
    #   url = https://github.com/teto/luarocks/;
    #   ref = "nix";
    # };
  });

  # iperf3_lkl = super.iperf3.overrideAttrs(old: {
  # });
}
