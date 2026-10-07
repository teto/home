{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  # requests,
}:

buildHomeAssistantComponent rec {
  owner = "10der";
  domain = "awtrix_ng";
  version = "0.3.21";

  src = fetchFromGitHub {
    inherit owner;
    repo = "awtrix-ng-hass-integration";

    tag = "v0.2.3";
    # rev = "8180cef7b1837e85115ef7ece553e39b0f94ff4d";
    hash = "sha256-R9ICoOElPrv1ChBIe0oG8en4fN5IGVqy7lRA0DKu/30=";
  };

  dependencies = [
    # requests
  ];

  meta = {
    description = "Home-assistant integration for awtrix";
    homepage = "https://github.com/10der";
    # maintainers = with lib.maintainers; [ ];
    license = lib.licenses.mit;
  };
}
