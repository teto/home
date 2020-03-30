# This file has been generated by ./pkgs/misc/vim-plugins/update.py. Do not edit!
{ lib, buildVimPluginFrom2Nix, fetchFromGitHub }:

self: super:
{
  firenvim = buildVimPluginFrom2Nix {
    pname = "firenvim";
    version = "2020-03-28";
    src = fetchFromGitHub {
      owner = "glacambre";
      repo = "firenvim";
      rev = "69f05e45c08069817ede6ea61a803b8370fe31dd";
      sha256 = "0dma24lcfgynji8pqhgyphw56igbcxbgllap2q1i4bc98kfb9yym";
    };
  };

  markdown-preview-nvim = buildVimPluginFrom2Nix {
    pname = "markdown-preview-nvim";
    version = "2020-03-26";
    src = fetchFromGitHub {
      owner = "iamcco";
      repo = "markdown-preview.nvim";
      rev = "218d19d88f6f7ec47d6494da6235db896f500f97";
      sha256 = "1n1dchn49vhr5zsz51dd0glaal1xx9japn0sy3dsswxwg642bhzk";
    };
  };

  nvim-terminal-lua = buildVimPluginFrom2Nix {
    pname = "nvim-terminal-lua";
    version = "2019-10-17";
    src = fetchFromGitHub {
      owner = "norcalli";
      repo = "nvim-terminal.lua";
      rev = "095f98aaa7265628a72cd2706350c091544b5602";
      sha256 = "09hass19v3wrqgxjcr3b59w462lp2nw533zwb1nnmiz99gx1znpx";
    };
  };

  vim-markdown-composer = buildVimPluginFrom2Nix {
    pname = "vim-markdown-composer";
    version = "2020-02-07";
    src = fetchFromGitHub {
      owner = "euclio";
      repo = "vim-markdown-composer";
      rev = "761cbefa59633657cabadafe94011e6fcd650bb3";
      sha256 = "0wqy22awql25rkfl22wypqwcxcjj7ia1i7j2f0ssvjmaja3cyfa1";
      fetchSubmodules = true;
    };
  };

  vim-markdown-preview = buildVimPluginFrom2Nix {
    pname = "vim-markdown-preview";
    version = "2018-03-21";
    src = fetchFromGitHub {
      owner = "JamshedVesuna";
      repo = "vim-markdown-preview";
      rev = "9b3ec41fb6f0f49d9bb7ca81fa1c62a8a54b1214";
      sha256 = "04m452rfns9wxd2zmqqzjicysir6rn43yi736s05ss69wylhw2g3";
    };
  };

}
