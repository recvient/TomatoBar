# TomatoBar with Pause / Resume

Personal fork of [ivoronin/TomatoBar](https://github.com/ivoronin/TomatoBar).

Adds a Pause / Resume button (⌘P while the popover is open) for work and break intervals. Pausing preserves the remaining time, silences ticking, and shows Ⅱ next to the menu bar countdown. Stop still resets the session. `tomatobar://pauseresume` also toggles pause.

Local version: `3.6.1-pause.1`. Requires macOS 12 or later and Xcode to build. Existing settings and launch-at-login identity are retained.

Build and launch: `./script/build_and_run.sh --verify`.
Timer behavior checks: `./script/test_timer.sh` after building. These compile the actual timer and state machine with mock sound, notification, status-item, and shortcut services.

The build script uses local ad hoc signing, including the legacy login helper. No Apple Developer account is required for this local build.

---

<p align="center">
<img src="https://raw.githubusercontent.com/ivoronin/TomatoBar/main/TomatoBar/Assets.xcassets/AppIcon.appiconset/icon_128x128%402x.png" width="128" height="128"/>
<p>
 
<h1 align="center">TomatoBar</h1>
<p align="center">
<img src="https://img.shields.io/github/actions/workflow/status/ivoronin/TomatoBar/main.yml?branch=main"/> <img src="https://img.shields.io/github/downloads/ivoronin/TomatoBar/total"/> <img src="https://img.shields.io/github/v/release/ivoronin/TomatoBar?display_name=tag"/> <img src="https://img.shields.io/homebrew/cask/v/tomatobar"/>
</p>

<img
  src="https://github.com/ivoronin/TomatoBar/raw/main/screenshot.png?raw=true"
  alt="Screenshot"
  width="50%"
  align="right"
/>

## Overview
Have you ever heard of Pomodoro? It’s a great technique to help you keep track of time and stay on task during your studies or work. Read more about it on <a href="https://en.wikipedia.org/wiki/Pomodoro_Technique">Wikipedia</a>.

TomatoBar is world's neatest Pomodoro timer for the macOS menu bar. All the essential features are here - configurable
work and rest intervals, optional sounds, discreet actionable notifications, global hotkey.

TomatoBar is fully sandboxed with no entitlements.

Download the latest release <a href="https://github.com/ivoronin/TomatoBar/releases/latest/">here</a> or install using Homebrew:
```
brew install --cask tomatobar
```

If the app doesn't start, install using the `--no-quarantine` flag:
```
brew install --cask --no-quarantine tomatobar
```

## Integration with other tools
### Event log
TomatoBar logs state transitions in JSON format to `~/Library/Containers/com.github.ivoronin.TomatoBar/Data/Library/Caches/TomatoBar.log`. Use this data to analyze your productivity and enrich other data sources.
### Starting and stopping the timer
TomatoBar can be controlled using `tomatobar://` URLs. To start or stop the timer from the command line, use `open tomatobar://startStop`.

## Older versions
Touch bar integration and older macOS versions (earlier than Big Sur) are supported by TomatoBar versions prior to 3.0

## Licenses
 - Timer sounds are licensed from buddhabeats
