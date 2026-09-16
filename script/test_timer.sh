#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT
swiftc -emit-library -emit-module -module-name SwiftState build/SourcePackages/checkouts/SwiftState/Sources/*.swift -o "$TEST_DIR/libSwiftState.dylib" -emit-module-path "$TEST_DIR/SwiftState.swiftmodule"
sed '/^import KeyboardShortcuts$/d' TomatoBar/Timer.swift > "$TEST_DIR/Timer.swift"
cat >> "$TEST_DIR/Timer.swift" <<'SWIFT'

extension TBTimer {
    func finishForTest() {
        finishTime = Date().addingTimeInterval(-0.01)
        onTimerTick()
    }
}
SWIFT
swiftc -I "$TEST_DIR" -L "$TEST_DIR" -lSwiftState -Xlinker -rpath -Xlinker "$TEST_DIR" "$TEST_DIR/Timer.swift" TomatoBar/State.swift tests/TimerTests.swift -o "$TEST_DIR/TimerTests"
"$TEST_DIR/TimerTests"
