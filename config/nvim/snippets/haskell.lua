return {

}
-- snip({
--     trig = "meta",
--     namr = "Metadata",
--     dscr = "Yaml metadata format for markdown"
-- },
-- {
--     text({"---",
--     "title: "}), insert(1, "note_title"), text({"", 
--     "author: "}), insert(2, "author"), text({"", 
--     "date: "}), func(date, {}), text({"",
--     "categories: ["}), insert(3, ""), text({"]",
--     "lastmod: "}), func(date, {}), text({"",
--     "tags: ["}), insert(4), text({"]",
--     "comments: true",
--     "---", ""}),
--     insert(0)
--   }),
