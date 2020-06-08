#!/usr/bin/env nix-shell
#!nix-shell -p jq -i sh
# clone repositories
# jq
set -eu -o pipefail

cloneDir="$HOME"
# declare -A repos
JSON="scripts/projects.json"

exit_trap() {
    local lc="$BASH_COMMAND" rc=$?
    test $rc -eq 0 || echo -e "*** error $rc: $lc.\nGenerated temporary file in $TMP_FILE" >&2
}


if [ $# -lt 1 ];
then
	echo "Usage: <$0> REPOS"
	echo "choose a repo among:"
	jq keys $JSON
	exit 1
fi

project="$1"

echo "Cloning into $cloneDir project $project"

jq -r ".$project | to_entries[] | \"\(.key),\(.value)\"" scripts/projects.json > tmp.csv

cat tmp.csv

first=1
while IFS=, read -r remote url
do
	echo "branch: $remote"
	echo "url: $url"
	projectDir="$cloneDir/$project"
	if [ $first -gt 0 ]; then
		git clone -o "$remote" $url "$projectDir"
		first=0
	else
		cd "$projectDir" && git remote add "$remote" "$url"

	fi

done <tmp.csv


# repos["wireshark"] = 
# git clone 
# git remote add 
