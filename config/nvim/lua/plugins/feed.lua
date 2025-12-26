vim.g.feed_debug = true

require('feed').setup({
    -- picker = "fzf-lua",
    progress = 'bar',
    feeds = {
        -- These two styles both work
        -- "https://neovim.io/news.xml",
        -- {
        --     'https://www.reddit.com/r/NHKEasyNews.rss',
        --     name = 'NHK News Web easy (subreddit)',
        --     tags = { 'japanese' },
        -- },
        {
            'https://nhkeasier.com/feed/?no-furiganas',
            -- 'https://nhkeasier.com/feed/',
            name = 'NHK News Web easy',
            tags = { 'japanese' },
        },
        {
            'https://neovim.io/news.xml',
            name = 'Neovim News',
            tags = { 'tech', 'news' }, -- tags given are inherited by all its entries
        },
    },
})
