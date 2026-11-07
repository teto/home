{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "delphiki";
  domain = "tarif_edf";
  version = "2.1.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "hass-tarif-edf";
    rev = "0acb9c4f036833675c25ff279106b7b4d5229e95";
    hash = lib.fakeHash;
  };

  meta = {
    description = "Home Assistant integration for EDF electricity rates";
    homepage = "https://github.com/delphiki/hass-tarif-edf";
    license = lib.licenses.mit;
  };
}
