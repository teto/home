return {
 -- ri(1) --repeats inserted text after jump from insert node
    s("nixmod", {
      t({"{ config, lib, pkgs, ... }:", "let",
      "cfg = config.programs.neovim;"})
      , t({"", "in", "{"})
      , t({"", "\toptions = {", "", "\t", "programs.neovim = {"})
      , t({"", "\t\tconfig = mkOption {",
          "type = types.nullOr types.lines;",
          "description = \"Script to configure this plugin. The scripting language should match type.\";",
          "default = null;",
          "}", ""})
      , i(1, "programs.toto = ")
      , t({"", "}"})
     }),

    s("nixprof", {
      t({"{ config, lib, pkgs, ... }:", "{", "\t"})
      -- , t({"{"})
      , i(1, "programs.toto = ")
      , t({"", "}"})
     })
    }
