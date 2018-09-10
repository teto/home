{buildPythonApplication, fetchFromGitHub, xdotool, psutil, neovim }:

buildPythonApplication rec {
  name = "i3dispatch-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "teto";
    repo = "i3-dispatch";
    rev = "3e307643673f157e2f5f571c3e0628766bb77de8";
    sha256 ="0f4blz91pjfr3ylpkg3fb7lls5kfizfyz7sismqaflg11z698911";
  };

  propagatedBuildInputs = [ xdotool psutil neovim ];
}
