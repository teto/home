{ fishPlugins, fetchFromGitHub }:
fishPlugins.buildFishPlugin {
    pname = "tide-item-jj";
    version = "unstable-2026-05-27";

    src = fetchFromGitHub {
      owner = "lucasadelino";
      repo = "tide-item-jj";
      rev = "e1150b7332b85149b468cb10c2844f082f33975b";
      hash = "sha256-vLSrHPoytZ/kXQh0Bp/4AWe8YLlyufRjepfXUAuWCB8=";
    };
  }

