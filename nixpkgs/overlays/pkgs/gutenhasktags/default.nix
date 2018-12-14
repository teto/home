{ haskell, fetchFromGitHub, zlib }:

haskell.lib.buildStackProject {
  name = "gutenhasktags";
  version = "0.1";

  # git@github.com:rob-b/gutenhasktags.git
  src = fetchFromGitHub {
    owner = "rob-b";
    repo = "gutenhasktags";
    rev = "2a33f47aac9bcced8379f076c48ac6d33ba004ea";
    sha256 = "1didzaf82is78s6kpi33ps3vcigbvnylp1c22plcn0sicz2a2kgi";
  };

  # might depend de hasktags a la rigueur
  buildInputs = [ zlib ];

}
