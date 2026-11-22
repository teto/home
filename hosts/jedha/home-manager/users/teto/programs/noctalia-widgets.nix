# Noctalia v5 widgets specific to jedha.
# Widgets are declared here; their placement in the bar lives in the GUI state
# (~/.local/state/noctalia/settings.toml), which overrides config.toml.
{ pkgs, ... }:
let
  # toggle a systemd user unit and notify about the new state
  toggleUnit =
    unit:
    pkgs.writeShellScript "toggle-${unit}" ''
      if ${pkgs.systemd}/bin/systemctl --user is-active -q ${unit}; then
        ${pkgs.systemd}/bin/systemctl --user stop ${unit}
      else
        ${pkgs.systemd}/bin/systemctl --user start ${unit}
      fi
      ${pkgs.libnotify}/bin/notify-send -a noctalia "${unit}" \
        "$(${pkgs.systemd}/bin/systemctl --user is-active ${unit})"
    '';
in
{
  programs.noctalia.settings.widget = {
    llama = {
      type = "custom_button";
      glyph = "brain";
      tooltip = "llama-cpp-default: left click toggles, right click opens systemctl-tui";
      actions = {
        left = "exec ${toggleUnit "llama-cpp-default.service"}";
        right = "exec kitty -e systemctl-tui";
      };
    };
  };
}
