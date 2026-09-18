# Network Guardian AI — Phase 3 v1.3.0+8 verification-script hotfix

## Fixed

- Corrected PowerShell Java auto-detection for the case where exactly one Android Studio JBR/JRE installation is found.
- The previous script allowed PowerShell to collapse the filtered candidate list to a scalar string. Indexing `$candidates[0]` then returned only the first character (`C`) instead of the full Java path.
- The filtered candidates are now explicitly wrapped with `@(...)`, and the selected value is returned as a string.
- Verification banner and checksum filename updated to v1.3.0+8.

## Application logic

No app/runtime logic changed in this hotfix. The Phase 3 classifier and analyzer fixes from v1.3.0+6 remain intact.

## Verification status

This exact source still needs to be executed in the user's Windows Flutter/Android environment. No build/test success is claimed by this hotfix itself.
