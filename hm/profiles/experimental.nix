{ pkgs, lib, config, ... }:
{
  # programs.meli = {
  #   enable = true;
  # };

  programs.aerc = {
    enable = true;
    # .enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };

  programs.xdg.enable = true;

  programs.gnome-shell.enable = true;
  programs.swappy.enable = true;


  # test for 
  # - https://www.reddit.com/r/neovim/comments/17dn1be/implementing_mru_sorting_with_minipick_and_fzflua/
  # - https://lib.rs/crates/fre
  programs.zsh = {
   sessionVariables = {
     FZF_CTRL_T_COMMAND="command fre --sorted";
     FZF_CTRL_T_OPTS="--tiebreak=index";
   };

   initExtra = ''
     fre_chpwd() {
       fre --add "$(pwd)"
     }
     typeset -gaU chpwd_functions
     chpwd_functions+=fre_chpwd
     '';
 };

  # for programs not merged yet
  home.packages = with pkgs; [
   # ironbar 
	# haxe # to test https://neovim.discourse.group/t/presenting-haxe-neovim-a-new-toolchain-to-build-neovim-plugins/3720
    # meli  # broken jmap mailreader

    fre
  ];


  # programs.htop = {
  #   enabled = true;
  #   settings = {
  #     color_scheme = 5;
  #     delay = 15;
  #     highlight_base_name = 1;
  #     highlight_megabytes = 1;
  #     highlight_threads = 1;
  #   };
  # };
}
