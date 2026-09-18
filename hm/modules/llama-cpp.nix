# copy pasted from nixpkgs
{
  config,
  lib,
  pkgs,
  pkgsPath,
  dotfilesPath,
  ...
}:

let
  cfg = config.services.llama-cpp;
  enabledInstances = lib.filterAttrs (_: instance: instance.enable) cfg.instances;
  instanceArgs =
    instance:
    [
      "${instance.package}/bin/llama-server"
      "--host"
      instance.host
      "--port"
      (toString instance.port)
    ]
    ++ instance.extraFlags;

  # TODO upstream to HM ?
  utils = import "${pkgsPath}/nixos/lib/utils.nix" {
    inherit config lib;
    pkgs = null;
  };
in
{

  options = {

    services.llama-cpp.instances = lib.mkOption {
      default = { };
      description = "Named LLaMA C++ server instances. Use distinct ports for instances on the same host.";
      example = lib.literalExpression ''
        {
          chat = {
            enable = true;
            port = 9931;
            extraFlags = [ "--model" "/models/chat.gguf" ];
          };
          embeddings = {
            enable = true;
            port = 9932;
            extraFlags = [ "--model" "/models/embedding.gguf" "--embedding" ];
          };
        }
      '';
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "LLaMA C++ server";

            createFishAbbr = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Create a Fish abbreviation named llamacpp-<instance name> that
                runs this instance's llama-server command with its configured
                flags and CUDA environment. This is independent of enable.
              '';
            };

            package = lib.mkPackageOption pkgs "llama-cpp" { };

            # model = lib.mkOption {
            #   type = lib.types.path;
            #   example = "/models/mistral-instruct-7b/ggml-model-q4_0.gguf";
            #   # default = "";
            #   # default = "/home/teto/llama-models/mistral-7b-openorca.Q6_K.gguf";
            #   description = "Model path.";
            # };
            #
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
              default = 9931;
              description = "Listen port for LLaMA C++ server.";
            };

            openFirewall = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Open ports in the firewall for LLaMA C++ server.";
            };
          };
        }
      );
    };

  };

  config = {

    programs.fish.shellAbbrs = lib.mapAttrs' (
      name: instance:
      lib.nameValuePair "llamacpp-${name}" (
        lib.escapeShellArgs (
          [
            "env"
            "GGML_CUDA_ENABLE_UNIFIED_MEMORY=1"
          ]
          ++ instanceArgs instance
        )
      )
    ) (lib.filterAttrs (_: instance: instance.createFishAbbr) cfg.instances);

    systemd.user.services = lib.mapAttrs' (
      name: instance:
      lib.nameValuePair "llama-cpp-${name}" {
        Unit = {
          Description = "LLaMA C++ server/inference engine (${name})";
          After = [ "network.target" ];
          # After = [ "graphical-session.target" ];
          # PartOf = [ "graphical-session.target" ];
          X-Restart-Triggers = [
            "${dotfilesPath}/contrib/llama-presets.ini"
          ];

        };
        Install = {
          WantedBy = [ "default.target" ];
        };

        Service = {
          # what does it mean ?
          # Type = "idle";
          KillSignal = "SIGINT";
          # need to restore:
          #
          # but how to import utils ? see nixos/modules/misc/extra-arguments.nix
          # --log-disable
          Environment = [
            "GGML_CUDA_ENABLE_UNIFIED_MEMORY=1"
          ];
          ExecStart = utils.escapeSystemdExecArgs (instanceArgs instance);
          # Restart = "on-failure";
          Restart = "always";

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
      }
    ) enabledInstances;

  };

  meta.maintainers = with lib.maintainers; [ teto ];
}
