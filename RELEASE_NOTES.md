# LCCT Help Desk v0.3 - installation test

The desktop portal now opens in an LCCT application-owned browser window, not the regular browser. A small LCCT control window remains available for reopening the portal. Existing websites still control login, registration and all services.

## Downloads under Assets

- **Windows 10/11 x64:** `LCCT-Windows-Setup-x64.exe`. Run Setup, allow the normal administrator prompt if authorized, then use the LCCT Help Desk Start menu/Desktop shortcut. The installer includes Microsoft's signed VC++ redistributable and WebView2 bootstrapper. Internet may be needed to install WebView2. The LCCT installer itself is unsigned: Windows/organization policy may warn or block it. Do not disable protection. Managed school PCs may require IT assistance.
- **Android phones/tablets:** `LCCT-Android-test.apk`. Open it using the Android package installer. Android may require permission to install from the trusted download source. This is still a test-signed build, not Play Store distribution; updates over APKs signed by another key may fail. Do not uninstall without considering session loss.
- **Ubuntu/Debian-compatible x64 Linux:** `LCCT-Ubuntu-Debian-amd64.deb`. Open in the system package installer; dependency resolution and administrator authorization are required. Built against Ubuntu 22.04 and WebKitGTK 4.1; not every Linux distribution is supported. Application menu entry is LCCT Help Desk. A tar.gz is also offered for technical testers, not the recommended easy download.
- **Mac:** `LCCT-macOS-unsigned-test.dmg`. Open the disk image, drag the application to Applications. This build is **unsigned and not notarized**, so macOS may block it. This is not yet ordinary frictionless public distribution; Apple signing/notarization still needs owner configuration. Do not bypass security blindly. Built on GitHub's macos-15 runner; check supported architecture before distributing.
- **iPhone/iPad:** no installable iOS release. Use https://lcct-helpdesk.infinityfree.io/?i=1 until Apple Developer signing and TestFlight are configured.

## Test before sharing widely

Build success alone does not verify installation or browser behavior. Test Setup/uninstall, first launch, all department redirects, login/logout, Back/Reload, popups, attachments, downloads, offline errors and closing/reopening. OAuth/SSO providers may reject embedded browsers. Camera/QR, microphone and printing require separate review and platform permissions; not guaranteed here.

HTTPS navigation stays in-app, while phone/email links use OS handlers. Plain HTTP pages and unknown schemes are blocked. TLS verification is not disabled. New-window/download behavior depends on each website and native web engine and needs device testing. No password injection, centralized account scanning, or SSO is added. Website submissions are LIVE, not sandbox data. Do not submit fake tickets or sensitive data to test.

Browser data persists in the OS web engine profile (Windows uses the per-user application-support directory). Signing out of every department is essential on shared computers. Uninstall may retain profile data; this release does not erase it automatically.

Packages remain unsigned/test-signed; do not describe this as a fully trusted all-device store release. GitHub Release Assets are the app downloads. Source code ZIP is not an installer. Checksums are in SHA256SUMS.txt.
