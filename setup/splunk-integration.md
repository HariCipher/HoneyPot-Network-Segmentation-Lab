# Splunk Integration

## What this does

Splunk was integrated with the honeypot to collect, search, and analyze OpenCanary events. A Universal Forwarder was installed on the honeypot to send logs to Splunk.

## Commands

Forwarder installation:

```bash
sudo dpkg -i splunkforwarder*.deb
```

Forward server configuration:

```bash
sudo /opt/splunkforwarder/bin/splunk add forward-server 192.168.20.1:9997
```

Verification:

```spl
index=honeypot
```

## Verification

* Confirmed the Universal Forwarder connected to Splunk.
* Created a dedicated honeypot index.
* Verified OpenCanary logs appeared in Splunk searches.
* Created and tested detection rules.

## Issues Encountered

### Universal Forwarder download URL returned 404

The original download URL provided in the guide no longer existed.

**Fix:** Downloaded a newer supported Universal Forwarder version.

**Result:** Installation completed successfully.

### Logs not appearing in Splunk

Even after installation, no events appeared in the honeypot index.

**Root Cause:** Incorrect inputs.conf configuration and the forwarder was not restarted after changes.

**Fix:** Corrected inputs.conf and restarted the Universal Forwarder.

**Result:** OpenCanary events immediately began appearing in Splunk.

### Lateral movement detection validation

The detection logic was configured, but validation could not be completed.

**Investigation performed:**

* Verified routing.
* Verified IP forwarding.
* Tested firewall rules.
* Captured packets with tcpdump.
* Reviewed nftables configuration.

**Result:** Detection remains configured, with validation deferred for future improvement while preserving the working monitoring pipeline.
