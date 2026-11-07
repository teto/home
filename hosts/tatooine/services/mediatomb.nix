# it's gerbera in fact
{ pkgs, ... }:
{
  enable = true;
  openFirewall = true;

  # to avoid having to rewire the permissions
  group = "minidlna";
  interface="wlp2s0";
  transcoding = true;
  transcodingMimeMappings = [
    ''<transcode mimetype="video/x-flv" using="freebox-h264" />''
    ''<transcode mimetype="application/ogg" using="freebox-h264" />''
    ''<transcode mimetype="video/x-matroska" using="freebox-h264" />''
    ''<transcode mimetype="video/x-msvideo" using="freebox-h264" />''
    ''<transcode mimetype="audio/ogg" using="freebox-aac" />''
  ];
  transcodingProfiles = [
    ''
      <profile name="freebox-h264" enabled="yes" type="external">
        <mimetype>video/mpeg</mimetype>
        <accept-url>no</accept-url>
        <first-resource>yes</first-resource>
        <accept-ogg-theora>no</accept-ogg-theora>
        <agent command="${pkgs.ffmpeg}/bin/ffmpeg"
          arguments="-i %in -c:v libx264 -preset veryfast -crf 23 -c:a aac -b:a 192k -f mpegts %out" />
        <buffer size="14400000" chunk-size="512000" fill-size="120000" />
      </profile>
    ''
    ''
      <profile name="freebox-aac" enabled="yes" type="external">
        <mimetype>audio/aac</mimetype>
        <accept-url>no</accept-url>
        <first-resource>yes</first-resource>
        <accept-ogg-theora>no</accept-ogg-theora>
        <agent command="${pkgs.ffmpeg}/bin/ffmpeg"
          arguments="-i %in -vn -c:a aac -b:a 192k -f adts %out" />
        <buffer size="1048576" chunk-size="131072" fill-size="262144" />
      </profile>
    ''
  ];

  # 49152 already used by mdp
  port = 49153;
  mediaDirectories=  [
      {
        hidden-files = false;
        path = "/home/teto/videos";
        recursive = true;
      }
      {
        hidden-files = false;
        path = "/home/teto/Music";
        recursive = true;
      }

    ];


}
