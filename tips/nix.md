
mount -o remount,rw /nix/store
chown -R root:root /nix/store


Limit bandwidth
 CURLOPT_MAX_RECV_SPEED_LARGE

Remote builds:

https://nixos.wiki/wiki/Distributed_build

https://discourse.nixos.org/t/remote-builders-operation-addtostore-is-not-supported-by-store/2115/2
env NIX_REMOTE='ssh-ng://my.machine?compress=true' nix-build
