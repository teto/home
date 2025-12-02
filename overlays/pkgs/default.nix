final: prev: {

  # gufw is a GUI to iptables
  # wrap moc to load config from XDG_CONFIG via -C
  moc-wrapped = final.symlinkJoin {
    name = "moc-wrapped-${final.moc.version}";
    paths = [ final.moc ];
    buildInputs = [ final.makeWrapper ];
    # passthru.unwrapped = mpv;
    postBuild = ''
      # wrapProgram can't operate on symlinks
      rm "$out/bin/mocp"
      makeWrapper "${final.moc}/bin/mocp" "$out/bin/mocp" --add-flags "-C $XDG_CONFIG_HOME/moc/config"
      # rm "$out/bin/mocp"
    '';
  };

  # copy/pasted from
  # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/default.nix?ref_type=heads
  # prev.lib.makeOverridable (
  buildFirefoxXpiAddon = (
    {
      stdenv ? final.stdenv,
      fetchurl ? final.fetchurl,
      pname,
      version,
      addonId,
      url,
      sha256,
      meta,
      ...
    }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = {
        inherit addonId;
      };

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    }
  );

  Rdebug = final.lib.enableDebugging (prev.R);

  # no commit in 2 years
  # haskell-docs-cli = prev.haskellPackages.callCabal2nix "haskell-docs-cli" (prev.fetchzip {
  #       url = "https://github.com/lazamar/haskell-docs-cli/archive/e7f1a60db8696fc96987a3447d402c4d0d54b5e0.tar.gz";
  #       sha256 = "sha256-/9VjXFgbBz/OXjxu8/N7enNdVs1sQZmUiKhjSTIl6Fg=";
  #     }) {};
}
