# LCCT Help Desk

A Flutter app wrapping the existing LCCT help desk portal. Android/iOS source uses an embedded WebView. Windows, macOS and Linux now create an LCCT-owned native browser window automatically; they no longer send the portal to a normal browser by default. A small control window stays open alongside the portal. The web build continues to offer a browser link.

## Download

[Open app downloads](https://github.com/illyayuuki-ops/Flutter-appkkkkkk-LCCT-3rd-year/releases)

Under a published v0.3 release's **Assets**, choose:

| Device | File |
| --- | --- |
| Windows x64 | LCCT-Windows-Setup-x64.exe |
| Android phone/tablet | LCCT-Android-test.apk |
| Ubuntu/Debian x64 | LCCT-Ubuntu-Debian-amd64.deb |
| Mac | LCCT-macOS-unsigned-test.dmg (unsigned; OS may block it) |
| iPhone/iPad | Website only until TestFlight is configured |

Only share installers after the builds AND installation tests pass. Windows Setup is unsigned and may trigger SmartScreen/IT policy. Mac DMG is unsigned and unnotarized, not a trusted public release. Android is test-signed. See release notes for prerequisites and limitations. No universal installer exists. Existing v0.2 releases still have the old browser-launcher behavior.

## Publish test packages

Actions > Build downloadable test apps > Run workflow > main > unique tag such as v0.3.0-test.1. After all builds pass, test the artifacts and then publish the draft release. This workflow was prepared in a Linux workspace; Windows/macOS installer compilation and installation must be verified by CI and device testing. Do not present prepared code as already-built installers.

Windows uses Inno Setup, with Start menu and optional Desktop shortcuts plus Add/Remove Programs support. It includes signed Microsoft runtime installers fetched during CI. The LCCT executable and Setup still need a production code-signing certificate for trusted distribution. Stable private Android signing is also not configured.

## Development

Use flutter pub get, flutter analyze, flutter test. Minimum declared Dart SDK is 3.13.0; CI uses Flutter 3.50.0. Dependencies may resolve differently on Flutter 3.47.6 and must be checked locally. desktop_webview_window 0.4.3 is pinned because its initialization and native toolbar API differ from older releases.

Linux build prerequisites include clang, cmake, ninja-build, pkg-config, libgtk-3-dev, liblzma-dev, libsecret-1-dev, libwebkit2gtk-4.1-dev, libsoup-3.0-dev. Windows needs Visual Studio C++ workload and WebView2 Runtime. macOS requires Xcode, CocoaPods/plugin prerequisites and network/file entitlements included here. iOS packaging/signing is not automated.

All HTTPS department domains may navigate in the app because existing departments have independent hosts. No native JavaScript message handlers are registered. Phone/email schemes open in OS handlers; insecure HTTP and other schemes are blocked. All login behavior belongs to the websites; there is no new shared authentication. Embedded browsing does not make third-party sites or account data trustworthy. Review privacy, permissions, uploads, popups and download behavior on real devices.
