# Known Issue — Lateral Movement Detection Validation

## Status
Configured. Validation pending.

## Issue
iptables FORWARD chain LOG and DROP rules exist and are correctly
ordered. During testing, FORWARD counters remained at 0 despite
confirmed routing, ip_forward=1, and tcpdump showing packets
arriving on eth1 from the honeypot.

## Root cause
Kali Linux uses nftables as the default packet processing backend.
iptables commands on Kali run through iptables-nft, a compatibility
shim. nftables rules added by Docker and other services may process
packets before they reach the iptables FORWARD chain, which is why
counters never increment and LOG never fires.

## Troubleshooting performed
- ip_forward confirmed = 1
- Routing table confirmed correct for both segments
- tcpdump on eth1 confirmed packets from 192.168.20.10 arriving
- tcpdump on eth2 showed zero forwarded traffic
- rp_filter disabled on eth1 and eth2 — no change
- dummy0 interface added at 192.168.30.10 to avoid INPUT chain issue
- FORWARD, LOG, DROP counters remained at 0 throughout all tests
- nft monitor trace produced no output during test traffic
- Test target 192.168.30.1 identified as INPUT path issue (Kali
  own interface) — corrected with dummy0, still no FORWARD hit

## Why this matters
The iptables/nftables conflict is a real operational problem in
environments that mix both rulesets. The same rules written in
native nftables syntax would work correctly.

## Remediation path
Migrate the lateral movement rule to native nftables:

nft add table inet filter
nft add chain inet filter forward { type filter hook forward priority 0 \; }
nft add rule inet filter forward \
  ip saddr 192.168.20.0/24 \
  ip daddr 192.168.30.0/24 \
  log prefix \"LATERAL_MOVE: \" drop

This is deferred to avoid breaking the working
OpenCanary → Splunk pipeline during documentation.