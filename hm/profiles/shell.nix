{ config, pkgs, lib, secrets, ... } @ args:
let
  # secrets = import ../../nixpkgs/secrets.nix;

  mkRemoteBuilderDesc = machine:
    with lib;
    concatStringsSep " " ([
      "${optionalString (machine.sshUser != null) "${machine.sshUser}@"}${machine.hostName}"
      (if machine.system != null then machine.system else if machine.systems != [ ] then concatStringsSep "," machine.systems else "-")
      (if machine.sshKey != null then machine.sshKey else "-")
      (toString machine.maxJobs)
      (toString machine.speedFactor)
      (concatStringsSep "," (machine.supportedFeatures ++ machine.mandatoryFeatures))
      (concatStringsSep "," machine.mandatoryFeatures)
    ]
      # assume we r always > 2.4
      # ++ optional (isNixAtLeast "2.4pre") (if machine.publicHostKey != null then machine.publicHostKey else "-"));
      # ++ (if machine.publicHostKey != null then machine.publicHostKey else "-")
    );
in
{

  imports = [
    ./zsh.nix
  ];

  # 
  programs.atuin = {


    enable = false;
    enableZshIntegration = true;
  };

  programs.bash = {
    enable = true;

    # goes to .profile
    sessionVariables = {
      HISTTIMEFORMAT = "%d.%m.%y %T ";
      # CAREFUL 
      # RUNNER1=lib.mkRemoteBuilderDesc secrets.nova-runner-1;
      # RUNNER2=mkRemoteBuilderDesc secrets.nova-runner-2;
      # HISTFILE="$XDG_CACHE_HOME/bash_history";
	  # TODO pass the correct port, how to do that ? need ssh_config support
      NOVA_RUNNER1 = mkRemoteBuilderDesc secrets.nova-runner-1;
      NOVA_RUNNER2 = mkRemoteBuilderDesc secrets.nova-runner-2;
      NOVA_RUNNER3 = mkRemoteBuilderDesc secrets.nova-runner-3;
	  NOVA_CACHE_DEV  = secrets.novaNixCache.dev;
	  NOVA_CACHE_PROD = secrets.novaNixCache.prod;
    };
    # "ignorespace"
    historyControl = [ ];
    historyIgnore = [ "ls" "pwd" ];
    # shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" ];
    historyFile = "${config.xdg.cacheHome}/bash_history";
    # historyFile = "$XDG_CACHE_HOME/bash_history";
    shellAliases = {
      # ".."="cd ..";
      # "..."="cd ../..";

      v = "nvim";
      c = "cat";
      r = "ranger";

      sscwl = "nix run .#simwork.core-webservice.local -- --bypass-manifest-check -vv";
      n = "nix develop";
      nhs92 = "nix develop $HOME/home#nhs92";
      nhs94 = "nix develop $HOME/home#nhs94";
      ns = "nix-shell";
      lg = "lazygit";
      #mostly for testin
      # dfh="df --human-readable";
      # duh="du --human-readable";
      latest = "ls -lt |head";
      fren = "trans -from fr -to en ";
      enfr = "trans -from en -to fr ";
      jpfr = "trans -from ja -to fr ";
      frjp = "trans -from fr -to ja ";
      jpen = "trans -from ja -to en ";
      enjp = "trans -from en -to ja ";
      dmesg = "dmesg --color=always|less";

      netstat_tcp = "netstat -ltnp";
      nixpaste = "curl -F \"text=<-\" http://nixpaste.lbr.uno";

      # git variables {{{
      gl = "git log";
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit -a";
      gb = "git branch";
      gch = "git checkout";
      grv = "git remote -v";
      gpu = "git pull";
      gcl = "git clone";
      # gta="git tag -a -m";
      gbr = "git branch";
      # }}}

      # kitty
      kcat = "kitty +kitten icat";

      # modprobe to use
      # might need to use -S as well
      # modprobe_exp="modprobe -d /home/teto/mptcp/build";
    };
  };

}
