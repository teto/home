self: super:
let
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");
  # won't work on sandboxed
  wiresharkFolder = /home/teto/wireshark;

  src = self.fetchFromGitHub {
      repo   ="wireshark";
      owner  ="teto";
      rev    = "64b95dcb205842e4e8a9cc18cd5283ebdba2c48f";
      sha256 = "13aax31gryfbc4fmhpi7xv8q5macpbdr2093jz52l44zm4gh3i46";
    };
in
  {

  wireshark-dev-stable = super.wireshark.overrideAttrs (oldAttrs: {
    name = "wireshark-dev-stable";
    inherit src;
     hardeningDisable = ["all"];
  });

  tshark-dev-stable = super.tshark.overrideAttrs (oldAttrs: {
    name = "wireshark-dev-stable";
    inherit src;
  });

  wireshark-local = super.wireshark.overrideAttrs (oldAttrs: {
    name = "wireshark-dev";
    src = filter-cmake wiresharkFolder;
  });

  wireshark-local-stable = super.wireshark.overrideAttrs (oldAttrs: {
    # pygobject2
    name = "wireshark-local-stable";
    src = builtins.fetchGit {
      url = wiresharkFolder;
      # rev = "reinject_stable";
      # sha256 = "0pbmdwphmz4c6g9rvi58kmjhkvhy5ys5y8dzl2cfh8w00jc62cn0";
    };
  });


  tshark-local = super.tshark.overrideAttrs (oldAttrs: {
    # pygobject2
    name = "tshark-dev";
    src = filter-cmake wiresharkFolder;
    # src = builtins.fetchgit {
    #   url = wiresharkFolder;
    #   rev = "reinject_stable";
    #   # sha256 = "0pbmdwphmz4c6g9rvi58kmjhkvhy5ys5y8dzl2cfh8w00jc62cn0";
    # };

    # write in .nvimrc
    nvimrc = super.pkgs.writeText "_nvimrc" ''
        " to deal with cmake build folder
        let &makeprg="make -C build"
      '';
  });

  tshark-reinject-stable = self.tshark-local.overrideAttrs (oldAttrs: {
    name = "tshark-local-stable";
    src = self.fetchFromGitHub {
      repo="wireshark";
      owner="teto";
      rev = "mptcp_fix";
      sha256 = "0q1lqh0zbjz0bgppy3bc6dlravifja49arv1m4yd3jz55ify3anv";
    };
  });
}
