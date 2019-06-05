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

	if [ -z "${newMod}" ]; then
		echo "Use: <path to new module>"
		echo "possibly /home/teto/mptcp2/build/net/mptcp/mptcp_netlink.ko"
	fi
# 1. change to another scheduler
    mppm "fullmesh"
	sleep 1
# 2. rmmod the current one
    sudo rmmod "mptcp_netlink"

# 3. Insert our new module
	sleep 1
    sudo insmod "$1"

# 4. restore path manager
	mppm "netlink"

}

