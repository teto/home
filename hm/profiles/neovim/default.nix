# just a very basic neovim profile to avoid putting a too big closure
{
  pkgs,
  lib,
  flakeSelf,
  ...
}:

let

  inherit (lib)
    genBlockLua
    luaPlugin
    ;

  luaRcBlocks = {
    appearance = ''
      -- draw a line on 80th column
      vim.o.colorcolumn='80,100' 
      '';

    # hi MsgSeparator ctermbg=black ctermfg=white
    # TODO equivalent of       set fillchars+=
    foldBlock = ''
      vim.o.fillchars='foldopen:▾,foldclose:▸,msgsep:‾'
      vim.o.foldcolumn='auto:2'
      '';
  };

  # pluginsMap = pkgs.callPackage ./plugins.nix { inherit flakeSelf lib; };

  myNeovimUnwrapped =
    flakeSelf.inputs.neovim-nightly-overlay.packages."${pkgs.stdenv.hostPlatform.system}".neovim;
  # nvimLua = config.programs.neovim.finalPackage.passthru.unwrapped.lua;

  basePlugins = with pkgs.vimPlugins; [

    # installed via vim.pack for now ?
    # (luaPlugin {
    #   plugin = flakeSelf.inputs.rocks-nvim.packages.${pkgs.stdenv.hostPlatform.system}.rocks-nvim;
    # })

    # (luaPlugin { plugin = rocks-nvim; })
    # (luaPlugin { plugin = rocks-git-nvim; })

    highlight-undo-nvim
    lualine-nvim

    (luaPlugin { plugin = fzf-lua; })
    (luaPlugin {
      plugin = oil-nvim;
      config = ''
        require("oil").setup({
          -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
          -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
          default_file_explorer = true,
        })
      '';
    })

    {
      # use ctrl a/xto cycle between different words
      plugin = vim-CtrlXA;
    }

    # TODO add tests
    #       (luaPlugin { plugin = grug-far-nvim;
    # # hpefuly not needed in the next iteration
    # #        config = ''
    # #          require('grug-far').setup({ })
    # #        '';
    #       })

    { plugin = bigfile-nvim; }

    pkgs.vimPlugins.direnv-vim # to get syntax coloring ?

    # { plugin = jbyuki/venn.nvim; }

    # (luaPlugin {
    #   plugin = fzf-vim;
    #   # " mostly fzf mappings, use TAB to mark several files at the same time
    #   # " https://github.com/neovim/neovim/issues/4487
    #   config = ''
    #     vim.g.fzf_command_prefix = 'Fzf' -- prefix commands :Files become :FzfFiles, etc.
    #     vim.g.fzf_nvim_statusline = 0 -- disable statusline overwriting'';
    # })

    #  nvim-colorizer
    # (luaPlugin { plugin = nvim-terminal-lua; config = "require('terminal').setup()"; })

    # I am replacing vim-fugitive  with diffview-nvim because it's lua and easier to change probably to support jujutsu
    { plugin = vim-fugitive; }

    vim-scriptease # create commans like :Messages

    # test with hop ?
    (luaPlugin {
      plugin = vim-sneak;
      config = ''
        -- can press 's' again to go to next result, like ';'
        vim.keymap.set('n', 'f', '<Plug>Sneak_f')
        vim.keymap.set('n', 'F', '<Plug>Sneak_F')
        vim.keymap.set('n', 't', '<Plug>Sneak_t')
        vim.keymap.set('n', 'T', '<Plug>Sneak_T')

        vim.cmd [[
        let g:sneak#s_next = 1 
        let g:sneak#prompt = 'Sneak>'

        let g:sneak#streak = 0
        ]]
      '';
    })

    (luaPlugin {
      plugin = vim-grepper;
      # careful these mappings are not applied as they arrive before the plug declaration
      config = ''
        vim.keymap.set('n', '<leader>rg', '<Cmd>Grepper -tool rg -open -switch<CR>')
      '';
    })

    vim-nix # for NixEdit
    vim-rsi # the goat

    visual-whitespace-nvim # shows spaces/tabs upon visual selection. Lovely
    # ' " syntax file for neomutt
    (luaPlugin {
      plugin = vim-sayonara;
      config = ''
        vim.g.sayonara_confirm_quit = 0
        vim.keymap.set('n', '<leader>q', '<Cmd>Sayonara!<cr>', { silent = true, desc = 'Closes current window' })
        vim.keymap.set(
            'n',
            '<leader>Q',
            '<Cmd>Sayonara<cr>',
            { silent = true, desc = 'Close current window, no question asked' }
        )

      '';
    })
  ];

  rawPlugins =
    # add grepper
    basePlugins
  # ++ pluginsMap.luaPlugins
  # ++ pluginsMap.filetypePlugins
  ;

in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    enableMyDefaults = true;
    highlightOnYank = true;

    # custom options
    # autocompletion.enable = true;
    # TODO ?
    # snippets.enable = true;

    # take the one from the flake
    package = myNeovimUnwrapped;

    extraLuaConfig = lib.mkBefore (
      ''
        vim.g.mapleader = ' '
        vim.opt.hidden = true -- you can open a new buffer even if current is unsaved (error E37) =
      ''
      + (lib.strings.concatStrings (lib.mapAttrsToList genBlockLua luaRcBlocks))
      + ''
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.keymap.set('n', '<Leader><Leader>', '<Cmd>b#<CR>', { desc = 'Focus alternate buffer' })
      ''
    );

    extraConfig = ''
      set shiftwidth=4
      set expandtab
      set autoindent
      set clipboard=unnamed
      filetype plugin indent on

      autocmd FileType tex setlocal shiftwidth=2 textwidth=79
      autocmd FileType nix setlocal shiftwidth=2
    '';

    extraPackages = [ ];

    plugins = map (x: builtins.removeAttrs x [ "after" ]) rawPlugins;
  };

}
