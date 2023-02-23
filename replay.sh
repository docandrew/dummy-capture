#!/bin/sh
ip link add dummy0 type dummy
# ip link set mtu 3000 dummy0
ip link set dummy0 up

tcpreplay -i dummy0 --mbps .001 /pcaps/default.pcap