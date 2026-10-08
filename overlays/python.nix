final: prev:

let
  inherit (final) fetchFromGitHub;
in
rec {
  python3 = prev.python3.override {
    # Careful, we're using a different self and super here!
    packageOverrides = final: prev: {

      # Inspect's fork requires 1.7.4; share it across the Python environment.
      nest-asyncio2 = prev.nest-asyncio2.overridePythonAttrs (old: rec {
        version = "1.7.4";
        src = fetchFromGitHub {
          owner = "Chaoses-Ib";
          repo = "nest-asyncio2";
          tag = "v${version}";
          hash = "sha256-qNetaOdR4icUXWncat4vITwnjmx5MhAgUz0t61Bvztc=";
        };
        meta = old.meta // {
          changelog = "https://github.com/Chaoses-Ib/nest-asyncio2/releases/tag/v${version}";
        };
      });

      deepeval = final.callPackage ../by-name/de/deepeval/package.nix {
        python3Packages = final;
      };

      inspect-ai = final.callPackage ../by-name/in/inspect-ai/package.nix {
        python3Packages = final;
      };

      # kergen = final.callPackage ./pkgs/kergen.nix { };

      # mininet-with-man = final.mininet.override ({ withManpage = true; });

      # needed for llm-tests / huggingface trl
      trackio = final.callPackage ./pkgs/trackio/default.nix { };

      # https://github.com/gradio-app/trackio
    };
  };

  python3Packages = python3.pkgs;

}
