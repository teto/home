{ config, pkgs, ... }:

let

palettes = {
  solarized = {
    red     = "#dc322f";
    orange  = "#cb4b16";
    yellow  = "#b58900";
    green   = "#859900";
    cyan    = "#2aa198";
    blue    = "#268bd2";
    violet  = "#6c71c4";
    magenta = "#d33682";
    base0   = "#06080a";
    base1   = "#091f2e";
    base2   = "#586e75";
    base3   = "#657b83";
    base4   = "#839496";
    base5   = "#93a1a1";
    base6   = "#eee8d5";
    base7   = "#fdf6e3";
  };

  gotham = {
    red     = "#c23127";
    orange  = "#d26937";
    yellow  = "#edb443";
    green   = "#2aa889";
    cyan    = "#33859e";
    blue    = "#195466";
    violet  = "#4e5166";
    magenta = "#888ca6";
    base0   = "#0c1014";
    base1   = "#11151c";
    base2   = "#091f2e";
    base3   = "#0a3749";
    base4   = "#245361";
    base5   = "#599cab";
    base6   = "#99d1ce";
    base7   = "#d3ebe9";
  };

  nordLight = {
    red     = "#BF616A";
    orange  = "#D08770";
    yellow  = "#EBCB8B";
    green   = "#A3BE8C";
    cyan    = "#88C0D0";
    blue    = "#8FBCBB";
    violet  = "#5E81AC";
    magenta = "#B48EAD";
    base0   = "#2E3440";
    base1   = "#3B4252";
    base2   = "#434C5E";
    base3   = "#4C566A";
    base4   = "#616E88";
    base5   = "#D8DEE9";
    base6   = "#E5E9F0";
    base7   = "#ECEFF4";
  };

  materialLight = {
    red     = "#af0000";
    orange  = "#fb8c00";
    yellow  = "#fdd835";
    green   = "#43a047";
    cyan    = "#00acc1";
    blue    = "#3949ab";
    violet  = "#5e35b1";
    magenta = "#8e24aa";
    base0   = "#000000";
    base1   = "#222222";
    base2   = "#444444";
    base3   = "#666666";
    base4   = "#888888";
    base5   = "#aaaaaa";
    base6   = "#cccccc";
    base7   = "#ffffff";
  };
};

attrs = {
  bold = { bold = true; };
  italic = { italic = true; };
  underline = { underline = true; };
  reverse = { reverse = true; };
  undercurl = { undercurl = true; };
  standout = { standout = true; };
};

themes = builtins.mapAttrs (k: v: v // { black = v.base0; white = v.base7; }) {
  solarizedLight = with palettes.solarized; {
    primary = { fg = base7; bg = orange; };
    text = { fg = base0; bg = base7; };
    cursor = { fg = base7; bg = "#cf000f"; };
    comment = { fg = base4; };
    error = { fg = red; } // attrs.bold;
    string = { fg = green; };
    highlight = { fg = red; } // attrs.bold;
    suggestion = { fg = base1; };
    selectedSuggestion = { fg = base0; } // attrs.bold;
  } // palettes.solarized;

  gotham = with palettes.gotham; {
    primary = { fg = base7; bg = base0; };
    # TODO: replace this with a lighter/darker shade of primary
    primaryRaised = { fg = base7; bg = base3; };
    text = { fg = base6; bg = "#000000"; };
    cursor = { fg = base0; bg = "#72f970"; };
    comment = { fg = base4; };
    error = { fg = red; } // attrs.bold;
    string = { fg = cyan; } // attrs.italic;
    highlight = { fg = yellow; } // attrs.bold;
    suggestion = { fg = base5; };
    selectedSuggestion = { fg = base6; } // attrs.bold;
  } // palettes.gotham;
};

in

{
  lib.colors = {
    inherit attrs;
    theme = themes.gotham;
  };
}
