return {
s({
    trig = "hmod",
    namr = "Metadata",
    dscr = "Yaml metadata format for markdown"
},
{

    -- t({"---",
    -- "title: "}), i(1, "note_title"), t({"", 
    -- "author: "}), i(2, "author"), t({"", 
    -- "date: "}), f(date, {}), t({"",
    -- "categories: ["}), i(3, ""), t({"]",
    -- "lastmod: "}), f(date, {}), t({"",
    -- "tags: ["}), i(4), t({"]",
    -- "comments: true",

    t({"{-", "Module:"}), i(1, "Module"),
    t({"Description :"}), i(2, "Description"),
    t({"Maintainer  : matt", "-}"})

  }),

}
