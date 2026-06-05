#!/bin/bash
# Honeypot lab iptables rules
# Run on Kali after interfaces eth1 and eth2 are up
# eth1 = DMZ (192.168.20.0/24)
# eth2 = Internal (192.168.30.0/24)
# eth0 = NAT/internet

# Allow established connections through
iptables -A FORWARD -m state \
  --state ESTABLISHED,RELATED -j ACCEPT

# Allow DMZ to reach internet via eth0
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

# Allow return traffic from internet to DMZ
iptables -A FORWARD -i eth0 -o eth1 \
  -m state --state RELATED,ESTABLISHED -j ACCEPT

# LOG lateral movement attempts before dropping
iptables -A FORWARD \
  -s 192.168.20.0/24 \
  -d 192.168.30.0/24 \
  -j LOG --log-prefix "LATERAL_MOVE: "

# DROP all DMZ to Internal traffic
iptables -A FORWARD \
  -s 192.168.20.0/24 \
  -d 192.168.30.0/24 \
  -j DROP

# Allow Kali full access to both segments
iptables -A FORWARD -s 192.168.20.1 -j ACCEPT
iptables -A FORWARD -s 192.168.30.1 -j ACCEPT

# NAT for honeypot internet access
iptables -t nat -A POSTROUTING \
  -s 192.168.20.0/24 -o eth0 -j MASQUERADE

echo "Done. Verify with: sudo iptables -L FORWARD -v --line-numbers"