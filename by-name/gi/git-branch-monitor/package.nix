# we prefer to run the script directly from the host
# but on VPS, I need a way to push it
{
  writeScript,
  fish,
  lib,
}:
writeScript "git-branch-monitor" ''

  ${lib.getExe fish} ${../../../bin/monitor-git-branch.fish} $@
''
