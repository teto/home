{
  # config,
  # lib,
  pkgs,
  ...
}:
{

  # programs.astroid = {
  enable = false;
  # TODO factor with my mbsyncwrapper ?
  pollScript = ''
    check-mail.sh gmail
  '';

  # TODO sendMailCommand
  # I don't want it to trigger
  # P => main_window.poll
  extraConfig = {
    poll.interval = 0;
    # TODO use "killed"
    startup.queries = {
      # "Unread iij"= "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:coudron@iij.ad.jp";
      "Unread gmail" =
        "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:mattator@gmail.com";
      "Flagged" = "tag:flagged";
      # "Drafts"= "tag:draft";
      "fastmail" =
        "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:matthieucoudron@fastmail.com";
      # "nova"= "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:mattator@gmail.com";
      "ietf" = "tag:ietf";
      "gh" = "tag:gh";
    };
  };

  externalEditor = ''
    ${pkgs.kitty}/bin/kitty nvim -c 'set ft=mail' '+set fileencoding=utf-8' '+set ff=unix' '+set enc=utf-8' '+set fo+=w' %1
  '';
  # };
}
