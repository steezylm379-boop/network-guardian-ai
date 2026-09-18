# Network Guardian AI v1.2.0+4 — Flutter 3.47 analyzer hotfix

This hotfix addresses the four deprecation infos reported by Flutter 3.47.4 during the first real verification run on Windows:

- Replaced `Color.withOpacity(...)` with `Color.withValues(alpha: ...)` in theme and dashboard code.
- Replaced deprecated `DropdownButtonFormField.value` with `initialValue` and a `ValueKey` so the field still refreshes correctly when the selected device changes.
- Removed the obsolete `-d` flag from the `build_runner` verification command.
- Bumped the package version from `1.2.0+3` to `1.2.0+4`.

No network-discovery, identity, database, or diagnostic behavior was intentionally changed by this hotfix.

Run on Windows from the project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\verify_phase2_patch.ps1
```

Fresh analyzer/tests/APK results are required. Physical Android LAN validation remains required after automated verification passes.
