{ lib
, build-idris-package
, fetchFromGitHub
, contrib
, lightyear
}:
build-idris-package  {
  name = "REPLica";
  version = "2018-01-25";

  # This is the .ipkg file that should be built, defaults to the package name
  # In this case it should build `Yaml.ipkg` instead of `yaml.ipkg`
  # This is only necessary because the yaml packages ipkg file is
  # different from its package name here.
  ipkgName = "replica";
  # Idris dependencies to provide for the build
  # idrisDeps = [ contrib lightyear ];


  src = fetchFromGitHub {
    owner = "berewt";
    repo = "REPLica";
    rev = "b8e9295a98e6181c24affd12415b658cb3c384f1";
    sha256 = "sha256-2oTPZedg2pBOJ4T1KP1uoRymkwvSGLrTdDQ6SUcj5zM=";
  };

  meta = with lib; {
    description = "Golden tests for command-line interfaces.";
    homepage = "https://github.com/berewt/REPLica";
    license = licenses.mit;
    maintainers = [ maintainers.brainrape ];
  };
}

