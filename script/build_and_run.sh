#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
pkill -x TomatoBar || true
xcodebuild -project TomatoBar.xcodeproj -scheme TomatoBar -configuration Release -derivedDataPath build CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= MARKETING_VERSION=3.6.1-pause.1 build >build.log 2>&1 || { tail -60 build.log; exit 1; }
APP="$PWD/build/Build/Products/Release/TomatoBar.app"
codesign --force --deep --sign - --preserve-metadata=entitlements "$APP"
codesign --verify --deep --strict "$APP"
case "${1:-run}" in
  --debug) lldb "$APP/Contents/MacOS/TomatoBar" ;;
  --logs|--telemetry) open -n "$APP"; /usr/bin/log stream --info --predicate 'process == "TomatoBar"' ;;
  --verify) open -n "$APP"; sleep 2; pgrep -x TomatoBar ;;
  run) open -n "$APP" ;;
  *) exit 2 ;;
esac
