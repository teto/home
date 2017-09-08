#!/usr/bin/env sh
GW=10.206.116.1
ETH=enp1s0f0
sudo route del default dev $ETH
sudo route add -net 10.166.14.0/24 gw $GW dev $ETH
sudo route add -net 10.131.0.0/16 gw $GW dev $ETH
sudo route add -net 10.166.123.0/24 gw $GW dev $ETH
sudo route add -net 202.32.0.0/16 gw $GW dev $ETH
sudo route add -net 210.148.118.0/24 gw $GW dev $ETH
sudo route add -net 10.206.244.0/24 gw $GW dev $ETH
