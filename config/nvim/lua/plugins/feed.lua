require("feed").setup({
   feeds = {
      -- These two styles both work
      -- "https://neovim.io/news.xml",
	  {
	   "https://www.reddit.com/r/NHKEasyNews.rss",
	   name = "NHK News Web easy (subreddit)",
	   tags = {"japanese"}
	  },
      {
         "https://neovim.io/news.xml",
         name = "Neovim News",
         tags = { "tech", "news" }, -- tags given are inherited by all its entries
      },
	}
   })
