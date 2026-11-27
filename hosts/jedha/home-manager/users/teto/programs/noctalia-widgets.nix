# Noctalia v5 widgets specific to jedha.
# Widgets are declared here; their placement in the bar lives in the GUI state
# (~/.local/state/noctalia/settings.toml), which overrides config.toml.
#
# The llama widget is a local Luau plugin (built-in custom_button only has a
# static glyph). Bar widgets cannot open native context menus (only panels
# can, via panel.openContextMenu), so right click toggles a small "menu"
# panel attached to the bar instead.
#
# Plugins must be enabled once, and that state lives in
# settings.toml, so after the first switch run:
#   noctalia msg plugins enable teto/llama
{ pkgs, ... }:
let
  unit = "llama-cpp-default.service";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  journalctl = "${pkgs.systemd}/bin/journalctl";
  # keep in sync with services.llama-cpp.instances.default.port
  webUrl = "http://127.0.0.1:9931";
in
{
  xdg.dataFile."noctalia/plugins/llama/plugin.toml".text = ''
    id          = "teto/llama"
    name        = "llama.cpp toggle"
    version     = "1.0.0"
    # 42: panel height = "content"
    plugin_api  = 42
    author      = "teto"
    icon        = "brain"
    description = "Shows and toggles ${unit}."

    [[widget]]
    id    = "status"
    entry = "widget.luau"

    [[panel]]
    id              = "menu"
    entry           = "menu.luau"
    width           = 240
    height          = "content"
    max_height      = 400
    placement       = "attached"
    open_near_click = true
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
      barWidget.setTooltip(UNIT .. ": " .. s .. "\nleft click toggles, right click opens the menu")
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
      noctalia.togglePanel("teto/llama:menu")
    end

    noctalia.setUpdateInterval(3000)
    refresh()
  '';

  xdg.dataFile."noctalia/plugins/llama/menu.luau".text = ''
    local UNIT = "${unit}"
    local SYSTEMCTL = "${systemctl}"
    local JOURNALCTL = "${journalctl}"
    local WEB_URL = "${webUrl}"

    local state = "unknown"

    -- runs `systemctl --user <verb> UNIT`, logging failures
    local function systemctl(verb)
      noctalia.runAsync({ SYSTEMCTL, "--user", verb, UNIT }, function(r)
        if r.exitCode ~= 0 then
          noctalia.notifyError("llama.cpp", verb .. " failed: " .. r.stderr)
        end
      end)
    end

    local function item(glyph, text, action, opts)
      opts = opts or {}
      return ui.button({
        key = text,
        glyph = glyph,
        text = text,
        variant = opts.variant or "ghost",
        contentAlign = "start",
        controlSize = "sm",
        enabled = opts.enabled ~= false,
        onClick = function()
          panel.close()
          action()
        end,
      })
    end

    local function render()
      local running = state == "active"
      panel.render(ui.column({ gap = 2, padding = 6 }, {
        ui.label({ text = "llama.cpp · " .. state, fontWeight = "bold", color = "primary" }),
        ui.separator({}),
        if running
          then item("player-stop", "Stop", function() systemctl("stop") end, { variant = "destructive" })
          else item("player-play", "Start", function() systemctl("start") end),
        item("refresh", "Restart", function() systemctl("restart") end),
        ui.separator({}),
        item("world", "Open web UI", function()
          noctalia.runAsync({ "xdg-open", WEB_URL })
        end, { enabled = running }),
        item("file-text", "Follow logs", function()
          noctalia.runAsync({ "kitty", "-e", JOURNALCTL, "--user", "-fu", UNIT })
        end),
        item("list-details", "systemctl-tui", function()
          noctalia.runAsync({ "kitty", "-e", "systemctl-tui" })
        end),
      }))
    end

    function onOpen()
      render() -- immediately, so the content-sized panel is not empty
      noctalia.runAsync({ SYSTEMCTL, "--user", "is-active", UNIT }, function(r)
        state = (string.gsub(r.stdout, "%s+$", ""))
        render()
      end)
    end
  '';

  programs.noctalia.settings.widget = {
    llama = {
      type = "teto/llama:status";
    };
  };
}
