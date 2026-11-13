{
  steam,
  extraEnv ? { },
  extraLibraries ? pkgs: [ ],
  extraPkgs ? pkgs: [ ],
}:
steam.override {
  inherit extraLibraries extraPkgs;
  # extraPkgs ? pkgs: [ ], # extra packages to add to targetPkgs
  # extraLibraries ? pkgs: [ ], # extra packages to add to multiPkgs
  # extraProfile ? "", # string to append to profile
  # extraPreBwrapCmds ? "", # extra commands to run before calling bubblewrap
  # extraBwrapArgs ? [ ], # extra arguments to pass to bubblewrap (real default is at usage site)
  # extraArgs ? "", # arguments to always pass to steam
  # extraEnv ? { }, # Environment variables to pass to Steam
  # privateTmp ? true, # if the steam bubblewrap should isolate /tmp

  extraEnv = extraEnv // {
    DISPLAY = ":0";
  };
}
