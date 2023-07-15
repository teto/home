{ config, lib, pkgs, ... }:
{

  # TODO add options in fact
  programs.neovim = {

    enable = false;

    # source /home/teto/.config/nvim/init.vim
    configure = pkgs.neovimConfigure // {
      customRC = (pkgs.neovimConfigure.customRC  or "") + ''
        let g:fzf_command_prefix = 'Fzf' " prefix commands :Files become :FzfFiles, etc.
        let g:fzf_nvim_statusline = 0 " disable statusline overwriting
      '';

    };

    # runtime."ftplugin/bzl.vim".text = ''
    #   setlocal expandtab
    # '';

    # runtime."ftplugin/c.vim".text = ''
    #   " otherwise vim defaults to ccomplete#Complete
    #   setlocal omnifunc=v:lua.vim.lsp.omnifunc
    # '';


  };

}
