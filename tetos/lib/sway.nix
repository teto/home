{
  # key modifier
  mod = "Mod1";
  mad = "Mod4";

  # note that you can assign a workspace to a specific monitor !
  bind_ws =
    layout: workspace_id: fr:
    let
      ws = toString workspace_id;
    in
    {
      "$Group${layout}+$mod+${fr}" = ''workspace "''$${ws}"'';
      # "$GroupUs+$mod+${us}" = "workspace \"$w${ws}\"";
      "$Group${layout}+Shift+$mod+${fr}" = ''move container to workspace "''$${ws}"'';
      # "$GroupUs+Shift+$mod+${us}" = ''move container to workspace "$w${ws}"'';
    };

  move_focused_wnd = dir: fr: us: {
    "$GroupFr+$mod+Shift+${fr}" = "move ${dir}";
    "$GroupUs+$mod+Shift+${us}" = "move ${dir}";
  };

  wsAzertyBindings = {
    w1 = "a";
    w2 = "z";
    w3 = "e";
    w4 = "q";
    w5 = "s";
    w6 = "d";
    w7 = "w";
    w8 = "x";
    w9 = "c";
  };

  wsQwertyBindings = {
    w1 = "q";
    w2 = "w";
    w3 = "e";
    w4 = "a";
    w5 = "s";
    w6 = "d";
    w7 = "z";
    w8 = "x";
    w9 = "c";
  };

}
