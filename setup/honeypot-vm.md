# Ubuntu Honeypot VM Setup

## What this does

This VM hosts OpenCanary and represents a system placed inside the DMZ. It is intentionally exposed so attacker activity can be monitored and logged.

## Commands

Checking network configuration:

```bash
ip addr
ip route
```

Applying Netplan configuration:

```bash
sudo netplan apply
```

Connectivity testing:

```bash
ping 192.168.20.1
ping 8.8.8.8
```

## Verification

* Confirmed Ubuntu Server installed successfully.
* Verified static IP assignment.
* Verified communication with the Kali router.
* Verified internet access.

## Issues Encountered

### Ubuntu ISO installation issue

The Ubuntu installation media was not booting correctly during deployment.

**Fix:** Reattached the ISO image and verified VMware boot settings.

**Result:** Installation completed successfully.

### Static IP configuration problems

Initial network settings prevented connectivity.

**Fix:** Corrected Netplan configuration and reapplied settings.

**Result:** Network communication worked normally.
