#!/usr/bin/env sh
# or for the VPN
# nmcli c modify IIJ-L2TP ipv4.routes "10.166.0.0/16,10.167.0.0/16,10.206.0.0/16,210.148.167.0/24, 192.168.167.0/24, 192.168.0.0/16, 202.232.30.166/32, 202.232.30.167/32, 202.232.30.168/32, 202.232.30.169/32, 202.214.218.20/32, 202.214.218.30/32, 202.32.102.0/24, 210.148.118.0/24, 10.200.0.0/16, 10.110.0.0/16, 10.131.0.0/16"
GW=10.206.116.1
ETH=enp0s20f0u2u3
# ETH=enp3s0
route del default dev $ETH
route add -net 10.166.14.0/24 gw $GW dev $ETH
route add -net 10.131.0.0/16 gw $GW dev $ETH
route add -net 10.166.123.0/24 gw $GW dev $ETH
route add -net 202.32.0.0/16 gw $GW dev $ETH
route add -net 210.148.118.0/24 gw $GW dev $ETH
route add -net 10.206.244.0/24 gw $GW dev $ETH
