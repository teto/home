{ lib, ... }:
{
  difftastic.enableAsDifftool  = true;
  # userEmail = "tiny.idea7043@fastmail.com";
  userEmail = lib.mkForce "886074+teto@users.noreply.github.com";
  signing = {
    signByDefault = false;

    # key = "64BB6787"; # old key
    key = "88A4D2369454E51E"; # new key
  };

}
