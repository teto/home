-- fmt returns a table of nodes, not a node.
return {
    -- ri(1) --repeats inserted text after jump from insert node
    s('nixmod', {
        t({ '{ config, lib, pkgs, ... }:', 'let', 'cfg = config.programs.neovim;' }),
        t({ '', 'in', '{' }),
        t({ '', '\toptions = {', '', '\t', 'programs.neovim = {' }),
        t({
            '',
            '\t\tconfig = mkOption {',
            'type = types.nullOr types.lines;',
            'description = "Script to configure this plugin. The scripting language should match type.";',
            'default = null;',
            '}',
            '',
        }),
        i(1, 'programs.toto = '),
        t({ '', '}' }),
    }),

    s('nixprof', {
        t({ '{ config, lib, pkgs, ... }:', '{', '\t' }), -- , t({"{"})
        i(1, 'programs.toto = '),
        t({ '', '}' }),
    }),

	s('mod2', 
	 -- format node is pretty cool
	 fmt([[
	 {{ config, lib, pkgs, ... }}:
	 let
		cfg = config.programs.{};
	 in
	 {{
		imports = [];
		options = {{
		enable = lib.mkEnableOption "Neovim";

		viAlias = lib.mkOption {{
		  type = lib.types.bool;
		  default = false;
		  description = '''';
		}};

	   }};

	   config = lib.mkIf cfg.enable {{


		# ....
	   }};

	 }}

	 ]], {
	   i(1, "feature"),
	})

	)
}
