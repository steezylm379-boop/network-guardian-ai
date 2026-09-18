# Phase 1 status — Network Guardian AI

Phase 1 is **not yet accepted**: physical Android acceptance testing is outstanding.
**NOT VERIFIED ON PHYSICAL DEVICE**.

## COMPLETED

Implemented source (this section does not imply physical-device verification):

- Flutter Android project, Material 3 custom theme, Riverpod controller and go_router.
- Overview, live address progress, cancellation action, device list, details,
  optional permissions settings and network/scan history browser.
- NetworkInfoService reads actual Wi-Fi IPv4, prefix, gateway and interface.
- Correct IPv4 CIDR/range arithmetic including /31 and /32; explicit large-LAN cap.
- Native bounded concurrent reachability and TCP fallback; no fabricated responses.
- Best-effort ARP enrichment and Wi-Fi-bound reverse DNS PTR resolver.
- Android NSD discovery of all seven requested service types; services/TXT persisted.
- UUID device identities, MAC normalization, observation consolidation and conflict handling.
- Bundled offline IEEE MA-L OUI database; unknown/private MACs are not guessed.
- Drift SQLite Networks, Devices, DeviceServices and ScanSessions schema.
- Transactional snapshot persistence, first/last seen, completed-scan offline updates,
  cancellation/error history, interrupted-session recovery on database reopen.
- Network-change cancellation, socket cleanup, throttled UI updates and debug event logs.
- Setup/build/test documentation, Android restrictions and physical verification procedure.

## PARTIALLY COMPLETED

- Real-world discovery reliability: implemented, awaiting Android 13/14/15 devices.
- MAC resolution: best-effort ARP; generally restricted on modern stock Android.
- Physical identity without MAC: same-IP observations merge; hostnames are fallback
  evidence. mDNS instance names are stored but are not assumed globally unique.
- Network continuity with hidden BSSID: connection/boot scoping avoids mixing
  identically named LANs, but reconnects can split history.
- Interactive Android validation: the APK installed, the app rendered its overview,
  and the native bridge detected the emulator network. Repeated emulator System UI
  ANR dialogs prevented reliable interactive scan/responsiveness qualification.

## NOT IMPLEMENTED

- Phase 2 features, AI identification, security scanning, topology, monitoring,
  alerts, speed tests, cloud services, accounts, payments, VPN or network attacks.
- Root-only or hidden-API MAC extraction.
- IPv6 discovery, scanning more than 4,096 usable addresses, MA-M/MA-S registry data.
- A release signing identity or Play Store release qualification.

## KNOWN LIMITATIONS

- Android minimum API 33; target API 35. Android 16 opt-in and future target
  local-network permission changes need separate qualification.
- Firewalls, sleeping clients and Wi-Fi isolation prevent exhaustive discovery.
- “Offline” means absent from a completed scan, not proof a device is powered off.
- ARP tables can be inaccessible; stale cache entries never establish liveness.
- Hostnames and mDNS are optional advertisements and may be missing or ambiguous.
- NSD resolution is serialized and bounded; very busy networks may have services
  left unresolved when the drain deadline expires.
- Java ICMP and Android 13 NSD callbacks are not fully interruptible; late results
  are discarded and bounded work is allowed to finish.
- Unfinished scan observations are not durable until the final save transaction.
- Roaming between access points can create distinct network records.
- Optional identity permission does not enable location services automatically.

## REAL DEVICE TEST RESULTS

`adb devices -l` returned no connected devices during initial inspection.

| Platform | Result |
|---|---|
| Android 13 physical | NOT VERIFIED ON PHYSICAL DEVICE |
| Android 14 physical | NOT VERIFIED ON PHYSICAL DEVICE |
| Android 15 physical | NOT VERIFIED ON PHYSICAL DEVICE |
| Real LAN peers / mDNS / cancellation | NOT VERIFIED ON PHYSICAL DEVICE |

Android 15 emulator-only smoke evidence: installation succeeded, the Dart runtime
started, `network_detected` was logged, and a captured overview displayed the actual
virtual `10.0.2.0/24` network with host range `10.0.2.1–10.0.2.254`. The OS repeatedly
showed **System UI isn't responding** dialogs, including after a lower-memory retry.
The host has about 6 GB RAM. Android's activity wait timed out during that retry;
the app subsequently rendered behind the system dialog. This is partial startup
evidence, not a passing interactive acceptance test. No physical LAN scan or
multiple-peer discovery is claimed. The temporary emulator was stopped afterward.

## Build and automated verification

Toolchain installed: Flutter 3.47.4, Dart 3.13.3, JDK 17.

| Command | Result |
|---|---|
| flutter pub get | Passed during scaffolding |
| dart run build_runner build | Passed; Drift generated source produced |
| flutter analyze | Passed: no issues found |
| flutter test | Passed: all 13 tests |
| flutter build apk --debug | Passed: build/app/outputs/flutter-apk/app-debug.apk |
| Android JVM tests | Passed: 3 tests, 0 failures, 0 errors |

The APK is a universal debug build (167,181,653 bytes), not a release package.
SHA-256: `E68A7803512CD98C5D2BDC44D9CC0AC0EAE0D99CBFABB6C80C27159F0289774D`.
Build setup installed SDK 36, Build Tools 36, NDK 28.2 and CMake 3.22.1.
The first APK attempt hit a transient GitHub DNS failure while downloading SQLite;
the retry completed successfully. The overview widget-test render was visually
inspected with bundled fonts. It is not a physical-device screenshot.

## Acceptance checklist

- [ ] APK launches on physical Android 13, 14 and 15.
- [ ] Real local IP, prefix, gateway and network name availability checked.
- [ ] Real LAN scan detects multiple known peers, including mDNS services.
- [ ] UI progress, responsiveness and cancellation checked on hardware.
- [ ] MAC lookup behavior checked where permitted, denial handled gracefully.
- [ ] Reverse DNS names compared with real router DNS records.
- [ ] Multi-source observations and DHCP changes verified against peer identities.
- [ ] Restart persistence and returning/absent peer timestamps checked on hardware.
- [ ] Permission denial and Wi-Fi loss during a scan tested on hardware.
- [x] No mock scan results or fabricated product identity shipped.

See README for the detailed test procedure. Do not change unchecked items without
recording device/build/network evidence.
