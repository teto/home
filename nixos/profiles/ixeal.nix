{

  imports = [
    # flakeSelf.nixosProfiles.docling-serve
  ];

    # temporary hack
  networking.extraHosts = ''
    192.168.6.184 p7
    '';

}
