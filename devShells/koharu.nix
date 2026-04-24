{ pkgs, ... }:
pkgs.mkShell {
  name = "koharu";
  buildInputs = with pkgs; [
    tauri
    bun
  ];

  shellHook = ''
    echo "bun run dev"
  '';
}
