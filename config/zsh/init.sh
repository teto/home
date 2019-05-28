# common to sh/zsh
function rfw(){
    readlink -f $(which "$1")
}

mpsched() {
    asysctl "net/mptcp/mptcp_scheduler" $@
}

mppm() {
    asysctl "net/mptcp/mptcp_path_manager" $@
}


asysctl() {

# TODO move to bash, should work everywhere
    key="$1"
    shift 1
    arg="$@"
    # echo "Sched [$sched]"
    if [ -z "$arg" ]; then
	sysctl $key
    else
	sudo sysctl -w $key=$arg
    fi
}


# we need to 
# 3. start the new one
reload_mod() {
    newMod="$1"
# 1. change to another scheduler
    mppm "fullmesh"
# 2. rmmod the current one
    rmmod "mptcp_netlink"
    insmod "$1"
}

