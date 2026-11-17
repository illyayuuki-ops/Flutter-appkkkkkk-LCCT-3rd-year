# LCCT Help Desk — class testing

Choose the download for your operating system under **Assets**. Source code ZIP/TAR downloads are NOT installation packages.

| Device | Asset / method |
| --- | --- |
| Android phones/tablets/emulators | `LCCT-Android-test.apk` |
| Windows 10/11 x64 computers/tablets | `LCCT-Windows-x64.zip` — extract ALL files, then run `lcct_guidance.exe` |
| Linux x64, Ubuntu 22.04-compatible desktop | `LCCT-Linux-x64.tar.gz` — extract the full bundle, run `./lcct_guidance` |
| Mac | `LCCT-macOS-unsigned-test.zip` — unsigned test build; see caveat below |
| iPhone/iPad | No iOS installer is provided. Use the website until a signed TestFlight build exists. |
| Other devices / unsupported CPUs | Use https://lcct-helpdesk.infinityfree.io/?i=1 |

## Important limitations
- This is a testing release, not an all-device or store-certified release. Maintainers must inspect build logs and test each package before publishing.
- Android: allow installation from the trusted file source only if appropriate. This project currently uses debug signing even for the release-mode APK. GitHub's fresh runner may generate a DIFFERENT signing key than a previous APK, so updates may fail. Uninstalling the old app clears its saved sessions. Stable production signing is not configured; do not use this setup for long-term distribution.
- Windows: unsigned portable app, not a setup wizard. Keep the EXE, DLLs, data and other files together. Microsoft Visual C++ x64 runtime may be required. Security warnings may appear; do not disable system protection.
- macOS: unsigned/unnotarized test application, built on an Apple Silicon runner. It is not a frictionless public installer and Intel compatibility is not promised. macOS may block it. Do not bypass protection blindly; school-approved signing/notarization is needed for ordinary public distribution.
- Linux: distribution libraries and desktop URL-handler support are required; not a universal Linux installer.
- Android/iOS source uses an embedded website. Desktop packages open the portal in the default browser; they do not add an embedded desktop website.
- An internet connection is required. The real websites control accounts and all submissions. Do NOT submit fictional support tickets or sensitive information for testing.
- No shared sign-on is added. APKs cannot install on iPhones/iPads. A signed Apple distribution process, such as TestFlight, must be configured separately.

Compare SHA-256 hashes with `SHA256SUMS.txt` if needed. Never share passwords or private records in bug reports. Report device, OS version, asset name, and steps to reproduce.
