{
  config,
  lib,
  pkgs,
  ...
}:
let
  tideItemJj = pkgs.fishPlugins.buildFishPlugin {
    pname = "tide-item-jj";
    version = "unstable-2026-05-27";

    src = pkgs.fetchFromGitHub {
      owner = "lucasadelino";
      repo = "tide-item-jj";
      rev = "e1150b7332b85149b468cb10c2844f082f33975b";
      hash = "sha256-vLSrHPoytZ/kXQh0Bp/4AWe8YLlyufRjepfXUAuWCB8=";
    };
  };

  fishPluginFromVendor =
    plugin:
    pkgs.runCommand "${plugin.pname or plugin.name}-hm-fish-plugin" { } ''
      fish_dir="${plugin}/share/fish"

      copy_fish_dir() {
        from="$1"
        to="$2"

        if [ -d "$fish_dir/$from" ]; then
          mkdir -p "$out/$to"
          cp -R "$fish_dir/$from"/. "$out/$to"/
        fi
      }

      copy_fish_dir vendor_conf.d conf.d
      copy_fish_dir vendor_completions.d completions
      copy_fish_dir vendor_functions.d functions
    '';
in
# TODO
# -restore fancy-ctrl-z from zsh
# -equivalent of zbell with done. Ideally notify differently for some commands
# (email ? sound ?)
# alias -s git="git clone"
# - rfw
{
  enable = true;

  _imports = [

    # https://github.com/NixOS/nixpkgs/blob/9608ace7009ce5bc3aeb940095e01553e635cbc7/nixos/modules/programs/fish.nix#L285-L291
    {
      home.packages = [
        pkgs.fishPlugins.git-abbr
        pkgs.fishPlugins.done

        # https://github.com/acomagu/fish-async-prompt
        # pkgs.fishPlugins.async-prompt # see how I can configure it
      ];
    }
  ];

  # binds = {
  #   "alt-shift-b".command = "fish_commandline_append bat";
  #   "alt-s".erase = true;
  #   "alt-s".operate = "preset";
  # };

  # interactiveShellInit
  # shellInit
  # shellInitLast
  shellAbbrs = {
    l = "less";
    gco = "git checkout";
    "-C" = {
      position = "anywhere";
      expansion = "--color";
    };
    kssh = "kitten ssh";
  };

  #
  functions = {

    # a way to implement the equivalent of `alias -s git`.
    # might be easier to create the file myself
    fish_command_not_found = ''
      set -l cmd $argv[1]

      # Check if the command ends with .git
      if string match -qr '\.git$' -- $cmd
          git clone $cmd
          return 0
      end

      # Otherwise, show the default error
      echo "fish: Unknown command '$cmd'"
      return 127
    '';
    # normal-function = "";
    # event-handler = {
    #   body = "";
    #   onEvent = "test";
    # };
    # variable-handler = {
    #   body = "echo 'hello variable-handler: PATH god modified'";
    #   onVariable = "PATH";
    # };
    # job-handler = {
    #   body = "echo 'hello jobhander'";
    #   onJobExit = "10";
    # };
    # signal-handler = {
    #   body = ''
    #     echo "SIGNAL RECEIVED";
    #   '';
    #   onSignal = "HUP";
    # };
    # # Register the handler
    # functions -c my_process_handler

    # process-handler = {
    #   body = ''
    #     # This function is called when a process changes state
    #
    #     set -l job_id $argv[1]
    #     set -l pid $argv[2]
    #     set -l job_name $argv[3]
    #     set -l job_state $argv[4]
    #           echo "PROCCESS CAQLLLED"
    #
    #     switch $job_state
    #         case running
    #             echo "Job $job_id ($job_name) is now running with PID $pid"
    #         case done
    #             echo "Job $job_id ($job_name) completed successfully"
    #         case stopped
    #             echo "Job $job_id ($job_name) has stopped"
    #         case continued
    #             echo "Job $job_id ($job_name) has continued"
    #     end
    #
    #
    #
    #   '';
    #   onProcessExit = 10;
    # };

  };

  # binds =
  # # {
  #   "alt-shift-b".command = "fish_commandline_append bat";
  #   "alt-s".erase = true;
  #   "alt-s".operate = "preset";
  # }                                                                                                                                                                                                                                                ;

  shellAliases = {
    g = "git";
    "..." = "cd ../..";
  };

  # to install plugins on nixos do
  # environment.systemPackages = with pkgs; [
  #   fishPlugins.done
  #   fishPlugins.fzf-fish  # to compare with fzf-git-sh
  #   fishPlugins.forgit
  #   fishPlugins.hydro
  #   fishPlugins.grc
  # ];

  # these are added to ~/.config/fish/conf.d
  # use { name = ... ; src = drv }
  plugins = [
    {
      name = "git-abbr";
      src = fishPluginFromVendor pkgs.fishPlugins.git-abbr;
    }

    # {
    #   name = "sponge";
    #  sponge filters history !
    # https://github.com/meaningful-ooo/sponge
    #   src = pkgs.fishPlugins.sponge.src;
    # }

    # https://github.com/franciscolourenco/done
    {
      name = "done";
      src = pkgs.fishPlugins.done.src;
    }
    {
      # an async prompt
      name = "tide";
      # fishPluginFromVendor
      src = pkgs.fishPlugins.tide.src;
    }
    {
      name = "tide-item-jj";
      src = fishPluginFromVendor tideItemJj;
    }
    # {
    #   name = "async-prompt";
    #   src = fishPluginFromVendor pkgs.fishPlugins.async-prompt;
    # }
    #   pkgs.fishPlugins.bass # bash loader
  ];

  # TODO restore some manual comple
  completions = {
    # my-prog = ''
    #   complete -c myprog -s o -l output
    # '';

    # my-app = {
    #   body = ''
    #     complete -c myapp -s -v
    #   '';
    # };
    llama-server = ''
      function __fish_llama_server_options
        set -l options -h --help --usage --version -cl --cache-list --completion-bash -t --threads -tb --threads-batch -C --cpu-mask -Cr --cpu-range --cpu-strict --prio --poll -Cb --cpu-mask-batch -Crb --cpu-range-batch --cpu-strict-batch --prio-batch --poll-batch -c --ctx-size -n --predict --n-predict -b --batch-size -ub --ubatch-size --keep --swa-full -fa --flash-attn --perf -e --escape --rope-scaling --rope-scale --rope-freq-base --rope-freq-scale --yarn-orig-ctx --yarn-ext-factor --yarn-attn-factor --yarn-beta-slow --yarn-beta-fast -kvo --kv-offload --repack --no-host -ctk --cache-type-k -ctv --cache-type-v -dt --defrag-thold --mlock --mmap -dio --direct-io --numa -dev --device --list-devices -ot --override-tensor -cmoe --cpu-moe -ncmoe --n-cpu-moe -ngl --gpu-layers --n-gpu-layers -sm --split-mode -ts --tensor-split -mg --main-gpu -fit --fit -fitt --fit-target -fitc --fit-ctx --check-tensors --override-kv --op-offload --lora --lora-scaled --control-vector --control-vector-scaled --control-vector-layer-range -m --model -mu --model-url -dr --docker-repo -hf -hfr --hf-repo -hff --hf-file -hfv -hfrv --hf-repo-v -hffv --hf-file-v -hft --hf-token --log-disable --log-file --log-colors -v --verbose --log-verbose --offline -lv --verbosity --log-verbosity --log-prefix --log-timestamps --spec-draft-type-k -ctkd --cache-type-k-draft --spec-draft-type-v -ctvd --cache-type-v-draft --samplers -s --seed --sampler-seq --sampling-seq --ignore-eos --temp --temperature --top-k --top-p --min-p --top-nsigma --top-n-sigma --xtc-probability --xtc-threshold --typical --typical-p --repeat-last-n --repeat-penalty --presence-penalty --frequency-penalty --dry-multiplier --dry-base --dry-allowed-length --dry-penalty-last-n --dry-sequence-breaker --adaptive-target --adaptive-decay --dynatemp-range --dynatemp-exp --mirostat --mirostat-lr --mirostat-ent -l --logit-bias --grammar --grammar-file -j --json-schema -jf --json-schema-file -bs --backend-sampling --spec-draft-hf -hfd -hfrd --hf-repo-draft --spec-draft-threads -td --threads-draft --spec-draft-threads-batch -tbd --threads-batch-draft --spec-draft-cpu-mask -Cd --cpu-mask-draft --spec-draft-cpu-range -Crd --cpu-range-draft --spec-draft-cpu-strict --cpu-strict-draft --spec-draft-prio --prio-draft --spec-draft-poll --poll-draft --spec-draft-cpu-mask-batch -Cbd --cpu-mask-batch-draft --spec-draft-cpu-strict-batch --cpu-strict-batch-draft --spec-draft-prio-batch --prio-batch-draft --spec-draft-poll-batch --poll-batch-draft --spec-draft-override-tensor -otd --override-tensor-draft --spec-draft-cpu-moe -cmoed --cpu-moe-draft --spec-draft-n-cpu-moe --spec-draft-ncmoe -ncmoed --n-cpu-moe-draft --spec-draft-n-max --spec-draft-n-min --spec-draft-p-split --draft-p-split --spec-draft-p-min --draft-p-min --spec-draft-backend-sampling --spec-draft-device -devd --device-draft --spec-draft-ngl -ngld --gpu-layers-draft --n-gpu-layers-draft --spec-draft-model -md --model-draft --spec-type --spec-ngram-mod-n-min --spec-ngram-mod-n-max --spec-ngram-mod-n-match --spec-ngram-simple-size-n --spec-ngram-simple-size-m --spec-ngram-simple-min-hits --spec-ngram-map-k-size-n --spec-ngram-map-k-size-m --spec-ngram-map-k-min-hits --spec-ngram-map-k4v-size-n --spec-ngram-map-k4v-size-m --spec-ngram-map-k4v-min-hits --draft --draft-n --draft-max --draft-min --draft-n-min --spec-ngram-size-n --spec-ngram-size-m --spec-ngram-min-hits -lcs --lookup-cache-static -lcd --lookup-cache-dynamic -ctxcp --ctx-checkpoints --swa-checkpoints -cms --checkpoint-min-step -cram --cache-ram -kvu --kv-unified --cache-idle-slots --context-shift -r --reverse-prompt -sp --special --warmup --spm-infill --pooling -np --parallel -cb --cont-batching -mm --mmproj -mmu --mmproj-url --mmproj-auto --mmproj-offload --image-min-tokens --image-max-tokens --mtmd-batch-max-tokens -a --alias --tags --embd-normalize --host --port --reuse-port --path --api-prefix --ui-config --webui-config --ui-config-file --webui-config-file --ui-mcp-proxy --webui-mcp-proxy --tools -ag --agent --ui --webui --embedding --embeddings --rerank --reranking --api-key --api-key-file --ssl-key-file --ssl-cert-file --chat-template-kwargs -to --timeout --sse-ping-interval --threads-http --cache-prompt --cache-reuse --metrics --props --slots --slot-save-path --media-path --models-dir --models-preset --models-max --models-autoload --jinja --reasoning-format -rea --reasoning --reasoning-budget --reasoning-budget-message --chat-template --chat-template-file --skip-chat-parsing --prefill-assistant -sps --slot-prompt-similarity --lora-init-without-apply --sleep-idle-seconds --log-prompts-dir -mv --model-vocoder --tts-use-guide-tokens --embd-gemma-default --fim-qwen-1.5b-default --fim-qwen-3b-default --fim-qwen-7b-default --fim-qwen-7b-spec --fim-qwen-14b-spec --fim-qwen-30b-default --gpt-oss-20b-default --gpt-oss-120b-default --vision-gemma-4b-default --vision-gemma-12b-default --spec-default
        printf "%s\n" $options
      end

      function __fish_llama_server_prev_token_in
        set -l tokens (commandline -opc)
        set -l prev $tokens[-1]
        contains -- $prev $argv
      end

      function __fish_llama_server_complete_suffix
        set -l suffix $argv[1]
        set -l token (commandline -ct | string replace -r -- '^-[^=]*=' "")

        for path in $token*$suffix $token*/
          if test -e $path
            printf "%s\n" $path
          end
        end
      end

      complete -c llama-server -f -a "(__fish_llama_server_options)"
      complete -c llama-server -n "__fish_llama_server_prev_token_in -m --model" -f -a "(__fish_llama_server_complete_suffix .gguf)"
      complete -c llama-server -n "__fish_llama_server_prev_token_in --grammar-file" -f -a "(__fish_llama_server_complete_suffix .gbnf)"
      complete -c llama-server -n "__fish_llama_server_prev_token_in --chat-template-file" -f -a "(__fish_llama_server_complete_suffix .jinja)"
    '';
  };

  # Source manual configuration file
  interactiveShellInit = ''
    # 'done' plugin config
    set -U __done_min_cmd_duration 5000  # default: 5000 ms

    # Source manual fish configuration if it exists
    set -l manual_config ${config.xdg.configHome}/fish/manual.fish
    if test -f $manual_config
      source $manual_config
    end

    # todo upload if not the case yet ?
    source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.fish
  '';

}
