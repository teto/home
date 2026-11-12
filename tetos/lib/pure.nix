{ lib }:
{
  /**
    Maps over folders in folder
  */
  importDirectories = folder: transformEntry:
    
    let
      # transformEntry = lib.id;
      pred = key: val: val == "directory";

      folders = lib.mapAttrs' transformEntry (lib.filterAttrs pred (builtins.readDir folder));
    in
      folders;

  importFiles =
    folder:
    let
      genKey = str: lib.replaceStrings [ ".nix" ] [ "" ] (baseNameOf (toString str));

      pred = name: val: lib.strings.hasSuffix ".nix" name;

      transformEntry =
        filename: val:
        let
          key = genKey filename;
          val' = folder + "/${filename}";
        in

        lib.nameValuePair key val';

      listOfModules = lib.mapAttrs' transformEntry (lib.filterAttrs pred (builtins.readDir folder));

    in
    listOfModules;

}
