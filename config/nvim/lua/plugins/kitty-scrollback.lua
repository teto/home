-- see https://github.com/mikesmithgh/kitty-scrollback.nvim#-filetypes
-- if you want to create autocommands

--
 --      myconfig = {
 --        kitty_get_text = {
 --          ansi = false,
 --        },
 --      },
 --      myfnconfig = function(kitty_data)
 --        return {
 --          kitty_get_text = {
 --            extent = (kitty_data.scrolled_by > kitty_data.lines) and 'all' or 'screen',
 --          },
 --        }
 --      end,
require('kitty-scrollback').setup(
    -- global configuration
    {
    kitty_get_text = {
      -- boolean If true, the text will include the ANSI formatting escape codes for colors,
      ansi = true,
      extent = 'all',
	 },
   -- scrollback_columns = 300,
   -- boolean? if true, writes the scrollback buffer to a temporary file (used for external
   scrollback_tempfile = false,
	  keymaps_enabled = false,
	  close_after_yank = true,
	  status_window = {

		   style_simple = true, -- user may not have Nerd Fonts installed
		 show_timer = true,

		  autoclose = true,
	   },
	   paste_window = {
      -- yank_register = '',
      -- boolean? If true, the yank_register copies content to the paste window. If false, d
	  -- -- isable yank to paste window
	  --    yank_register_enabled = false,
	   }
    }
)
