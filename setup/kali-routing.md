# Kali Router Configuration

## What this does

Kali Linux acts as the router between the DMZ and Internal networks. It is responsible for forwarding traffic between segments and providing internet access to the honeypot.

## Commands

```bash
ip addr
ip route

sudo sysctl -w net.ipv4.ip_forward=1

cat /proc/sys/net/ipv4/ip_forward
```

Network verification:

```bash
ip route
ping 8.8.8.8
```

## Verification

* Confirmed eth0, eth1, and eth2 were assigned correctly.
* Verified IP forwarding was enabled.
* Confirmed the honeypot could reach the router.
* Verified internet access worked through Kali.

## Issues Encountered

### Honeypot lost internet access

After modifying firewall rules, the honeypot suddenly lost internet connectivity.

**Fix:** Reviewed forwarding and NAT configuration and restored the required rules.

**Result:** Internet access was restored successfully.

### Lateral movement validation issue

The FORWARD-chain logging rules were configured, but traffic never triggered the expected counters.

**Result:** Detection was documented as configured but pending validation.
