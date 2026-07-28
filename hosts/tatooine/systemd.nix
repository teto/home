{
  secretsFolder,
  ...
}:
{
  user.services.pipewire.environment = {
    # PIPEWIRE_DEBUG = "5";
  };

  # systemd.user.services.wireplumber.environment = {
  #     WIREPLUMBER_DEBUG="5";
  #   };
}
