{ config, lib, ... }:

with lib;

let
  cfg = config.programs.carl;
  mkOption =
    name: type:
    mkOption {
      default = null;
      example = null;
      description = "";
    } name type;
  mkOptionDefault =
    name: type: default:
    mkOption {
      default = default;
      example = default;
      description = "";
    } name type;
  mkOptionDesc =
    name: type: description:
    mkOption {
      default = null;
      example = null;
      description = description;
    } name type;
  mkOptionDescDefault =
    name: type: default: description:
    mkOption {
      default = default;
      example = default;
      description = description;
    } name type;
  mkOptionList =
    name: type:
    mkOption {
      default = [ ];
      example = [ ];
      description = "";
    } name (mkOptionType type);
  mkOptionListDefault =
    name: type: default:
    mkOption {
      default = default;
      example = default;
      description = "";
    } name (mkOptionType type);
  mkOptionListDesc =
    name: type: description:
    mkOption {
      default = [ ];
      example = [ ];
      description = description;
    } name (mkOptionType type);
  mkOptionListDescDefault =
    name: type: default: description:
    mkOption {
      default = default;
      example = default;
      description = description;
    } name (mkOptionType type);
  mkOptionType =
    type:
    if type == "string" then
      types.str
    else if type == "strings" then
      types.listOf types.str
    else if type == "int" then
      types.int
    else if type == "ints" then
      types.listOf types.int
    else if type == "bool" then
      types.bool
    else if type == "bools" then
      types.listOf types.bool
    else if type == "path" then
      types.path
    else if type == "paths" then
      types.listOf types.path
    else
      null;
  mkIcalOption =
    name: mkOptionDescDefault ("ical.${name}") "string" null "The path to the ical file for ${name}";
  mkIcalOptionWithStyle =
    name:
    let
      stylenamesOption = mkOptionDescDefault (
        "ical.${name}.stylenames"
      ) "strings" [ ] "The stylenames for the ical file ${name}";
      weightOption = mkOptionDescDefault (
        "ical.${name}.weight"
      ) "int" null "The weight for the ical file ${name}";
    in
    [
      mkIcalOption
      name
      stylenamesOption
      weightOption
    ];
  icalOptions = concatLists (map mkIcalOptionWithStyle [ "default" ]);
  themeOption = mkOptionDescDefault "theme" "string" "default" "The theme to use for carl";
  templateDirOption = mkOptionDesc "templateDir" "path" "The directory containing custom templates";
  options = [
    themeOption
    templateDirOption
  ]
  ++ icalOptions;
  generateConfig =
    {
      theme,
      templateDir,
      ical,
    }:
    let
      icalConfigs = concatMap (
        name: value:
        let
          file = value.file;
          stylenames = value.stylenames;
          weight = value.weight;
        in
        if file != null then
          [
            "[[ical]]"
            "file = \"${file}\""
          ]
          ++ (if stylenames != [ ] then [ "stylenames = ${toJSON stylenames}" ] else [ ])
          ++ (if weight != null then [ "weight = ${toString weight}" ] else [ ])
        else
          [ ]
      ) (attrNames ical);
    in
    ""
    ++ (if theme != null then "theme = \"${theme}\"\n" else "")
    ++ (if templateDir != null then "template_dir = \"${templateDir}\"\n" else "")
    ++ concatStringsSep "\n" icalConfigs;
  configContent = generateConfig {
    inherit (cfg) theme templateDir;
    ical = {
      default = {
        file = cfg.ical.default;
        stylenames = cfg.ical.default.stylenames;
        weight = cfg.ical.default.weight;
      };
    };
  };
in
{
  options.programs.carl = {
    enable = mkOptionDescDefault "enable" "bool" false "Enable carl configuration";
    settings = mkOptionDesc "settings" "module" "The carl configuration settings";
  };
  config = mkIf cfg.enable {
    xdg.configFile.".config/carl/config.toml".text = configContent;
  };
}

# vim: foldmethod=manual
