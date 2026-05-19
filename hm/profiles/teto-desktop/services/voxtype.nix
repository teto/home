{
  enable = true;
  wayland.display = "wayland-1";

  loadModels = [ "base.en" ];

  # https://voxtype.io/docs/CONFIGURATION
  settings = {
    whisper = {
      model = "base";
      language = "fr";
      translate = false;
    };
    output = {
      # or "type"
      mode = "clipboard";
      fallback_to_clipboard = true;
      type_delay_ms = 0;
      auto_submit = true;
      notification = {
        on_recording_start = true;

        # Show notification when recording stops (transcription beginning)
        on_recording_stop = true;

        # Show notification with transcribed text after transcription completes
        on_transcription = true;
      };
    };

    # let compositor handle it
    hotkey = {
      enabled = false;
    };
  };

}
