{ writeShellScript, msmtp, lib }: 
    writeShellScript "notify-advancement" ''

    fromEmail="$1"
    destEmail="$2"

    branch_name="$3"
    old_revision="$4"
    new_revision="$5"
    timestamp="$6"

    title="$branch_name advanced (from $HOSTNAME)";

    # strip leading spaces else msmtp will complain
    message=$(cat <<EOF
    From: "$fromEmail"
    To: "$destEmail"
    Subject: $title


    New revision: $new_revision
    Previous revision: $old_revision
    EOF
    )

    echo "$message" | ${lib.getExe msmtp} --read-envelope-from --read-recipients -afastmail 
  ''

