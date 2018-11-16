self: super:
let
	# src =  builtins.filterSource (name: type: true) /home/teto/mptcpanalyzer;
  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");

  fetchgitLocal = super.fetchgitLocal;

  # Get the commit ID for the given ref in the given repo
  # latestGitCommit = { url, ref ? "HEAD" }:
  #   runCommand "repo-${sanitiseName ref}-${sanitiseName url}"
  #     {
  #       # Avoids caching. This is a cheap operation and needs to be up-to-date
  #       version = toString currentTime;
  #       # Required for SSL
  #       GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  #       buildInputs = [ git gnused ];
  #     }
  #     ''
  #       REV=$(git ls-remote "${url}" "${ref}") || exit 1
  #       printf '"%s"' $(echo "$REV"        |
  #                       head -n1           |
  #                       sed -e 's/\s.*//g' ) > "$out"
  #     '';
  # fetchLatestGit = { url, ref ? "HEAD" }@args:
  #   with { rev = import (latestGitCommit { inherit url ref; }); };
  #   fetchGitHashless (removeAttrs (args // { inherit rev; }) [ "ref" ]);
in
rec {

  # mininet = super.mininet.overrideAttrs(oa: {
  #     src = /home/teto/mininet2;
  # });
  
  termite-unwrapped = super.termite-unwrapped.overrideAttrs(oa: {
    postBuild = ''
      substituteInPlace termite.terminfo \
        --replace "smcup=\E[?1049h," "smcup=\E[?1049h\E[22;0;0t," \
        --replace "rmcup=\E[?1049l," "rmcup=\E[?1049l\E[23;0;0t"
    '';
  });


  i3-local = let i3path = ~/i3; in 
  if (builtins.pathExists i3path) then
    super.i3.overrideAttrs (oldAttrs: {
	  name = "i3-dev";
	  src = super.lib.cleanSource i3path;
    })
    else null;

   i3pystatus-perso = super.i3pystatus.overrideAttrs (oldAttrs: {
	  name = "i3pystatus-dev";
	  # src = null; # super.lib.cleanSource ~/i3pystatus;
      propagatedBuildInputs = with self.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
	});

  # ranger = super.ranger.override ( { pythonPackages=super.python3Packages; });

   yst = super.haskellPackages.yst.overrideAttrs (oldAttrs: {
     jailbreak = true;
  });

  # offlineimap = super.offlineimap.overrideAttrs (oldAttrs: {
  #   # pygobject2
  #   # USERNAME 	echo " nix-shell -p python3Packages.secretstorage -p python36Packages.keyring -p python36Packages.pygobject3"
  #   propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ secretstorage keyring pygobject3  ];
  # });

  vdirsyncer-custom = super.vdirsyncer.overrideAttrs(oldAttrs: rec {

    doCheck=true; # doesn't work, checkPhase still happens
 
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
    ++ (with super.pkgs.python3Packages;
            [  keyring secretstorage pygobject3 ])
    ++ [ super.pkgs.liboauth super.pkgs.gobjectIntrospection];
  });

  # nix-shell -p python.pkgs.my_stuff

  rfc-bibtex = (super.rfx-bibtex  or (super.python3Packages.callPackage ./pkgs/rfc-bibtex {}));

  protocol-local = super.protocol.overrideAttrs (oldAttrs: {
    src=/home/teto/protocol;
  });

  # nixVeryUnstable = super.nixUnstable.overrideAttrs(o: {
  #   src = fetchGit https://github.com/NixOS/nix;
  #   nativeBuildInputs = with super.pkgs; (o.nativeBuildInputs or []) ++ [
  #     autoreconfHook autoconf-archive bison flex libxml2 libxslt
  #     docbook5 docbook5_xsl
  #   ];
  #   buildInputs = (o.buildInputs or []) ++ [ boost ];
  # });


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

  # iperf3_lkl = super.iperf3.overrideAttrs(old: {
  # });
}
