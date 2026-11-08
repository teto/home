# it's gerbera in fact
{ pkgs, ... }:
let 
  freeboxRevolution6Mappings = ''
      <mappings>
        <extension-mimetype ignore-unknown="no">
        <map from="avi" to="video/x-msvideo"/>
        <map from="flv" to="video/x-flv"/>
        <map from="mkv" to="video/x-matroska"/>
        <map from="m2t" to="video/mp2t"/>
        <map from="m2ts" to="video/mp2t"/>
        <map from="mp4" to="video/mp4"/>
        <map from="mov" to="video/quicktime"/>
        <map from="mts" to="video/mp2t"/>
        <map from="ts"  to="video/mp2t"/>
        <map from="wmv" to="video/x-ms-wmv"/>
        <map from="mpa" to="video/mpeg"/>
        <map from="mpe" to="video/mpeg"/>
        <map from="mpeg" to="video/mpeg"/>
        <map from="mpg" to="video/mpeg"/>
        <map from="mpv2" to="video/mpeg"/>
        <map from="ogv" to="video/ogg"/>
        <map from="ogm" to="video/ogg"/>
        <map from="wmv" to="video/x-ms-wmv"/>
        <map from="wmv" to="video/x-ms-wmv"/>

        <map from="flac" to="audio/x-flac"/>
        <map from="mka" to="audio/x-matroska"/>
        <map from="mp2" to="audio/mpeg"/>
        <map from="mp3" to="audio/mpeg"/>
        <map from="oga" to="audio/ogg"/>
        <map from="wma" to="audio/x-ms-wma"/>
        
        <map from="jpe" to="image/jpeg"/>
        <map from="jpeg" to="image/jpeg"/>
        <map from="jpg" to="image/jpeg"/>
        <map from="gif" to="image/gif"/>
        <map from="png" to="image/png"/>
        
        <map from="ogg" to="application/ogg"/>
        <map from="ogx" to="application/ogg"/>
        <!-- /freebox V6 -->
        
        <map from="3gp" to="video/3gpp"/>
        <map from="asf" to="video/x-ms-asf"/>
        <map from="asr" to="video/x-ms-asf"/>
        <map from="asx" to="video/x-ms-asf"/>
        <map from="lsf" to="video/x-la-asf"/>
        <map from="lsx" to="video/x-la-asf"/>
        <map from="movie" to="video/x-sgi-movie"/>
        <map from="qt" to="video/quicktime"/>
        <map from="rv" to="video/vnd.rn-realvideo"/>
        <map from="wm"  to="video/x-ms-wm"/>
        <map from="wmx" to="video/x-ms-wmx"/>
        <map from="wvx" to="video/x-ms-wvx"/>

        <map from="aif" to="audio/x-aiff"/>
        <map from="aifc" to="audio/x-aiff"/>
        <map from="aiff" to="audio/x-aiff"/>
        <map from="au" to="audio/basic"/>
        <map from="kar" to="audio/midi"/>
        '';

in
{
  enable = true;
  openFirewall = true;

  # to avoid having to rewire the permissions
  group = "minidlna";
  interface="wlp2s0";
  transcoding = true;

#   # https://www.universfreebox.com/article/13461/Freebox-Revolution-Quels-sont-les-formats-audios-et-videos-supportes
# # Les codecs vidéos :
# #  H.264 ;
# #  MPEG2 ;
# #  MS-MPEG4 (DivX 3) ;
# #  MPEG4 (DivX 4, DivX 5, DivX 6, Xvid) ;
# #  VC1.
# #
# # Les codecs audios :
# # en decode :
# #  AAC, ;
# #  M Dolby Digital (downmix 2.0) ;
# #  Dolby Digital Plus(downmix 2.0)
# #  DTS core (downmix 2.0) ;
# #  FLAC ;
# #  MP2 ;
# #  MP3 ;
# #  Vorbis.
# #
# # en passthrough (via la sortie HDMI) :
# #  AAC ;
# #  Dolby Digital ;
# #  Dolby Digital Plus ;
# #  Dolby Digital TrueHD ;
# #  DTS ;
# #  DTS-HD (MA et HRA). 
# # d'apres
# # https://www.universfreebox.com/article/13461/Freebox-Revolution-Quels-sont-les-formats-audios-et-videos-supportes

  # Configured the Freebox transcode profiles through services.mediatomb.transcodingProfiles and MIME mappings in mediatomb.nix (hosts/tatooine/services/mediatomb.nix). Video transcodes to H.264/AAC in MPEG-TS; Ogg audio transcodes to AAC.
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
