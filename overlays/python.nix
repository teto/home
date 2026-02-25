final: prev:

rec {
  python3 = prev.python3.override {
    # Careful, we're using a different self and super here!
    packageOverrides = final: prev: {

      # kergen = final.callPackage ./pkgs/kergen.nix { };

      # mininet-with-man = final.mininet.override ({ withManpage = true; });

      # needed for llm-tests / huggingface trl
      trackio = final.callPackage ./pkgs/trackio/default.nix { };

      # https://github.com/gradio-app/trackio
    };
  };

  python3Packages = python3.pkgs;

}
