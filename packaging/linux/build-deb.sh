#!/usr/bin/env bash
set -euo pipefail
ROOT=build/deb-package
rm -rf "$ROOT"
mkdir -p "$ROOT/DEBIAN" "$ROOT/opt/lcct-helpdesk" "$ROOT/usr/bin" \
  "$ROOT/usr/share/applications" "$ROOT/usr/share/icons/hicolor/512x512/apps" downloads
cp -a build/linux/x64/release/bundle/. "$ROOT/opt/lcct-helpdesk/"
cp packaging/lcct.png "$ROOT/usr/share/icons/hicolor/512x512/apps/lcct-helpdesk.png"
cat > "$ROOT/usr/bin/lcct-helpdesk" <<'LAUNCH'
#!/bin/sh
exec /opt/lcct-helpdesk/lcct_guidance "$@"
LAUNCH
chmod 755 "$ROOT/usr/bin/lcct-helpdesk"
cat > "$ROOT/usr/share/applications/lcct-helpdesk.desktop" <<'DESKTOP'
[Desktop Entry]
Type=Application
Name=LCCT Help Desk
Comment=LCCT department help desk portal
Exec=lcct-helpdesk
Icon=lcct-helpdesk
Terminal=false
Categories=Education;Network;
StartupNotify=true
DESKTOP
cat > "$ROOT/DEBIAN/control" <<'CONTROL'
Package: lcct-helpdesk
Version: 0.3.0
Section: education
Priority: optional
Architecture: amd64
Maintainer: LCCT Help Desk Project
Depends: libgtk-3-0, libwebkit2gtk-4.1-0, libsoup-3.0-0, libstdc++6, libc6, libsecret-1-0
Description: LCCT Help Desk application
 Native application window for the existing LCCT help desk website.
 Requires internet access. Ubuntu 22.04/24.04-compatible x64 systems.
CONTROL
chmod 755 "$ROOT/DEBIAN"
dpkg-deb --root-owner-group --build "$ROOT" downloads/LCCT-Ubuntu-Debian-amd64.deb
