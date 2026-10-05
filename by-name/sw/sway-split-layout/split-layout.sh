command="$(swaymsg -t get_tree | jq -er '
  def focused_layout(parent_type):
    if .focused then
      if .type == "workspace" or parent_type == "workspace" then
        "layout tabbed"
      else
        "splitv"
      end
    else
      .type as $parent_type
      | (.nodes[]?, .floating_nodes[]?)
      | focused_layout($parent_type)
    end;
  focused_layout(null)
')"

swaymsg "$command"
