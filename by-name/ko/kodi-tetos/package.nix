{ kodi, makeWrapper }:

let
  kodiWithPackages = kodi.withPackages (p: with p; [
    jellyfin
    # pvr-iptvsimple
    vfs-sftp
  ]);
in
kodiWithPackages.overrideAttrs (oldAttrs: {
  nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ makeWrapper ];

  postFixup = (oldAttrs.postFixup or "") + ''
    wrapProgram $out/bin/kodi --set DISPLAY ':0'
  '';
})
