# global section. all windows will default to these settings
[global]
color = "#FFFFFF" # this must be a valid color
focused_color = "" # to disable a focused_color set this to ""
icon = "󰖯" # to disable a default icon just set this to ""
size = "14pt" # must be a valid pango size value
separator = "   " # anything between the icon and window title


# app_id section.  This does an exact string comparison to the app_id or
# window_properties.class value reported in swaymsg -t get_tree for the window
# It will be app_id for wayland apps and window_properties.class for X11 apps
[app_id]
chromium = { icon = "", color = "#a1c2fa", size = "13pt" }
firefox = { icon = "", color = "#ff8817" }
foot = { icon = "" }
neovide = { icon = "", color = "#8fff6d" }

# This does a regex match on the window title.  Matches from this section
# will take precedence over matches from the app_id section. A very basic
# algorithm is used to select the more exact regex if there are multiple
# matches. If 1 regex contains another it will choose the longer one. For
# instance mail\\.google\\.com and google\\.com/maps will be chosen over 
# google\\.com
[title]
# escape . for an exact match.  Normally . matches any character
"crates\\.io" = { icon = "󰏗", color = "#ffc933" }
"github\\.com" = { icon = "" }
"google\\.com" = { icon = "", color = "#4285f4" }
"google\\.com/maps" = { icon = "󰗵", color = "#4caf50" }
"mail\\.google\\.com" = { icon = "󰊫", color = "#ad1f1c" }

# use | for or
"sr\\.ht|sourcehut\\.org" = { icon = "" }

# can do an or around just a substring with (a|b)
"travis-ci\\.(com|org)" = { icon = "", color = "#cd324a" } 

# The app_id setting means that this will only match if both the title matches
# the regex and the app_id or window_properties.class equals one of the values
# provided in the app_id array
# For example this allows a vim logo in the terminal but keeps a github logo
# when viewing a github page with vim in the repository name
vim = { app_id = ["foot", "Alacritty"], icon = "", color = "#8fff6d" }
