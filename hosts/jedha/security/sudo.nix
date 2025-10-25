{
  config,
  lib,
  pkgs,
  ...
}:
{
  # programs.toto =
  # defaultOptions =

  # execWheelOnly
  # extraOptions
  # https://wiki.archlinux.org/title/sudo#Add_terminal_bell_to_the_password_prompt
  # timestamp_type=global prevents sudo prompt for new terminals
  extraConfig = ''
    Defaults        passprompt="[sudo] password for %p: ", timestamp_timeout=360, timestamp_type=global
  '';

}
