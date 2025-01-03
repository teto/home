{ pkgs, ... }:
let
  inherit (pkgs.tetoLib) luaPlugin;

in
{
  telescopePlugins = with pkgs.vimPlugins; [
    # { plugin = telescope-nvim; }
    # pkgs.vimPlugins.telescope-fzf-native-nvim # for use with smart-open + fzf algo
    # telescope-fzf-native-nvim # needed by smart-open.nvim
  ];

  basePlugins = with pkgs.vimPlugins; [
    (luaPlugin { plugin = rocks-nvim; })

    (luaPlugin { plugin = fzf-lua; })

    {
      # use ctrl a/xto cycle between different words
      plugin = vim-CtrlXA;
    }

    pkgs.vimPlugins.blink-cmp # replace cmp-nvim
    pkgs.vimPlugins.vim-nixhash # :NixHash
    pkgs.vimPlugins.targets-vim # to get 'ci/'
    pkgs.vimPlugins.direnv-vim # to get 'ci/'

    # { plugin = jbyuki/venn.nvim; }

    (luaPlugin {
      plugin = fzf-vim;
      # " mostly fzf mappings, use TAB to mark several files at the same time
      # " https://github.com/neovim/neovim/issues/4487
      config = ''
        vim.g.fzf_command_prefix = 'Fzf' -- prefix commands :Files become :FzfFiles, etc.
        vim.g.fzf_nvim_statusline = 0 -- disable statusline overwriting'';
    })

    # defined in overrides: TODO this should be easier: like fzf-vim should be enough
    fzfWrapper

    #  nvim-colorizer
    # (luaPlugin { plugin = nvim-terminal-lua; config = "require('terminal').setup()"; })

    # TODO hacking on this
    {
      # display git diff while rebasing, pretty dope
      plugin = auto-git-diff;
      # config = ''
      # let g:auto_git_diff_disable_auto_update=1
      # '';
    }

    # TODO move to rocks
    # {
    #   plugin = vim-dasht;
    # config = ''
    # " When in Python, also search NumPy, SciPy, and Pandas:
    # let g:dasht_filetype_docsets = {} " filetype => list of docset name regexp
    # let g:dasht_filetype_docsets['python'] = ['(num|sci)py', 'pandas']
    # " search related docsets
    # nnoremap <Leader>k :Dasht<Space>
    # " search ALL the docsets
    # nnoremap <Leader><Leader>k :Dasht!<Space>
    # " search related docsets
    # nnoremap ,k <Cmd>call Dasht([expand('<cword>'), expand('<cWORD>')])<Return>
    # " search ALL the docsets
    # nnoremap <silent> <Leader><Leader>K :call Dasht([expand('<cword>'), expand('<cWORD>')], '!')<Return>
    # '';
    #   # optional = true;
    # }

    # {
    #   plugin = sql-nvim;
    #   # config = "let g:sql_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
    # }

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

    {
      plugin = vim-grepper;
      # careful these mappings are not applied as they arrive before the plug declaration
    }

    vim-nix

    # ctrl-e causes an issue with telescope prompt
    vim-rsi

    # ' " syntax file for neomutt
    # neomutt-vim
    (luaPlugin {
      plugin = vim-sayonara;
      config = ''vim.g.sayonara_confirm_quit = 0'';
    })

    (luaPlugin {
      plugin = unicode-vim;
      config = ''
        ${unicode-vim.passthru.initLua}

        -- overrides ga
        vim.keymap.set ( "n", "ga",  "<Plug>(UnicodeGA)", { remap = true, } )
      '';
    })
  ];

  filetypePlugins = with pkgs.vimPlugins; [
    { plugin = wmgraphviz-vim; }
    { plugin = vim-toml; }
  ];

  colorschemePlugins = with pkgs.vimPlugins; [
    { plugin = sonokai; }
    { plugin = tokyonight-nvim; }
    { plugin = molokai; }
    { plugin = onedark-nvim; }
    { plugin = dracula-vim; }
    # monkai-pro
    { plugin = vim-monokai; }
    { plugin = vim-janah; }
    { plugin = tokyonight-nvim; }
    (luaPlugin {
      # required by some colorscheme
      plugin = colorbuddy-nvim;
    })
  ];

  luaPlugins = with pkgs.vimPlugins; [

    # { plugin = modicator-nvim; }

    # not upstreamed yet
    # (luaPlugin { plugin = nvim-lua-gf; })

    (luaPlugin { plugin = numb-nvim; })

    (luaPlugin { plugin = luasnip; })

    # required by trouble
    (luaPlugin { plugin = nvim-web-devicons; })

    (luaPlugin {
      plugin = marks-nvim;
      config = # lua
        ''
          require'marks'.setup {
              -- whether to map keybinds or not. default true
              default_mappings = true,
              -- whether movements cycle back to the beginning/end of buffer. default true
              cyclic = true,
              -- whether the shada file is updated after modifying uppercase marks. default false
              force_write_shada = false,
              -- how often (in ms) to redraw signs/recompute mark positions.
              -- higher values will have better performance but may cause visual lag,
              -- while lower values may cause performance penalties. default 150.
              refresh_interval = 1000,
              -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
              -- marks, and bookmarks.
              -- can be either a table with all/none of the keys, or a single number, in which case
              -- the priority applies to all marks.
              -- default 10.
              sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
              -- marks.nvim allows you to up to 10 bookmark groups, each with its own
              -- sign/virttext. Bookmarks can be used to group together positions and quickly move
              -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
              -- default virt_text is "".
              bookmark_0 = {
                sign = "⚑",
                virt_text = "hello world"
              },
              mappings = {}
          }
        '';
    })

    vim-lion # Use with gl/L<text object><character to align to

    # (luaPlugin {
    #   # prettier quickfix
    #   plugin = nvim-bqf;
    #   config = ''
    #     require'bqf'.setup({
    #      preview = {
    #       delay_syntax = 0
    #      }
    #     })
    #   '';
    # })

    (luaPlugin { plugin = fugitive-gitlab-vim; })
  ];

}
