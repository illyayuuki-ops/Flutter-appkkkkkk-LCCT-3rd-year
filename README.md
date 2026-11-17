# LCCT Portal Wrapper v0.2

This version replaces the previous Guidance demonstration. No demo login, role selection, or ticket database is used.

The only portal URL is https://lcct-helpdesk.infinityfree.io/?i=1.

## Behavior
- Android/iOS: automatically loads the actual website in an embedded WebView. Department HTTPS navigation stays in the WebView. Back, home, reload, loading progress, network error message, and external browser action are provided.
- Windows/macOS/Linux: button opens the portal in the default browser, not an embedded desktop view.
- Flutter web: button navigates to the portal in the current tab. No iframe, which avoids dependence on cross-origin embedding permission. This is a launcher, not an embedded web version.
- The existing websites control login, registration, sessions, and all services. No shared sign-on is added. In-app WebView cookies are not guaranteed to match external browser sessions.

## Run with your existing Flutter
Dart minimum is 3.13.0. Your Flutter 3.47.6 / Dart 3.13.5 meets this declared minimum. This revision was analyzed and widget-tested on Flutter 3.50.0; 3.47.6 compatibility still needs local verification. The zip deliberately omits pubspec.lock so your SDK resolves compatible plugin releases.

Open this folder (containing pubspec.yaml):

```powershell
flutter pub get
flutter analyze
flutter run -d edge
```

In Edge, click **Open LCCT portal**. The real landing page opens in the same tab. To see the embedded version, run on Android/iOS, not Edge.

For Android:
```powershell
flutter devices
flutter run -d YOUR_ANDROID_DEVICE_ID
```
Requires Android SDK, compatible Java/Gradle toolchain and a connected device or emulator. Android INTERNET permission is included in the main manifest. iOS requires macOS/Xcode and signing. Generated native platform projects are included; native builds have not been tested.

## Update an existing extracted prototype
Stop Flutter with q. Back up your current folder. Replace lib/main.dart, pubspec.yaml and test/widget_test.dart with the files in this package. Add `<uses-permission android:name="android.permission.INTERNET"/>` directly inside `<manifest>` in android/app/src/main/AndroidManifest.xml, or use the included manifest if you have not customized yours. Keep assets/lcct-seal.png. Run flutter pub get again. Do not paste Dart into the PowerShell terminal.

## Limitations and testing
Two tests and static analysis passed on the build SDK. These verify the URL and launcher UI, NOT live departmental logins or native WebView navigation. Real-device testing is still required. File uploads, downloads, target=_blank windows, QR/camera flows, third-party cookies and external identity providers may need additional platform handling; use the browser fallback if these fail. No SSL bypass or password injection is implemented. Unknown custom URL schemes are blocked in the mobile view. HTTPS cross-domain navigation is allowed because the departments have different hosts. An offline app cannot load the portal.

A website-wrapper app may not satisfy app-store minimum-functionality review. No store-ready or universal embedded-desktop claim is made.

Nothing has been pushed to GitHub or deployed to the school site.
