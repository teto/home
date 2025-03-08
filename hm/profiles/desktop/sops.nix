{
  secrets."gitlab/apiToken" = {
    mode = "400";
    # owner = config.users.users.teto.name;
    # group = config.users.users.teto.group;

  };

  secrets."OPENAI_API_KEY" = {
    # Key used to lookup in the sops file.
    key = "OPENAI_API_KEY_NOVA";
    mode = "400";
  };

  # lab_config_file
  # https://github.com/zaquestion/lab
  secrets."lab/lab.toml" = {
    key = "lab_config_file";
    # path = "/home/teto/.config/lab/lab.toml";
    # alternatively one can use
    # LAB_CORE_TOKEN
    # LAB_CORE_HOST
    mode = "400";
    # owner = config.users.users.teto.name;
    # group = config.users.users.teto.group;
  };

}
