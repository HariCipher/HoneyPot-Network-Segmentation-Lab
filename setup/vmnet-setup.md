# VMnet Setup

## What this does

Before building the lab, I needed separate network segments to simulate a small enterprise environment. I created a DMZ network for the honeypot and an Internal network that would sit behind the Kali router.

## Commands

No terminal commands were required for this phase.

Steps performed:

* Opened VMware Virtual Network Editor.
* Created VMnet2 for the DMZ segment.
* Created VMnet3 for the Internal segment.
* Disabled DHCP on both custom networks.
* Connected VM adapters to the appropriate VMnet.

## Verification

* Verified VMnet2 and VMnet3 appeared in VMware.
* Confirmed VMs were attached to the correct network segments.
* Verified devices could only communicate through the Kali router.

## Issues Encountered

### VM attached to wrong network

During testing, one of the VM adapters was attached to the wrong VMnet. This caused connectivity problems and made troubleshooting confusing.

**Fix:** Reviewed all VM network adapter settings and reassigned them to the correct VMnet.

**Result:** Network segmentation behaved as expected.
