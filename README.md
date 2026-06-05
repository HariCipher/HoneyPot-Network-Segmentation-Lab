# Honeypot + Network Segmentation Lab

**Lab environment:** VMware Workstation, Kali Linux  
**Honeypot:** OpenCanary  
**SIEM:** Splunk Enterprise 10.2.3  
**Author:** Harilal P  
**GitHub:** github.com/HariCipher  

---

## What this is

A segmented home lab with an isolated honeypot in a DMZ network
and a Splunk detection pipeline. The honeypot runs OpenCanary
simulating SSH, HTTP, FTP, Telnet, and SMB. Any connection to it
is suspicious by definition — nothing legitimate should touch it.
Two detections are validated and live. A third is configured with
a documented root cause for why validation is pending.

---

## Architecture
```
Internet
│
VMware NAT — VMnet8 (192.168.117.0/24)
│
Kali Linux (router + SIEM host)
eth0: 192.168.117.128
│
├── eth1 → VMnet2 — DMZ (192.168.20.0/24)
│   └── Honeypot: 192.168.20.10
│       OpenCanary: SSH/HTTP/FTP/Telnet/SMB
│
└── eth2 → VMnet3 — Internal (192.168.30.0/24)
    └── Reserved — detection stack expansion
```
---

## Detection status

| # | Name | Source | Status |
|---|------|--------|--------|
| 1 | Any honeypot connection | OpenCanary → Splunk | ✅ Validated |
| 2 | Lateral movement DMZ → Internal | iptables LOG → kern.log | ⚠️ Configured, not validated |
| 3 | SSH brute force on honeypot | OpenCanary logtype 4002 | ✅ Validated |

Detection 2 is configured but blocked by an iptables/nftables
compatibility issue on Kali. See
[known-issues/lateral-movement-validation.md](known-issues/lateral-movement-validation.md)
for full root cause and remediation path.

---

## Key findings from the lab

- OpenCanary logged a real SSH credential attempt in real time:
  `src_host: 192.168.20.1, USERNAME: root, PASSWORD: hari, logtype: 4002`
- Detection 3 shows count=8 for src_host 192.168.20.1 — brute
  force threshold exceeded
- Honeypot correctly isolated: reaches 192.168.20.1, cannot reach
  192.168.30.1 or 8.8.8.8
- Splunk index=honeypot receiving live OpenCanary events

---

## MITRE ATT&CK

| Technique | ID | Implemented as |
|-----------|----|----------------|
| Deception / Honeypot | T1588 | OpenCanary fake services |
| Network Segmentation | M1030 | VMnet2/VMnet3 isolation |
| Lateral Movement Detection | T1021 | iptables LOG/DROP rules |
| Credential Monitoring | T1110 | OpenCanary logtype 4002 |

---

## Screenshots

| File | Description |
|------|-------------|
| Virtual_Network_Editor.png | VMnet2 (192.168.20.0/24) and VMnet3 (192.168.30.0/24) created |
| ip_a.png | Kali eth1 and eth2 adapters added, no IPs yet |
| kali-interfaces-with-ips.png | eth1=192.168.20.1, eth2=192.168.30.1 assigned and persisted |
| honeypot-ping-test.png | Segmentation verified — gateway reachable, Internal and internet blocked |
| opencanary-status.png | OpenCanary running with FTP/HTTP/SSH/Telnet/SMB loaded |
| nmap-honeypot.png | Ports 21/22/23/80 open and fingerprinted on honeypot |
| opencanary-log.png | SSH credential attempt logged in real time with username and password |
| iptables-rules.png | FORWARD chain LOG and DROP rules for lateral movement |
| splunk-honeypot-index.png | OpenCanary events flowing into Splunk honeypot index |
| detection-any-connection.png | Detection 1 returning 16 events across logtypes 4000/4001/4002 |
| detection-ssh-bruteforce.png | Detection 3 — src_host 192.168.20.1, count 8 |
| splunk-alerts-page.png | Both alerts saved and enabled in Splunk |

---

## Known issues

Detection 2 validation blocked by iptables/nftables conflict on Kali.
Full analysis in [known-issues/lateral-movement-validation.md](known-issues/lateral-movement-validation.md).

---

## References

- [OpenCanary](https://github.com/thinkst/opencanary)
- [malware-traffic-analysis.net](https://malware-traffic-analysis.net)
- [MITRE ATT&CK](https://attack.mitre.org)