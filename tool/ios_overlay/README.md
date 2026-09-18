# iOS native overlay

This source is intentionally applied on macOS using `tool/bootstrap_ios_macos.sh` rather than hand-authoring Xcode project files.

It provides the same Flutter channels used by Android. iOS local-network restrictions mean the initial iOS scanner uses bounded TCP reachability and reports unavailable metadata honestly. Wake-on-LAN is disabled in this checkpoint until it is validated on physical iOS hardware.

The iOS build remains **UNVERIFIED** until generated and compiled with Xcode on a Mac and tested on a physical iPhone.
