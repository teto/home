with import <nixpkgs> { };

let
  rubyEnv = ruby.withPackages (p: with p; [ nokogiri ]);
in
mkShell {

  name = "neovim-website";
  # bundlerEnv / bundlerApp
  # TODO try with bundix ?
  buildInputs = [ bundler rubyEnv libxml2 ];

  shellHook = ''
    echo "bundle install --path .bundle"
    echo "bundle exec jekyll build --verbose"
  '';
}
