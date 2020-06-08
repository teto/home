
# not loaded automatically when config.py exists
config.load_autoconfig()

# c.url.start_pages = ["https://www.qutebrowser.org/"]


  # url.default_page:
  #   global: /home/teto/home/homepage.html

# TODO to set homepage.html
c.url.default_page = str(config.configdir / 'homepage.html')
# config.set('content.javascript.enabled', False)

# per domain settings
# with config.pattern('*://example.com/') as p:
#     p.content.images = False


# content.host_blocking.enabled
# content.host_blocking.lists (Current: ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"])
# whitelist
c.content.host_blocking.lists.append( str(config.configdir) + "/blockedHosts")
c.content.host_blocking.whitelist.append( 'collector.githubapp.com')
