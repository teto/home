{ stdenv, buildPythonApplication, fetchFromGitHub, xdotool, psutil, pynvim }:

buildPythonApplication rec {
  name = "i3dispatch-${version}";
  version = "0.1";

  postUnpack=''
    HOME=$TMPDIR
  '';

  # src = fetchFromGitHub {
  #   owner = "teto";
  #   repo = "i3-dispatch";
  #   rev = "3e307643673f157e2f5f571c3e0628766bb77de8";
  #   sha256 ="0f4blz91pjfr3ylpkg3fb7lls5kfizfyz7sismqaflg11z698911";
  # };

  src = /home/teto/i3-dispatch;

  # src = fetchFromGitHub {
  #   owner = "krlanguet";
  #   repo = "i3-cycle-dispatch";
  #   rev = "3e307643673f157e2f5f571c3e0628766bb77de8";
  #   sha256 ="0f4blz90pjfr3ylpkg3fb7lls5kfizfyz7sismqaflg11z698911";
  # };

  propagatedBuildInputs = [ xdotool psutil pynvim ];

  meta = with stdenv.lib; {
    description = "tool to move around in i3";
    homepage = https://github.com/teto/i3-dispatch;
    # homepage = https://github.com/krlanguet/i3-cycle-dispatch;
    maintainers = [ maintainers.teto ];

  };
}
