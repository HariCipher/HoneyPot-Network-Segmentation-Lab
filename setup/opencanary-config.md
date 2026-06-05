# OpenCanary Configuration

## What this does

OpenCanary was deployed as the honeypot platform. It exposes common services and generates logs whenever someone interacts with them.

## Commands

Installation:

```bash
sudo apt update
sudo apt install python3-pip -y

pip install opencanary
```

Configuration:

```bash
opencanaryd --copyconfig
nano ~/.opencanary.conf
```

Verification:

```bash
sudo ss -tulpn

tail -f /var/log/opencanary.log

nmap -sV 192.168.20.10
```

## Verification

* Confirmed OpenCanary services were listening.
* Performed Nmap scans against the honeypot.
* Generated SSH connection attempts.
* Verified events appeared in opencanary.log.

## Issues Encountered

### OpenCanary command not found

After installation, the OpenCanary command could not be executed.

**Fix:** Verified installation path and corrected command usage.

**Result:** OpenCanary started successfully.

### Service verification

Some services were not generating expected events initially.

**Fix:** Reviewed configuration and tested using Nmap and SSH.

**Result:** Events were logged correctly.
