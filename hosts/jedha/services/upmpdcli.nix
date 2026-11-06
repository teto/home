/*
upmpdcli is a bridge: it receives UPnP commands and controls an MPD server. The UPnP player itself doesn’t play the song; MPD fetches and plays it. So when you choose a track in rmpd, it    
  should change playback if rmpd and upmpdcli are controlling the same MPD instance
 
  • MPD browsing UPnP servers: MPD has a built-in UPnP/DLNA database plugin (available in MPD 0.19+ configured with --enable-upnp) that lets MPD act as a client to browse and stream music from UPnP media servers. You browse the server's folder and directory trees using a standard MPD client, though direct tag-based queries (like artist/album/genre database searches) and saving playlists directly can have limitations.
• Using MPD as a UPnP Renderer (upmpdcli): If you want to send music from an external UPnP control point (such as BubbleUPnP on your phone) to MPD, you use a front-end like upmpdcli. In this setup, the control point talks UPnP to upmpdcli, which translates the commands into the MPD protocol to populate and control the local MPD playlist.

mpd now has a plugin that can play music from upnp server 
https://www.lesbonscomptes.com/pages/mpd-upnp.html#_introduction
*/

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
  # I understood this wrong. It lets an mpd client discover media via upnp while I wanted to do the opposite
  enable = false;
  configuration = {
    # https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-manual.html
    friendlyname = "UpMpd";
    pkgdatadir = "${data}";
    mpdhost = "127.0.0.1";
    mpdport = 6600;
    # try to see if I can control it myself
    ownqueue = 0;
    # seems to be a weird protocol that lets programs such as bubbleupnp or linn kazoo 
    # control the playlist. The client can disconnect after playlist  was created
    openhome = 0;
    upnpav = 1;

    # The Yamaha browses MediaServers; the renderer alone is insufficient.
    msfriendlyname = "UpMpd Music";

    # uprcl is a built-in UPnP Media Server plugin that allows upmpdcli to expose and share local audio files (music libraries stored on your computer or server) over the UPnP network
    # I could have used my minidlna server instead ?
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
