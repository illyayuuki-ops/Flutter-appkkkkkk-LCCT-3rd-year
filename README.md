# LCCT Help Desk — Flutter portal app

Loads the existing LCCT portal: https://lcct-helpdesk.infinityfree.io/?i=1

## Download the app

**[Open downloads / GitHub Releases](https://github.com/illyayuuki-ops/Flutter-appkkkkkk-LCCT-3rd-year/releases)**

Open a published release and expand **Assets**, then choose:

- **Android phones/tablets:** `LCCT-Android-test.apk`
- **Windows x64 computers/tablets:** `LCCT-Windows-x64.zip`
- **Linux x64 (Ubuntu-compatible):** `LCCT-Linux-x64.tar.gz`
- **macOS:** `LCCT-macOS-unsigned-test.zip` — unsigned test build; signing and OS compatibility caveats apply.
- **iPhone/iPad:** use the [website](https://lcct-helpdesk.infinityfree.io/?i=1) for now. No signed iOS installer or TestFlight release is available from this workflow.

**Code → Download ZIP downloads the source, NOT the app.** Downloads appear only after the build succeeds and the owner publishes the draft release. Do not advertise unbuilt packages as ready.

See release notes for installation requirements. Windows/Linux bundles must be extracted in full. Desktop versions launch the website in the browser. Android opens it in an in-app WebView. Requires internet. This is not SSO: each website controls login and registration.

## Build and publish downloads (maintainer)

1. Commit `.github/workflows/build-downloads.yml` and `RELEASE_NOTES.md` with this README.
2. On GitHub open **Actions → Build downloadable test apps → Run workflow**.
3. Use a unique tag such as `v0.2.1-test.1` and run it on `main`.
4. Wait for all four platform jobs to succeed. If any job fails, inspect its logs; the release job will not run. Successful job artifacts remain accessible to authorized signed-in users for 14 days.
5. Open **Releases** and inspect the new **draft**. Test each package and review the caveats before publishing. Drafts are not visible to ordinary visitors.
6. Publish the pre-release. Classmates can download from its Assets section without Flutter or Git.

A tag push starting with `v` also triggers builds. The workflow will not replace an existing release automatically: choose a new tag for subsequent builds.

No paid Apple signing credentials are configured and no iOS build is distributed. Unsigned desktop packages may trigger security warnings. Current Android release config uses debug signing, which is unsuitable for reliable updates across fresh CI machines. Configure stable private signing before production. Never commit a keystore, password, Apple certificate or provisioning profile. GitHub-hosted build minutes/availability and repository Actions policy apply.

## Develop locally

Dart minimum: 3.13.0. CI uses Flutter 3.50.0 to match generated platform scaffolding.

```sh
flutter pub get
flutter analyze
flutter test
flutter run -d edge
```

The workflow is an automation configuration, not evidence of successful native builds. Android has previously been built locally by the owner; CI/native platform results still require verification.
