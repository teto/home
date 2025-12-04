{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python with vosk package
    (python3.withPackages (ps: with ps; [
      # vosk
      # Development tools
      black
      # Testing tools
      pytest
    ]))

    # Audio recording utilities (choose one or have multiple available)
    pulseaudio  # provides parec command
    sox         # alternative audio recording
    pipewire    # provides pw-cat command

    # Input simulation utilities (choose one or have multiple available)
    xdotool     # X11 input simulation (default)
    ydotool     # Wayland/X11/TTY input simulation
    dotool      # Wayland/X11/TTY input simulation
    wtype       # Wayland input simulation

    # Optional: useful development tools
    git
  ];

  shellHook = ''
    echo "nerd-dictation development environment"
    echo ""
    echo "Available audio recording tools:"
    echo "  - parec (PulseAudio)"
    echo "  - sox"
    echo "  - pw-cat (PipeWire)"
    echo ""
    echo "Available input simulation tools:"
    echo "  - xdotool (X11)"
    echo "  - ydotool (Wayland/X11/TTY)"
    echo "  - dotool (Wayland/X11/TTY)"
    echo "  - wtype (Wayland)"
    echo ""
    echo "To get started:"
    echo "  1. Download a VOSK model from https://alphacephei.com/vosk/models"
    echo "  2. Extract and place it in ~/.config/nerd-dictation/model"
    echo "  3. Run: ./nerd-dictation begin --vosk-model-dir=./model"
    echo ""
    echo "Python version: $(python --version)"
  '';
}
