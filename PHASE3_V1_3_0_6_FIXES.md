# Network Guardian AI — Phase 3 v1.3.0+6 verification hotfix

This checkpoint addresses issues found by the first real Windows verification run of v1.3.0+5.

## Source fixes

- Corrected intelligence conflict handling so weak hostname/port hints do not collapse a strong UPnP device classification. A conflict is now raised only when the top two meaningful candidates are close enough to be genuinely ambiguous.
- Preserved conservative conflict behavior for contradictory strong evidence such as different manufacturer signals.
- Added the missing `@override` annotations to `ping`, `probeServices`, and `wakeOnLan`.
- Pinned Android NDK to `28.2.13676358` for reproducible Flutter 3.47.4 builds.
- Version bumped to `1.3.0+6`.

## Verification-script fixes

- Every external command now checks its exit code and stops immediately on failure.
- Automatically finds Android Studio's bundled JDK and sets `JAVA_HOME` for the verification process.
- Resolves the Android SDK from environment, local.properties, or the default Windows SDK location.
- Preflights the required NDK before tests/build and gives exact Android Studio installation steps when missing.
- Does not claim success after failed Flutter tests or failed Android tests.

## Still required on the Windows build machine

Android NDK `28.2.13676358` (NDK Side by side) must be installed before the Android JVM/build stages can complete.

Physical-LAN behavior remains unverified because no physical Android device is available.
