{ fishPlugins, fetchFromGitHub }:
fishPlugins.buildFishPlugin {
  pname = "tide-item-jj";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "lucasadelino";
    repo = "tide-item-jj";
    rev = "2eff634fc27d3591f6580d3a9d40055ad3852276";
    hash = "sha256-E14NGa1NsRaHoL1s3sW7DSpVb0epCZd6zwiAhnXjZqg=";
  };
}
