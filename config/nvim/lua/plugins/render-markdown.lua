-- https://github.com/MeanderingProgrammer/render-markdown.nvim
require('render-markdown').setup({
    -- enabled = true,
    -- debounce = 100,
    log_level = 'error',
    log_runtime = false,
    -- to appease checkhealth
    -- use recommended settings from above
    file_types = { 'markdown', 'Avante', 'markdown.Avante' },
    anti_conceal = {
        -- This enables hiding added text on the line the cursor is on.
        enabled = true,
        -- Modes to disable anti conceal feature.
        disabled_modes = false,
	   },
    padding = {
        -- Highlight to use when adding whitespace, should blend in with background.
        highlight = 'RenderMarkdownPadding',
    },
    completions = {
        -- Settings for blink.cmp completions source
        blink = { enabled = true },
	},
    heading = {
        -- Useful context to have when evaluating values.
        -- | level    | the number of '#' in the heading marker         |
        -- | sections | for each level how deeply nested the heading is |

        -- Turn on / off heading icon & background rendering.
        enabled = true,
        -- Additional modes to render headings.
        render_modes = false,
        -- Turn on / off atx heading rendering.
        atx = true,
        -- Turn on / off setext heading rendering.
        setext = true,
        -- Turn on / off sign column related rendering.
        sign = true,
        -- Replaces '#+' of 'atx_h._marker'.
        -- Output is evaluated depending on the type.
        -- | function | `value(context)`              |
        -- | string[] | `cycle(value, context.level)` |
        icons = {
		  '󰲡 ',
		  '󰲣 ',
		  '󰲥 ',
		  '󰲧 ',
		  '󰲩 ',
		  '󰲫 '
		 },
        -- Determines how icons fill the available space.
        -- | eol     | '#'s are concealed and icon is placed at right most column   |
        -- | right   | '#'s are concealed and icon is appended to right side        |
        -- | inline  | '#'s are concealed and icon is inlined on left side          |
        -- | overlay | icon is left padded with spaces and overlayed hiding all '#' |
        position = 'overlay',
        -- Added to the sign column if enabled.
        -- Output is evaluated by `cycle(value, context.level)`.
        signs = { '󰫎 ' },
        -- Width of the heading background.
        -- | block | width of the heading text |
        -- | full  | full width of the window  |
        -- Can also be a list of the above values evaluated by `clamp(value, context.level)`.
        width = 'full',
        -- Amount of margin to add to the left of headings.
        -- Margin available space is computed after accounting for padding.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        -- Can also be a list of numbers evaluated by `clamp(value, context.level)`.
        left_margin = 0,
        -- Amount of padding to add to the left of headings.
        -- Output is evaluated using the same logic as 'left_margin'.
        left_pad = 2,
        -- Amount of padding to add to the right of headings when width is 'block'.
        -- Output is evaluated using the same logic as 'left_margin'.
        right_pad = 0,
        -- Minimum width to use for headings when width is 'block'.
        -- Can also be a list of integers evaluated by `clamp(value, context.level)`.
        min_width = 0,
        -- Determines if a border is added above and below headings.
        -- Can also be a list of booleans evaluated by `clamp(value, context.level)`.
        border = false,
        -- Always use virtual lines for heading borders instead of attempting to use empty lines.
        border_virtual = false,
        -- Highlight the start of the border using the foreground highlight.
        border_prefix = false,
        -- Used above heading for border.
        above = '▄',
        -- Used below heading for border.
        below = '▀',
        -- Highlight for the heading icon and extends through the entire line.
        -- Output is evaluated by `clamp(value, context.level)`.
        backgrounds = {
            'RenderMarkdownH1Bg',
            'RenderMarkdownH2Bg',
            'RenderMarkdownH3Bg',
            'RenderMarkdownH4Bg',
            'RenderMarkdownH5Bg',
            'RenderMarkdownH6Bg',
        },
        -- Highlight for the heading and sign icons.
        -- Output is evaluated using the same logic as 'backgrounds'.
        foregrounds = {
            'RenderMarkdownH1',
            'RenderMarkdownH2',
            'RenderMarkdownH3',
            'RenderMarkdownH4',
            'RenderMarkdownH5',
            'RenderMarkdownH6',
        },
        -- Define custom heading patterns which allow you to override various properties based on
        -- the contents of a heading.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | pattern    | matched against the heading text @see :h lua-patterns |
        -- | icon       | optional override for the icon                        |
        -- | background | optional override for the background                  |
        -- | foreground | optional override for the foreground                  |
        custom = {},
    },
    paragraph = {
        -- Useful context to have when evaluating values.
        -- | text | text value of the node |

        -- Turn on / off paragraph rendering.
        enabled = true,
        -- Additional modes to render paragraphs.
        render_modes = false,
        -- Amount of margin to add to the left of paragraphs.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        -- Output is evaluated depending on the type.
        -- | function | `value(context)` |
        -- | number   | `value`          |
        left_margin = 3,
        -- Amount of padding to add to the first line of each paragraph.
        -- Output is evaluated using the same logic as 'left_margin'.
        indent = 0,
        -- Minimum width to use for paragraphs.
        min_width = 0,
    },
    html = {
        -- Turn on / off all HTML rendering.
        enabled = true,
        -- Additional modes to render HTML.
        render_modes = false,
        comment = {
            -- Useful context to have when evaluating values.
            -- | text | text value of the comment node |

            -- Turn on / off HTML comment concealing.
            conceal = true,
            -- Text to inline before the concealed comment.
            -- Output is evaluated depending on the type.
            -- | function | `value(context)` |
            -- | string   | `value`          |
            -- | nil      | nothing          |
            text = nil,
            -- Highlight for the inlined text.
            highlight = 'RenderMarkdownHtmlComment',
        },
        -- HTML tags whose start and end will be hidden and icon shown.
        -- The key is matched against the tag name, value type below.
        -- | icon            | optional icon inlined at start of tag           |
        -- | highlight       | optional highlight for the icon                 |
        -- | scope_highlight | optional highlight for item associated with tag |
        tag = {},
    },
})
