{
  # if time is wrong:
  # 1/ systemctl stop chronyd.service
  # 2/ "sudo chronyd -q 'pool pool.ntp.org iburst'"
  enable = true;

  # to correct big errors on startup
  initstepslew = {
    enabled = true;
    threshold = 100;
  };

  # we allow chrony to make big changes at
  # see https://chrony.tuxfamily.org/faq.html#_is_chronyd_allowed_to_step_the_system_clock
  extraConfig = ''
    makestep 1 -1
  '';
}
