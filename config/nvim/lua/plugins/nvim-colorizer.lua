-- can be forced via :ColorizerAttachToBuffer
-- Attach to certain Filetypes, add special configuration for `html`
-- Use `background` for everything else.
require 'colorizer'.setup {
  -- 'css';
  -- 'javascript';
  'terminal';
  html = {
    mode = 'foreground';
  }
}
