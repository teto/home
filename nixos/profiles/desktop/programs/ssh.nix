{

  # /etc/ssh/ssh_known_hosts
  knownHosts = {

    neotokyo = {
      publicKey = builtins.readFile ../neotokyo_host_key.pub;
    };
  };

}
