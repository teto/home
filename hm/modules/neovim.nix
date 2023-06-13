{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.neovim;

  luaPlugin = attrs: attrs // {
    type = "lua";
    # config = lib.optionalString
    #   (attrs ? config && attrs.config != null) 
    #   (genBlockLua attrs.plugin.pname attrs.config)
    #   ;
  };

  # completionPlugins = with pkgs.vimPlugins; [
  #   # (luaPlugin { plugin = coq_nvim; })
  #   (luaPlugin { plugin = cmp-rg; })
  #   # (luaPlugin { plugin = cmp-zsh; })
  #   # vim-vsnip
  #   # vim-vsnip-integ
  # ];
  defaultCompletionPlugins = with pkgs.vimPlugins; [
    (luaPlugin { plugin = nvim-cmp; })
    (luaPlugin { plugin = cmp-nvim-lsp; })
    (luaPlugin { plugin = cmp-nvim-lua; })
    # (luaPlugin { plugin = cmp-cmdline-history; })
    # (luaPlugin { plugin = cmp-conventionalcommits; })
    # (luaPlugin { plugin = cmp-digraphs; })
  #   (luaPlugin { plugin = cmp-vsnip; })
    ({ plugin = vim-vsnip; })
  ];

  orgmodePlugins = with pkgs.vimPlugins; [
    (luaPlugin {
      # matches nvim-orgmode
      plugin = orgmode;
       config = ''
        require('orgmode').setup{
            org_capture_templates = {'~/nextcloud/org/*', '~/orgmode/**/*'},
            org_default_notes_file = '~/orgmode/refile.org',
            -- TODO add templates
            org_agenda_templates = { t = { description = 'Task', template = '* TODO %?\n  %u' } },
        }
        '';
    })
  ];

  fennelPlugins = with pkgs.vimPlugins; [
    # {  plugin = aniseed;
    # runtime = {
    #      "ftplugin/c.vim".text = "setlocal omnifunc=v:lua.vim.lsp.omnifunc";
    # # "toto".text = ''
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

  autocompletionModule =
    types.submodule {
      options = {
        enable = mkEnableOption "autocompletion";

        plugins = mkOption {
          # type = types.listOf types.package;
          default = defaultCompletionPlugins;
          # descriptcompletionPlugins = with pkgs.vimPlugins; [
          # # (luaPlugin { plugin = coq_nvim; })
          # (luaPlugin { plugin = nvim-cmp; })
          # (luaPlugin { plugin = cmp-nvim-lsp; })
          # # (luaPlugin { plugin = cmp-cmdline-history; })
          # # (luaPlugin { plugin = cmp-conventionalcommits; })
          # # (luaPlugin { plugin = cmp-digraphs; })
          # (luaPlugin { plugin = cmp-rg; })
          # (luaPlugin { plugin = cmp-vsnip; })
          # ({ plugin = vim-vsnip; })
          # # (luaPlugin { plugin = cmp-zsh; })
          # # vim-vsnip
          # # vim-vsnip-integ
          # ]ion = "The plugins to use.";
        };
      };
    };

  orgmodeModule =
    types.submodule {
      options = {

        enable = mkEnableOption "Orgmode";

        plugins = mkOption {
          # type = types.listOf types.package;
          default = orgmodePlugins;
          description = "The file extension to use.";
        };
      };
    };

  fennelModule =
    types.submodule {
      options = {
        enable = mkEnableOption "Fennel";
        plugins = mkOption {
          # type = types.listOf types.package;
          default = fennelPlugins;
          description = "The file extension to use.";
        };
      };
    };

  tealModule =
    types.submodule {
      options = {
        enable = mkEnableOption "Teal";
        plugins = mkOption {
          # type = types.listOf types.package;
          default = with pkgs.vimPlugins; [
            (luaPlugin {
              plugin = nvim-teal-maker;
            })
          ];
          description = "Teal associated plugins";
        };
      };
    };



in
{
  options = {
    programs.neovim = {
      orgmode = mkOption {
        type = orgmodeModule;
        default = {
          enable = false;
        };
        description = ''
          		Enable orgmode support.
          	  '';
      };

      autocompletion = mkOption {
        type = autocompletionModule;
        description = "Autocompletion configuration";
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

      snippet = mkOption {
        type = fennelModule;
        default = {
          enable = false;
        };
        description = ''Enable support for fennel language.'';
      };
    };
  };


  config = lib.mkMerge [

    (mkIf cfg.orgmode.enable {
      programs.neovim.plugins = cfg.orgmode.plugins;
    })

    (mkIf cfg.autocompletion.enable {
      programs.neovim.plugins = cfg.autocompletion.plugins; # [ ];
    })

    (mkIf cfg.teal.enable {
      programs.neovim.plugins = cfg.teal.plugins;
    })

    (mkIf cfg.fennel.enable {
      programs.neovim.plugins = cfg.fennel.plugins;
    })

  ];

}
