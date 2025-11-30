{
  enable = true;
  # bindings = [
  #   {
  #
  #     key = ..;
  #     command = "";
  #   }
  # ];

  settings = {
    # mpd_music_dir = PATH
    #    Search for files in specified directory. This is needed for tag editor to work.

    # mpdMusicDir
    lyrics_directory = "~/.lyrics";
    #lyrics_fetchers = tags, genius, tekstowo, plyrics, justsomelyrics, jahlyrics, zeneszoveg, internet
    #follow_now_playing_lyrics = no
    fetch_lyrics_for_current_song_in_background = "yes";
    store_lyrics_in_song_dir = "no";
    # allow_for_physical_item_deletion = no
    # screen_switcher_mode = playlist, browser
    # header_visibility = yes/no
    #        If enabled, header window will be displayed, otherwise hidden.
    #
    # statusbar_visibility = yes/no
    #        If enabled, statusbar will be displayed, otherwise hidden.
    #
    # connected_message_on_startup = yes/no
    #        Show the "Connected to ..." message on startup
    #
    # titles_visibility = yes/no
    #        If enabled, column titles will be displayed, otherwise hidden.
    #
    # header_text_scrolling = yes/no
    #        If enabled, text in header window will scroll if its length is longer then actual screen width, otherwise it won't.

    # user_interface = classic/alternative
  };
}
