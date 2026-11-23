# Noctalia v5 widgets specific to jedha.
# Widgets are declared here; their placement in the bar lives in the GUI state
# (~/.local/state/noctalia/settings.toml), which overrides config.toml.
#
# The llama widget is a local Luau plugin (built-in custom_button only has a
# static glyph). Plugins must be enabled once, and that state lives in
# settings.toml, so after the first switch run:
#   noctalia msg plugins enable teto/llama
{ pkgs, ... }:
let
  unit = "llama-cpp-default.service";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in
{
  xdg.dataFile."noctalia/plugins/llama/plugin.toml".text = ''
    id          = "teto/llama"
    name        = "llama.cpp toggle"
    version     = "1.0.0"
    plugin_api  = 24
    author      = "teto"
    icon        = "brain"
    description = "Shows and toggles ${unit}."

    [[widget]]
    id    = "status"
    entry = "widget.luau"
  '';

  xdg.dataFile."noctalia/plugins/llama/widget.luau".text = ''
    local UNIT = "${unit}"
    local SYSTEMCTL = "${systemctl} --user "

    -- systemctl is-active state -> { glyph, palette role }
    local LOOKS = {
      active       = { "brain", "primary" },
      activating   = { "loader-2", "tertiary" },
      deactivating = { "loader-2", "tertiary" },
      reloading    = { "loader-2", "tertiary" },
      failed       = { "alert-triangle", "error" },
    }
    local DEFAULT_LOOK = { "power", "on_surface_variant" } -- inactive / unknown

    local state = nil

    local function render(s)
      if s == state then return end
      state = s
      local look = LOOKS[s] or DEFAULT_LOOK
      barWidget.setGlyph(look[1])
      barWidget.setGlyphColor(look[2])
      barWidget.setTooltip(UNIT .. ": " .. s .. "\nleft click toggles, right click opens systemctl-tui")
    end

    local function refresh()
      noctalia.runAsync(SYSTEMCTL .. "is-active " .. UNIT, function(r)
        render((string.gsub(r.stdout, "%s+$", "")))
      end)
    end

    -- polled so external changes (crash, manual start) show up too
    function update()
      refresh()
    end

    function onClick()
      local verb = if state == "active" then "stop" else "start"
      render(if verb == "stop" then "deactivating" else "activating")
      noctalia.runAsync(SYSTEMCTL .. verb .. " " .. UNIT, function(r)
        if r.exitCode ~= 0 then
          noctalia.log(r.stderr)
        end
        refresh()
      end)
    end

    function onRightClick()
      noctalia.runAsync("kitty -e systemctl-tui")
    end

    noctalia.setUpdateInterval(3000)
    refresh()
  '';

  programs.noctalia.settings.widget = {
    llama = {
      type = "teto/llama:status";
    };
  };
}
