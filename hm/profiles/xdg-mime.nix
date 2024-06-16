{
  config,
  pkgs,
  lib,
  ...
}:
{
  # as long as xdg doesn't accept symlinks (for which I proposed a patch)
  # and overrides my mimeapps.list
  xdg.mimeApps = {
    enable = false;
    associations = {
      added = {
        "video/x-matroska" = [ "mpv.desktop" ];
        "text/csv" = [ "sublime_text.desktop" ];
        "video/x-msvideo" = [ "mpv.desktop" ];
        "application/x-matroska" = [ "mpv.desktop" ];
        "text/x-csrc" = [ "gedit.desktop" ];
        "text/x-chdr" = [ "sublime_text.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/ftp" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "image/png" = "eog.desktop;sxiv.desktop";
        "image/jpeg" = "eog.desktop;sxiv.desktop";
        "text/plain" = "sublime_text.desktop";

      };

      removed = {
        "application/pdf" = "Mendeley.desktop";

      };
    };
  };
}
