{ pkgs, lib, ... }:
let
  # Upmpdcli replaces PYTHONPATH when launching plugins, so provide these
  # dependencies in the plugin wrapper rather than the systemd environment.
  pluginPythonPath =
    (lib.makeSearchPath pkgs.python3.sitePackages [
      pkgs.recoll
      pkgs.python3Packages.mutagen
      pkgs.python3Packages.legacy-cgi
      pkgs.python3Packages.waitress
    ])
    + ":${pkgs.recoll}/${pkgs.python3.sitePackages}/recoll";
  data = pkgs.runCommand "upmpdcli-data" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out
    cp -rs ${pkgs.upmpdcli}/share/upmpdcli/. $out/
    chmod u+w $out/cdplugins/uprcl
    unlink $out/cdplugins/uprcl/uprcl-app.py
    # Use Recoll's matching conftree module ahead of upmpdcli's older copy.
    makeWrapper ${pkgs.python3}/bin/python3 \
      $out/cdplugins/uprcl/uprcl-app.py \
      --add-flags ${pkgs.upmpdcli}/share/upmpdcli/cdplugins/uprcl/.uprcl-app.py-wrapped \
      --prefix PYTHONPATH : ${pluginPythonPath}
  '';
in
{
  enable = true;
  configuration = {
    # https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-manual.html
    friendlyname = "UpMpd";
    pkgdatadir = "${data}";
    mpdhost = "127.0.0.1";
    mpdport = 6600;
    ownqueue = 1;
    # seems to be a weird protocol that lets programs such as bubbleupnp or linn kazoo 
    # control the playlist
    openhome = 0;
    upnpav = 1;

    # The Yamaha browses MediaServers; the renderer alone is insufficient.
    msfriendlyname = "UpMpd Music";

    # initialize UPRCL local music server when upmpdcli starts, instead of waiting until a client first browses the library.
    uprclautostart = 1;
    uprclmediadirs = "/mnt/ext/music";
    uprclport = 9090;

    useipv6 = 0;
    # Use the amplifier's LAN, rather than Ethernet (10.0.0.x) or WireGuard.
    upnpiface = "wlan0";
    loglevel = 4;
    upnpport = 49152;
  };
}
