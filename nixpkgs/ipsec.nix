{
}
  # IRC recommanded to 
    # environment.etc."ipsec.secrets".text = ''
    #   # this is checked by l2tp
    #   include /etc/ipsec.d/*.secrets
    #   '';
    #   environment.etc."ipsec.d/stub".text = ''
    #     stub file to create ipsec.d
    #   '';

  # # for ppp when it creates its resolv.conf
  # # maybe it should create it in /var/run
  # environment.etc."ppp/stub".text = ''
  # '';
