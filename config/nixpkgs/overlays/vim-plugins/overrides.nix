
# # vim-markdown-composer
# , xdotool, grip, nodejs

  # doesnt seem to work yet
  vim-markdown-composer = let
    vim-markdown-composer-bin = rustPlatform.buildRustPackage {
      name = "vim-markdown-composer-vim";
      src = super.vim-markdown-composer.src;

      cargoSha256 = "0pjghdk6bfc32v6z6p7nyqmsk8vqzzk3xld6gk8j7m8i19wc0032";
      buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

      # FIXME: Use impure version of CoreFoundation because of missing symbols.
      #   Undefined symbols for architecture x86_64: "_CFURLResourceIsReachable"
      preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
        export NIX_LDFLAGS="-F${CoreFoundation}/Library/Frameworks -framework CoreFoundation $NIX_LDFLAGS"
      '';
    };
  in super.vim-markdown-composer.overrideAttrs(oa: {

    propagatedBuildsInputs = (oa.propagatedBuildsInputs or []) ++ [
      vim-markdown-composer-bin xdotool grip
    ];

    postInstall = ''
      mkdir -p $out/share/vim-plugins/vim-markdown-composer/target/release
      ln -s ${vim-markdown-composer-bin}/bin/markdown-composer $out/share/vim-plugins/vim-markdown-composer/target/release/markdown-composer
      '';
  });

  # https://github.com/JamshedVesuna/vim-markdown-preview#installation
  # yet another contender: https://github.com/MikeCoder/markdown-preview.vim
  vim-markdown-preview = super.vim-markdown-preview.overrideAttrs(oa: {
    propagatedBuildsInputs = (oa.propagatedBuildsInputs or []) ++ [ xdotool grip ];
  });
