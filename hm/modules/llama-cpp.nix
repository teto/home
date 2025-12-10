# copy pasted from nixpkgs
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.llama-cpp;
  # utils = import ../../lib/utils.nix { inherit lib config pkgs; };

in
{

  options = {

    services.llama-cpp = {
      enable = lib.mkEnableOption "LLaMA C++ server";

      package = lib.mkPackageOption pkgs "llama-cpp" { };

      model = lib.mkOption {
        type = lib.types.path;
        example = "/models/mistral-instruct-7b/ggml-model-q4_0.gguf";
        # default = "";
        # default = "/home/teto/llama-models/mistral-7b-openorca.Q6_K.gguf";
        description = "Model path.";
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Extra flags passed to llama-cpp-server.";
        example = [
          "-c"
          "4096"
          "-ngl"
          "32"
          "--numa"
          "numactl"
        ];
        default = [ ];
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = "IP address the LLaMA C++ server listens on.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Listen port for LLaMA C++ server.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for LLaMA C++ server.";
      };
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.user.services.llama-cpp = {
      Unit = {
        Description = "LLaMA C++ server";
        After = [ "network.target" ];
        # After = [ "graphical-session.target" ];
        # PartOf = [ "graphical-session.target" ];

      };
      # Install = {
      #   WantedBy = [ "multi-user.target" ];
      # };

      Service = {
        Type = "idle";
        KillSignal = "SIGINT";
        # need to restore:
        # ${lib.utils.escapeSystemdExecArgs cfg.extraFlags}";
        # but how to import utils ? see nixos/modules/misc/extra-arguments.nix
        ExecStart = "${cfg.package}/bin/llama-server --log-disable --host ${cfg.host} --port ${builtins.toString cfg.port} -m ${cfg.model} ";
        Restart = "on-failure";
        RestartSec = 300;

        # for GPU acceleration
        # PrivateDevices = false;
        #
        # # hardening
        # CapabilityBoundingSet = "";
        # RestrictAddressFamilies = [
        #   "AF_INET"
        #   "AF_INET6"
        #   "AF_UNIX"
        # ];
        # NoNewPrivileges = true;
        # PrivateMounts = true;
        # PrivateTmp = true;
        # PrivateUsers = true;
        # ProtectClock = true;
        # ProtectControlGroups = true;
        # ProtectHome = true;
        # ProtectKernelLogs = true;
        # ProtectKernelModules = true;
        # ProtectKernelTunables = true;
        # ProtectSystem = "strict";
        # MemoryDenyWriteExecute = true;
        # LockPersonality = true;
        # RemoveIPC = true;
        # RestrictNamespaces = true;
        # RestrictRealtime = true;
        # RestrictSUIDSGID = true;
        # SystemCallArchitectures = "native";
        # SystemCallFilter = [
        #   "@system-service"
        #   "~@privileged"
        # ];
        # SystemCallErrorNumber = "EPERM";
        # ProtectProc = "invisible";
        # ProtectHostname = true;
        # ProcSubset = "pid";
      };
    };

    # reference osConfig ?
    # networking.firewall = lib.mkIf cfg.openFirewall {
    #   allowedTCPPorts = [ cfg.port ];
    # };

  };

  meta.maintainers = with lib.maintainers; [ newam ];
}
