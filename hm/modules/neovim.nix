{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:

with lib;

let
  cfg = config.programs.neovim;

  luaPlugin =
    attrs:
    attrs
    // {
      type = "lua";
      # config = lib.optionalString
      #   (attrs ? config && attrs.config != null)
      #   (genBlockLua attrs.plugin.pname attrs.config)
      #   ;
    };

  blinkPlugins = [
    pkgs.vimPlugins.blink-cmp # replace cmp-nvim
    # flakeSelf.inputs.blink-cmp.packages.${pkgs.stdenv.hostPlatform.system}.blink-cmp
    # pkgs.vimPlugins.blink-cmp-git # autocomplete github issues/PRs
  ];

  orgmodePlugins = with pkgs.vimPlugins; [
    # TODO add     'mrshmllow/orgmode-babel.nvim',

    # (luaPlugin {
    #   # matches nvim-orgmode
    #   plugin = orgmode;
    #   config = # lua
    #     ''
    #     require('orgmode').setup{
    #         org_capture_templates = {'~/nextcloud/org/*', '~/orgmode/**/*'},
    #         org_default_notes_file = '~/orgmode/refile.org',
    #         -- TODO add templates
    #         org_agenda_templates = { t = { description = 'Task', template = '* TODO %?\n  %u' } },
    #     }
    #     '';
    # })
  ];

  fennelPlugins = with pkgs.vimPlugins; [
    # {  plugin = aniseed;
    # runtime = {
    #      "ftplugin/c.vim".text = "setlocal omnifunc=v:lua.vim.lsp.omnifunc";
    # # "zaz".text = ''
    # # -- test fennel
    # #  '';
    # };
    # # " let g:aniseed#env = v:true
    # # " lua require('aniseed.env').init()
    #  # }
    # }

    # (luaPlugin {
    #   plugin = hotpot-nvim;
    #   # type = "lua";
    #   config = ''
    #    require("hotpot").setup({
    #      -- allows you to call `(require :fennel)`.
    #      -- recommended you enable this unless you have another fennel in your path.
    #      -- you can always call `(require :hotpot.fennel)`.
    #      provide_require_fennel = false,
    #      -- show fennel compiler results in when editing fennel files
    #      enable_hotpot_diagnostics = true,
    #      -- compiler options are passed directly to the fennel compiler, see
    #      -- fennels own documentation for details.
    #      compiler = {
    #        -- options passed to fennel.compile for modules, defaults to {}
    #        modules = {
    #          -- not default but recommended, align lua lines with fnl source
    #          -- for more debuggable errors, but less readable lua.
    g
    #          -- correlate = true
    #        },
    #        -- options passed to fennel.compile for macros, defaults as shown
    #        macros = {
    #          env = "_COMPILER" -- MUST be set along with any other options
    #        }
    #      }
    #    })
    #    '';
    # })
  ];

  treesitterPlugins = [
    pkgs.vimPlugins.nvim-treesitter-pairs
    pkgs.vimPlugins.nvim-treesitter-textobjects
    pkgs.vimPlugins.nvim-treesitter-parsers.nix
    pkgs.vimPlugins.nvim-treesitter-parsers.json

    # query is already provided by neovim
    # pkgs.vimPlugins.nvim-treesitter-parsers.query
  ];

  treesitterModule = types.submodule {
    options = {
      enable = mkEnableOption "Treesitter";

      plugins = mkOption {
        # type = types.listOf types.package;
        default = treesitterPlugins;
        # [];
      };
    };
  };

  neorgModule = types.submodule {
    options = {

      enable = mkEnableOption "Neorg";

      plugins = mkOption {
        # type = types.listOf types.package;
        default = [
          (luaPlugin { plugin = vimPlugins.neorg-telescope; })
        ];
        description = "toto";
      };
    };
  };

  orgmodeModule = types.submodule {
    options = {

      enable = mkEnableOption "Orgmode";

      plugins = mkOption {
        # type = types.listOf types.package;
        default = orgmodePlugins;
        description = "The file extension to use.";
      };
    };
  };

  fennelModule = types.submodule {
    options = {
      enable = mkEnableOption "Fennel";
      plugins = mkOption {
        # type = types.listOf types.package;
        default = fennelPlugins;
        description = "The file extension to use.";
      };
    };
  };

  tealModule = types.submodule {
    options = {
      enable = mkEnableOption "Teal";
      plugins = mkOption {
        # type = types.listOf types.package;
        default = with pkgs.vimPlugins; [ (luaPlugin { plugin = nvim-teal-maker; }) ];
        description = "Teal associated plugins";
      };
    };
  };

in
{
  options = {
    programs.neovim = {
      highlightOnYank = mkEnableOption "highlight on yank" // {
        default = true;
      };

      useAsManViewer = mkEnableOption "use as man viewer";
      lualsAddons = mkEnableOption "Install luals addons";

      enableMyDefaults = mkEnableOption "my favorite defaults";

      enableBlink = mkEnableOption "blink-cmp autocompletion";

      enableRocks = mkEnableOption "The awesome rocks-nvim plugin manager";

      # pendant de extraPackages, inline as vim.env.PATH plutot que comme des
      # wrapper flags, ce qui permet de garder les extraPackages pour tous les wrappers
      extraInitLuaPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.shfmt ]";
        description = "Extra packages available to nvim.";
      };

      lsp = mkOption {
        type = types.submodule {
          options = {
            mapOnAttach = mkEnableOption "Mappings on LspAttach";
          };
        };

        default = {
          mapOnAttach = false;
        };
        description = "Various lsp configurations";
      };

      # enableYazi = mkEnableOption "The file manager yazi";

      orgmode = mkOption {
        type = orgmodeModule;
        default = {
          enable = false;
        };
        description = "Enable orgmode support";
      };

      neorg = mkOption {
        type = neorgModule;
        default = {
          enable = false;
        };
        description = "Enable neorg support";
      };

      # autocompletion = mkOption {
      #   type = autocompletionModule;
      #   default = {
      #     enable = false;
      #   };
      #   description = "Autocompletion configuration";
      # };

      treesitter = mkOption {
        type = treesitterModule;
        default = {
          enable = true;
        };
        description = ''Treesitters settings.'';
      };

      teal = mkOption {
        type = tealModule;
        default = {
          enable = false;
        };
        description = ''Enable support for teal language.'';
      };

      fennel = mkOption {
        type = fennelModule;
        default = {
          enable = false;
        };
        description = ''Enable support for fennel language.'';
      };

      # snippet = mkOption {
      #   type = fennelModule;
      #   default = {
      #     enable = false;
      #   };
      #   description = ''Enable snippet support'';
      # };
    };
  };

  config = lib.mkMerge [
    # TODO add orgmode-babel and emacs to neovim
    (mkIf cfg.highlightOnYank {

      # -- TODO higroup should be its own ? a darker version of CursorLine
      # -- if it doesnt exist
      programs.neovim.extraLuaConfig = ''
        vim.api.nvim_create_autocmd('TextYankPost', {
            callback = function()
                vim.hl.on_yank({ higroup = 'IncSearch', timeout = 1000 })
            end,
        })
      '';
    })
    (mkIf cfg.enableMyDefaults {
      programs.neovim.extraLuaConfig = ''
        vim.opt.title = true -- vim will change terminal title
        vim.opt.titlestring = "%{getpid().':'.getcwd()}"
        vim.opt.smoothscroll = true
        vim.opt.termguicolors = true
        vim.opt.cursorline = true -- highlight cursor line

        vim.opt.mousemodel = 'popup_setpos'
      '';
    })

    (mkIf cfg.enableBlink {
      programs.neovim.plugins = blinkPlugins;
    })

    (mkIf cfg.enableRocks {
      programs.neovim.plugins = [
        pkgs.vimPlugins.rocks-nvim
        pkgs.vimPlugins.rocks-config
        pkgs.vimPlugins.rocks-git
        pkgs.vimPlugins.rocks-dev
      ];
    })
    # (mkIf cfg.orgmode.enable { programs.neovim.plugins = cfg.orgmode.plugins; })

    (mkIf cfg.neorg.enable { programs.neovim.plugins = cfg.neorg.plugins; })

    (mkIf cfg.lsp.mapOnAttach {
      # TODO enable treesitter multilanguage
      programs.neovim.extraLuaConfig = # lua
        ''
          vim.api.nvim_create_autocmd('LspAttach', {
              desc = 'Attach lsp_signature on new client',
              callback = function(args)
                  -- print("Called matt's on_attach autocmd")
                  if not (args.data and args.data.client_id) then
                      return
                  end
                  local client = vim.lsp.get_client_by_id(args.data.client_id)
                  local bufnr = args.buf

                  -- local on_attach = require('teto.on_attach')
                  vim.keymap.set('n', '[e', function()
                      vim.diagnostic.jump({
                        wrap = true,
                        severity = vim.diagnostic.severity.ERROR,
                        count = -1
                      })
                  end, { buffer = true })
                  vim.keymap.set('n', ']e', function()
                      vim.diagnostic.jump({ 
                        count = 1,
                        wrap = true,
                        severity = vim.diagnostic.severity.ERROR,
                      })
                  end, { buffer = true })

              end
              })
        '';

    })

    (mkIf cfg.useAsManViewer {
      home.sessionVariables = {
        MANPAGER = "nvim +Man!";
      };
    })

    (mkIf cfg.lualsAddons {
      # maybe those addons should be added to "pkgs" instead
      xdg.configFile."nvim/luals-addons.lua".text = ''
        {
        "${flakeSelf.inputs.luals-busted-addon}",
        "${flakeSelf.inputs.luals-luassert-addon}"
        }
      '';
    })

    (mkIf cfg.treesitter.enable {
      programs.neovim.plugins = treesitterPlugins;
      # programs.neovim.extraLuaConfig = lib.mkBefore (
      # "--toto"
      # lib.strings.concatStrings (
      #  lib.mapAttrsToList genBlockLua luaRcBlocks
      #  )
    })

    # (mkIf cfg.autocompletion.enable {
    #   programs.neovim.plugins = cfg.autocompletion.plugins; # [ ];
    # })

    # (mkIf cfg.teal.enable { programs.neovim.plugins = cfg.teal.plugins; })

    (mkIf cfg.fennel.enable { programs.neovim.plugins = cfg.fennel.plugins; })

    ({
      programs.neovim.extraLuaConfig = lib.mkOrder 0 ''vim.env.PATH = "${lib.makeBinPath config.programs.neovim.extraInitLuaPackages}:"..vim.env.PATH'';
    })
  ];

}
