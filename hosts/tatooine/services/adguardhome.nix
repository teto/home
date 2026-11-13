{ flakeSelf, ... }:
{

  _imports = [
    flakeSelf.nixosProfiles.adguardhome
  ];

  enable = true;

  settings = {

    # http (since v0.107.36): Web interface configuration.
    # address: Web interface IP address with port to listen on    
    http.address = "127.0.0.1:8084";

  };

}
