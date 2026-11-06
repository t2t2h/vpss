# AflatoonCore — fresh Theos dylib project

A clean rebuild inspired by selected ideas from the earlier project: a compact cyber-style control panel, persistent preferences, sound preference sliders, and a network-information preference. VPN/WireGuard, packet tunnel code, server scripts, game-clock manipulation, DNS interception, symbol rebinding, and third-party hooking have intentionally been excluded.

## Build

This is a Theos `library.mk` target named `AflatoonCore`. GitHub Actions builds it on macOS and uploads `AflatoonCore.dylib` as an artifact.

1. Push the repository to GitHub.
2. Open Actions → Build AflatoonCore dylib → Run workflow.
3. Download the `AflatoonCore-dylib` artifact.

## Important integration note

This library provides a small in-app launcher and settings panel when loaded into a host app that permits the library to run. The sound sliders are stored preferences only; they do not claim to process microphone or playback audio. DNS remains managed by iOS. This project does not inject itself into other apps and does not bypass iOS signing, sandboxing, or platform security.

## Files

- `AflatoonCore.m` — startup and floating launcher
- `APPanel.m/.h` — control center UI
- `APSettings.m/.h` — persistent settings
- `Makefile` — Theos dylib target
- `.github/workflows/build.yml` — reproducible GitHub Actions build
