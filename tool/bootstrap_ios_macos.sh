#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter is required." >&2
  exit 1
fi
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Run this script on macOS with Xcode installed." >&2
  exit 1
fi
flutter create --platforms=ios --org com.networkguardian .
cp tool/ios_overlay/AppDelegate.swift ios/Runner/AppDelegate.swift
/usr/libexec/PlistBuddy -c "Add :NSLocalNetworkUsageDescription string Network Guardian discovers devices on Wi-Fi networks you are authorized to inspect." ios/Runner/Info.plist 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Set :NSLocalNetworkUsageDescription Network Guardian discovers devices on Wi-Fi networks you are authorized to inspect." ios/Runner/Info.plist
/usr/libexec/PlistBuddy -c "Add :NSBonjourServices array" ios/Runner/Info.plist 2>/dev/null || true
for service in _http._tcp _https._tcp _ipp._tcp _ipps._tcp _printer._tcp _airplay._tcp _raop._tcp _googlecast._tcp _workstation._tcp; do
  /usr/libexec/PlistBuddy -c "Add :NSBonjourServices: string $service" ios/Runner/Info.plist 2>/dev/null || true
done

echo "iOS project generated. Open ios/Runner.xcworkspace in Xcode, configure signing, then run flutter build ios."
