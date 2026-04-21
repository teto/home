{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:

with lib;

let
  inherit (pkgs) vimPlugins;

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

  orgmodePlugins = [
    # TODO add     'mrshmllow/orgmode-babel.nvim',

    (luaPlugin {
      # matches nvim-orgmode
      plugin = orgmode;
      config = # lua
        ''
          require('orgmode').setup{
              org_capture_templates = {'~/nextcloud/org/*', '~/orgmode/**/*'},
              org_default_notes_file = '~/orgmode/refile.org',
              -- TODO add templates
              org_agenda_templates = { t = { description = 'Task', template = '* TODO %?\n  %u' } },
          }
        '';
    })
  ];

  treesitterPlugins = [
    # pkgs.vimPlugins.nvim-treesitter-pairs
    # pkgs.vimPlugins.nvim-treesitter-textobjects
    pkgs.vimPlugins.nvim-treesitter-parsers.nix
    pkgs.vimPlugins.nvim-treesitter-parsers.json

    # query is already provided by neovim
    # pkgs.vimPlugins.nvim-treesitter-parsers.query
  ];

  treesitterModule = types.submodule {
    options = {
      enable = mkEnableOption "Treesitter";

      plugins = lib.mkOption {
        # type = types.listOf types.package;
        default = treesitterPlugins;
        # [];
      };
    };
  };

  neorgModule = types.submodule {
    options = {

      enable = mkEnableOption "Neorg";

      plugins = lib.mkOption {
        # type = types.listOf types.package;
        default = [
          (luaPlugin { plugin = pkgs.vimPlugins.neorg; })
        ];
        description = "toto";
      };
    };
  };

  orgmodeModule = types.submodule {
    options = {

      enable = mkEnableOption "Orgmode";

      plugins = lib.mkOption {
        # type = types.listOf types.package;
        default = orgmodePlugins;
        description = "The file extension to use.";
      };
    };
  };

  fennelModule = types.submodule {
    options = {
      enable = mkEnableOption "Fennel";
      plugins = lib.mkOption {
        # type = types.listOf types.package;
        default = fennelPlugins;
        description = "The file extension to use.";
      };
    };
  };

  tealModule = types.submodule {
    options = {
      enable = mkEnableOption "Teal";
      plugins = lib.mkOption {
        # type = types.listOf types.package;
        default = [
          # (luaPlugin { plugin = nvim-teal-maker; })
          vimPlugins.vim-teal
        ];
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

      enableFzfLua = mkEnableOption "fzf-lua" // {
        default = true;
      };
      enableBlink = mkEnableOption "blink-cmp autocompletion";

      # enableDebugVersion = mkEnableOption "Enable debug build";

      enableRocks = mkEnableOption "The awesome rocks-nvim plugin manager";

      # pendant de extraPackages, inline as vim.env.PATH plutot que comme des
      # wrapper flags, ce qui permet de garder les extraPackages pour tous les wrappers
      extraInitLuaPackages = lib.mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.shfmt ]";
        description = "Extra packages available to nvim.";
      };

      lsp = lib.mkOption {
        type = types.submodule {
          options = {
            mapOnAttach = lib.mkEnableOption "Mappings on LspAttach";
          };
        };

        default = {
          mapOnAttach = false;
        };
        description = "Various lsp configurations";
      };

      # enableYazi = mkEnableOption "The file manager yazi";

      orgmode = lib.mkOption {
        type = orgmodeModule;
        default = {
          enable = false;
        };
        description = "Enable orgmode support";
      };

      neorg = lib.mkOption {
        type = neorgModule;
        default = {
          enable = false;
        };
        description = "Enable neorg support";
      };

      # autocompletion = lib.mkOption {
      #   type = autocompletionModule;
      #   default = {
      #     enable = false;
      #   };
      #   description = "Autocompletion configuration";
      # };
      dap = lib.mkOption {
        type = types.submodule {
          options = {
            enable = mkEnableOption "DAP (Debug Adapter Protocol)";
          };

        };
        default = {
          enable = false;
        };
        description = "Dap settings.";
      };

      treesitter = lib.mkOption {
        type = treesitterModule;
        default = {
          enable = false;
        };
        description = "Treesitters settings.";
      };

      teal = lib.mkOption {
        type = tealModule;
        default = {
          enable = false;
        };
        description = "Enable support for teal language.";
      };

      fennel = lib.mkOption {
        type = fennelModule;
        default = {
          enable = false;
        };
        description = "Enable support for fennel language.";
      };

      # snippet = lib.mkOption {
      #   type = fennelModule;
      #   default = {
      #     enable = false;
      #   };
      #   description = ''Enable snippet support'';
      # };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enableFzfLua {
      programs.neovim.plugins = [
        (luaPlugin { plugin = pkgs.vimPlugins.fzf-lua; })

      ];

      programs.neovim.initLua = ''
        require('fzf-lua').setup({})
      '';
    })

    # TODO add orgmode-babel and emacs to neovim
    (lib.mkIf cfg.highlightOnYank {

      # -- TODO higroup should be its own ? a darker version of CursorLine
      # -- if it doesnt exist
      programs.neovim.initLua = ''
        vim.api.nvim_create_autocmd('TextYankPost', {
            callback = function()
                vim.hl.on_yank({ higroup = 'IncSearch', timeout = 1000 })
            end,
        })
      '';
    })
    (lib.mkIf cfg.enableMyDefaults {
      # programs.neovim.plugins = blinkPlugins;

      programs.neovim.initLua = ''
        vim.opt.title = true -- vim will change terminal title
        vim.opt.titlestring = "%{getpid().':'.getcwd()}"
        vim.opt.smoothscroll = true
        vim.opt.termguicolors = true
        vim.opt.cursorline = true -- highlight cursor line

        vim.opt.mousemodel = 'popup_setpos'
      '';
    })

    (lib.mkIf cfg.enableBlink {
      programs.neovim.plugins = blinkPlugins;
    })

    (lib.mkIf cfg.enableRocks {
      programs.neovim.plugins = [
        pkgs.vimPlugins.rocks-nvim
        pkgs.vimPlugins.rocks-config-nvim
        pkgs.vimPlugins.rocks-dev-nvim
        pkgs.vimPlugins.rocks-git-nvim # has no vimPlugins equivalent !
      ];

      # TODO add  vim.g.rocks
      #         luaInterpreter = pkgs.lua51Packages.lua;
      # "${luaInterpreter.pkgs.luarocks_bootstrap}/bin/luarocks"

      programs.neovim.initLua =
        let
          luaInterpreter = pkgs.lua51Packages.lua;
        in
        ''
          vim.g.rocks_nvim = {
              -- use nix_deps.luarocks_executable coming from nixpkgs
              -- TODO removing this generates errors at runtime :'(
              luarocks_binary = "${luaInterpreter.pkgs.luarocks_bootstrap}/bin/luarocks"
          }
        '';
    })

    # (mkIf cfg.orgmode.enable { programs.neovim.plugins = cfg.orgmode.plugins; })

    (lib.mkIf cfg.neorg.enable {
      programs.neovim.plugins = cfg.neorg.plugins;
      # TODO add extraLuaPackages until this is fixed
      # programs.neovim.extraLuaPackages = [ ];
    })

    (lib.mkIf cfg.lsp.mapOnAttach {
      # TODO enable treesitter multilanguage
      programs.neovim.initLua = # lua
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

    (lib.mkIf cfg.useAsManViewer {
      home.sessionVariables = {
        MANPAGER = "nvim +Man!";
      };
    })

    (lib.mkIf cfg.lualsAddons {
      # maybe those addons should be added to "pkgs" instead
      xdg.configFile."nvim/luals-addons.lua".text = ''
        {
        "${flakeSelf.inputs.luals-busted-addon}",
        "${flakeSelf.inputs.luals-luassert-addon}"
        }
      '';
    })

    (lib.mkIf cfg.dap.enable {
      programs.neovim.plugins = [
        vimPlugins.nvim-dap
        vimPlugins.nvim-dap-ui
      ];

    })

    (lib.mkIf cfg.treesitter.enable {
      programs.neovim.plugins = treesitterPlugins;
      # programs.neovim.initLua = lib.mkBefore (
      # "--toto"
      # lib.strings.concatStrings (
      #  lib.mapAttrsToList genBlockLua luaRcBlocks
      #  )
    })

    # (mkIf cfg.autocompletion.enable {
    #   programs.neovim.plugins = cfg.autocompletion.plugins; # [ ];
    # })

    # (mkIf cfg.teal.enable { programs.neovim.plugins = cfg.teal.plugins; })

    (lib.mkIf cfg.fennel.enable {
      programs.neovim.plugins = with pkgs.vimPlugins; [

        # https://github.com/Olical/nfnl
        # vimPlugins.nfnl
        vimPlugins.nvim-treesitter-parsers.fennel
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
        #
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

      programs.neovim.initLua = ''
        vim.lsp.enable("fennel-ls")
      '';

      home.packages = [
        cfg.package.lua.pkgs.fennel
        pkgs.fennel-ls
      ];
    })

    {
      programs.neovim.initLua = lib.mkOrder 0 ''vim.env.PATH = "${lib.makeBinPath config.programs.neovim.extraInitLuaPackages}:"..vim.env.PATH'';
    }
  ];

}
