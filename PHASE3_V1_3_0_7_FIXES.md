# Network Guardian AI — Phase 3 v1.3.0+7 verification-script hotfix

## Fixed

- Fixed PowerShell Java auto-detection when exactly one Android Studio JBR/JRE candidate exists.
- Previous script could treat the single path as a scalar string and `$candidates[0]` returned only the first character (`C`) instead of the full Java path.
- Java candidate results are now explicitly wrapped as an array and returned as a string.
- Verification banner and APK checksum filename updated to v1.3.0+7.

## No application logic changed

This hotfix changes only the verification tooling and package build number. The Phase 3 app logic/classifier fixes from v1.3.0+6 remain unchanged.

## Verification status

This source still requires execution on the user's Windows Flutter/Android environment. No new build/test success is claimed by this hotfix itself.
