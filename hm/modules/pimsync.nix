# explains how to go from vdirsyncer to pimsync format
# https://git.sr.ht/~whynothugo/pimsync/tree/main/item/pimsync-migration.7.scd
{ config,
  lib,
  pkgs
, osConfig
, ...
}:

with lib;

let

  cfg = config.programs.pimsync;

  vdirsyncerCalendarAccounts = filterAttrs (_: v: v.pimsync.enable) (
    mapAttrs' (n: v: nameValuePair ("calendar_" + n) v) config.accounts.calendar.accounts
  );

  # vdirsyncerContactAccounts = filterAttrs (_: v: v.pimsync.enable)
  #   (mapAttrs' (n: v: nameValuePair ("contacts_" + n) v)
  #     config.accounts.contact.accounts);

  vdirsyncerAccounts = vdirsyncerCalendarAccounts;

  # // vdirsyncerContactAccounts;

  wrap = s: ''"${s}"'';

  listString = l: "[${concatStringsSep ", " l}]";

  boolString = b: if b then "true" else "false";

  localStorage =
    a:
    filterAttrs (_: v: v != null) (
      (getAttrs [ "type" "fileExt" "encoding" ] a.local)
      // {
        # TODO hack to remove ?
        type = "vdir/icalendar";
        path = a.local.path;
        postHook =
          if a.vdirsyncer.postHook != null then
            (pkgs.writeShellScriptBin "post-hook" a.vdirsyncer.postHook + "/bin/post-hook")
          else
            null;
      }
    );

  remoteStorage =
    a:
    filterAttrs (_: v: v != null) (
      (getAttrs [ "type" "url" "userName" "passwordCommand" ] a.remote)
      // (
        if a.vdirsyncer == null then
          { }
        else
          getAttrs [
            "urlCommand"
            "userNameCommand"
            "itemTypes"
            "verify"
            "verifyFingerprint"
            "auth"
            "authCert"
            "userAgent"
            "tokenFile"
            "clientIdCommand"
            "clientSecretCommand"
            "timeRange"
          ] a.vdirsyncer
      )
    );

  pair =
    a:
    with a.vdirsyncer;
    filterAttrs (k: v: k == "collections" || (v != null && v != [ ])) (
      getAttrs [ "collections" "conflictResolution" "metadata" "partialSync" ] a.vdirsyncer
    );

  pairs = mapAttrs (_: v: pair v) vdirsyncerAccounts;
  localStorages = mapAttrs (_: v: localStorage v) vdirsyncerAccounts;
  remoteStorages = mapAttrs (_: v: remoteStorage v) vdirsyncerAccounts;

  optionString =
    n: v:
    if (n == "type") then
      ''type "${v}"''
    else if (n == "path") then
      ''path "${v}"''
    else if (n == "fileExt") then
      ''fileext "${v}"''
    else if (n == "encoding") then
      ''encoding "${v}"''
    else if (n == "postHook") then
      ''post_hook "${v}"''
    else if (n == "url") then
      ''url "${v}"''
    else if (n == "urlCommand") then
      "url.fetch = ${listString (map wrap ([ "command" ] ++ v))}"
    else if (n == "timeRange") then
      ''
        start_date = "${v.start}"
        end_date = "${v.end}"''
    else if (n == "itemTypes") then
      "item_types = ${listString (map wrap v)}"
    else if (n == "userName") then
      ''username "${v}"''
    else if (n == "userNameCommand") then
      "username.fetch = ${listString (map wrap ([ "command" ] ++ v))}"
    else if (n == "password") then
      ''password "${v}"''
    else if (n == "passwordCommand") then
      ''
        password {
                shell ${concatStringsSep " " v} 
            }''
    else if (n == "passwordPrompt") then
      ''password.fetch = ["prompt", "${v}"]''
    else if (n == "verify") then
      ''verify "${v}"''
    else if (n == "verifyFingerprint") then
      ''verify_fingerprint = "${v}"''
    else if (n == "auth") then
      ''auth = "${v}"''
    else if (n == "authCert" && isString (v)) then
      ''auth_cert = "${v}"''
    else if (n == "authCert") then
      "auth_cert = ${listString (map wrap v)}"
    else if (n == "userAgent") then
      ''useragent = "${v}"''
    else if (n == "tokenFile") then
      ''token_file = "${v}"''
    else if (n == "clientId") then
      ''client_id = "${v}"''
    else if (n == "clientIdCommand") then
      "client_id.fetch = ${listString (map wrap ([ "command" ] ++ v))}"
    else if (n == "clientSecret") then
      ''client_secret = "${v}"''
    else if (n == "clientSecretCommand") then
      "client_secret.fetch = ${listString (map wrap ([ "command" ] ++ v))}"
    else if (n == "metadata") then
      "metadata ${listString (map wrap v)}"
    else if (n == "partialSync") then
      ''partial_sync "${v}"''
    else if (n == "collections") then
      # let
      #   contents =
      #     map (c: if (isString c) then ''"${c}"'' else listString (map wrap c))
      #     v;
      # in "collections ${
      #   if ((isNull v) || v == [ ]) then "null" else listString contents
      # }"
      "collections all"
    else if (n == "conflictResolution") then
      if v == "remote wins" then
        ''conflict_resolution = "a wins"''
      else if v == "local wins" then
        ''conflict_resolution = "b wins"''
      else
        "conflict_resolution = ${listString (map wrap ([ "command" ] ++ v))}"
    else
      throw "Unrecognized option: ${n}";

  attrsString = a: concatStringsSep "\n" (mapAttrsToList optionString a);

  pairString = n: v: ''
    pair ${n} {
    storage_a "${n}_remote"
    storage_b "${n}_local"
    ${attrsString v}
    }
  '';

  mkStorageStr = name: v: ''
    storage  ${name} {
          ${attrsString v}
        }
  '';

  configFile = pkgs.writeText "config" ''

    [general]
    status_path "${cfg.statusPath}"

    ### Local storages

    ${concatStringsSep "\n\n" (mapAttrsToList (n: v: mkStorageStr "${n}_local " v) localStorages)}

    ### Remote storages

    ${concatStringsSep "\n\n" (mapAttrsToList (n: v: mkStorageStr "${n}_remote" v) remoteStorages)}

    ### Pairs
    ${concatStringsSep "\n" (mapAttrsToList pairString pairs)}

  '';

in
{
  imports = [
    ../services/pimsync.nix
  ];

  options = {
    programs.pimsync = {
      enable = mkEnableOption "vdirsyncer";

      package = mkOption {
        type = types.package;
        default = pkgs.pimsync;
        defaultText = "pkgs.pimsync";
        description = ''
          vdirsyncer package to use.
        '';
      };

      statusPath = mkOption {
        type = types.str;
        default = "${config.xdg.dataHome}/pimsync/status";
        defaultText = "$XDG_DATA_HOME/pimsync/status";
        description = ''
          A directory where vdirsyncer will store some additional data for the next sync.

          For more information, see the
          [vdirsyncer manual](https://vdirsyncer.pimutils.org/en/stable/config.html#general-section).
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      let

        mutuallyExclusiveOptions = [
          [
            "url"
            "urlCommand"
          ]
          [
            "userName"
            "userNameCommand"
          ]
        ];

        requiredOptions =
          t:
          if (t == "caldav" || t == "carddav" || t == "http") then
            [ "url" ]
          else if (t == "filesystem" || lib.hasPrefix "vdir" t) then
            [
              "path"
              "fileExt"
            ]
          else if (t == "singlefile") then
            [ "path" ]
          else if (t == "google_calendar" || t == "google_contacts") then
            [
              "tokenFile"
              "clientId"
              "clientSecret"
            ]
          else
            throw "Unrecognized storage type: ${t}";

        allowedOptions =
          let
            remoteOptions = [
              "urlCommand"
              "userName"
              "userNameCommand"
              "password"
              "passwordCommand"
              "passwordPrompt"
              "verify"
              "verifyFingerprint"
              "auth"
              "authCert"
              "userAgent"
            ];
          in
          t:
          if (t == "caldav") then
            [
              "timeRange"
              "itemTypes"
            ]
            ++ remoteOptions
          else if (t == "carddav" || t == "http") then
            remoteOptions
          else if (t == "filesystem" || lib.hasPrefix "vdir/" t) then
            [
              "fileExt"
              "encoding"
              "postHook"
            ]
          else if (t == "singlefile") then
            [ "encoding" ]
          else if (t == "google_calendar") then
            [
              "timeRange"
              "itemTypes"
              "clientIdCommand"
              "clientSecretCommand"
            ]
          else if (t == "google_contacts") then
            [
              "clientIdCommand"
              "clientSecretCommand"
            ]
          else
            throw "Unrecognized storage type: ${t}";

        assertStorage =
          n: v:
          let
            allowed = allowedOptions v.type ++ (requiredOptions v.type);
          in
          mapAttrsToList
            (
              a: v':
              [
                {
                  assertion = (elem a allowed);
                  message = ''
                    Storage ${n} is of type ${v.type}. Option
                    ${a} is not allowed for this type.
                  '';
                }
              ]
              ++ (
                let
                  required = filter (a: !hasAttr "${a}Command" v) (requiredOptions v.type);
                in
                map (a: [
                  {
                    assertion = hasAttr a v;
                    message = ''
                      Storage ${n} is of type ${v.type}, but required
                      option ${a} is not set.
                    '';
                  }
                ]) required
              )
              ++ map (
                attrs:
                let
                  defined = attrNames (filterAttrs (n: v: v != null) (genAttrs attrs (a: v.${a} or null)));
                in
                {
                  assertion = length defined <= 1;
                  message = "Storage ${n} has mutually exclusive options: ${concatStringsSep ", " defined}";
                }
              ) mutuallyExclusiveOptions
            )
            (
              removeAttrs v [
                "type"
                "_module"
              ]
            );

        storageAssertions =
          flatten (mapAttrsToList assertStorage localStorages)
          ++ flatten (mapAttrsToList assertStorage remoteStorages);

      in
      storageAssertions;
    home.packages = [ cfg.package ];
    # xdg.configFile."vdirsyncer/config".source = configFile;
    xdg.configFile."pimsync/pimsync.conf".source = configFile;
  };
}
# { config, lib, pkgs, ... }:
# let
#    cfg = config.programs.fre;
# in {
#   options = {
#     programs.pimsync = {
#       enable = lib.mkEnableOption "pimsync";
#     };
#   };
#
#   #
#   config =  lib.mkMerge [
#
#     (lib.mkIf cfg.enable {
#       xdg.configFile = {
#         # "pimsync/pimsyncrc" = {
#         #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/zsh";
#         #   recursive = true;
#         # };
#         # ...
#       };
#
#       })
#
#
#   ];
#
# }
#
