https://ochronus.com/git-tips-from-the-trenches/

Miminize size of .git folders (like 8G on my linux folder)

Command advised/used by linus:
git repack -a -d --depth=250 --window=250

git gc --aggressive --prune
