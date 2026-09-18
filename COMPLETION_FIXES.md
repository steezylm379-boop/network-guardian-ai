# Network Guardian AI v1.2.0+4 — Post-audit completion fixes

## Implemented in source

- Network Health Score V1 with transparent connectivity/gateway/discovery/identity components.
- Tools tab with Android LAN-scoped Ping, curated service probing and Wake-on-LAN.
- Trusted / Unknown ownership state persisted inside the device payload.
- Per-device event history for discovery, online/offline, IP/hostname changes, identification changes, service changes, trust and corrections.
- Search and filters for All / Online / Offline / Unknown / Trusted.
- Dedicated Unknown Devices screen and dashboard identification summary.
- Light / Dark / System appearance with local persistence.
- Expanded taxonomy: router, modem, AP, switch, repeater, phone, tablet, laptop, desktop, computer, server, NAS, printer, TV, streaming device, media server, console, camera, NVR, speaker, smart-home/IoT, VoIP phone and POS terminal.
- Separate data-driven `FingerprintRule` / `DeviceFingerprintDatabase` layer.
- Separate local-only `DeviceLearningService`, conservatively reusing corrections only through strong stable identifiers.
- Android 13+ `NEARBY_WIFI_DEVICES` runtime permission handling.
- Additional source tests for health scoring, device profile/event persistence, fingerprint rules/taxonomy and local learning.
- iOS native overlay plus macOS bootstrap script. It uses Flutter-generated Xcode project files rather than hand-authored project metadata.

## Verification status

The original v1.1.0+2 source had 31 Flutter tests, 12 Android tests, analyzer clean and an APK build/signature verification. Those results **do not validate this modified v1.2.0+4 source**.

This environment does not contain Flutter/Dart/Android SDK, so the new source has not been compiled here. A structural source audit was performed: no TODO/FIXME/`UnimplementedError` production placeholders were found, delimiter balance was checked across Dart/Kotlin/Swift, and the iOS Swift overlay passed `swiftc -frontend -parse` syntax parsing.

Run `tool/verify_phase2_patch.ps1` on the Windows development PC. Then install the rebuilt APK on a physical Android device and validate real LAN discovery, DHCP identity continuity, scan cancellation, Ping, service probing and Wake-on-LAN.

## iOS caveat

The iOS overlay is source-complete enough to bootstrap the platform shell on macOS, but it is **not compiled or physically verified**. The initial iOS discovery path is intentionally more limited than Android because of Apple local-network restrictions. Wake-on-LAN is disabled in the iOS overlay until physical validation.
