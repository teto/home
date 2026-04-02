#!/bin/sh
# generate postgresql connection from a passwordstore folder to avoid exposing secrets in git

#!/bin/bash
printHelp() {
  echo "Use: $0 <PASSWORDSTORE_DB_FOLDER>"
  exit 1
}

if [ $# -lt 1 ]; then
  printHelp
fi

dbpath="$1"
username=$(pass-pro show "$dbpath"/username)
password=$(pass-pro show "$dbpath"/password)
host=$(pass-pro show "$dbpath"/host)

echo "$username:$password@$host/core"
