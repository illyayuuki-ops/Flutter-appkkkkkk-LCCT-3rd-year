// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _portal = 'https://lcctanauan-helpdesk.infinityfree.io/?i=1';

/// Only HTTPS web pages are loaded in the application browser.
/// Phone/email actions use the operating system, without login injection.
bool allowDesktopNavigation(String value) {
  final uri = Uri.tryParse(value);
  return uri != null &&
      ((uri.scheme == 'https' && uri.host.isNotEmpty) ||
          value == 'about:blank');
}

class DesktopPortal extends StatefulWidget {
  const DesktopPortal({super.key});
  @override
  State<DesktopPortal> createState() => _DesktopPortalState();
}

class _DesktopPortalState extends State<DesktopPortal> {
  Webview? browser;
  StreamSubscription<WebviewLoadError>? loadErrors;
  bool busy = false;
  String? problem;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => openPortal());
  }

  Future<void> openPortal() async {
    if (busy) return;
    if (browser != null) {
      await browser!.launch(_portal);
      return;
    }
    setState(() {
      busy = true;
      problem = null;
    });
    Webview? created;
    try {
      if (!await WebviewWindow.isWebviewAvailable()) {
        throw StateError(
          'Microsoft Edge WebView2 Runtime is missing. '
          'Run LCCT Setup again with the runtime component selected.',
        );
      }
      final directory = await getApplicationSupportDirectory();
      await directory.create(recursive: true);
      created = await WebviewWindow.create(
        configuration: CreateConfiguration(
          title: 'LCCT Help Desk',
          windowWidth: 1200,
          windowHeight: 820,
          windows: WindowsWebviewOptions(
            userDataFolder: p.join(directory.path, 'LCCT-WebView2'),
          ),
        ),
      );
      if (!mounted) {
        await created.close();
        return;
      }
      browser = created;
      loadErrors = created.onLoadError.listen((_) {
        if (!mounted) {
          return;
        }
        setState(
          () => problem =
              'The portal could not load. '
              'Check your internet connection and use Reload in the portal window.',
        );
      });
      await created.setOnUrlRequestCallback((url) {
        if (allowDesktopNavigation(url)) return true;
        final uri = Uri.tryParse(url);
        if (uri != null && ['mailto', 'tel'].contains(uri.scheme)) {
          unawaited(_openContact(uri));
        }
        if (mounted && uri?.scheme == 'http') {
          setState(
            () => problem =
                'An insecure HTTP page was blocked. '
                'Ask the department for its HTTPS address.',
          );
        }
        return false;
      });
      unawaited(
        created.onClose.then((_) {
          unawaited(loadErrors?.cancel());
          loadErrors = null;
          if (mounted) setState(() => browser = null);
        }),
      );
      await created.launch(_portal);
    } catch (e) {
      if (created != null) {
        try {
          await created.close();
        } catch (_) {}
      }
      if (mounted) {
        setState(() {
          browser = null;
          problem = e is StateError
              ? e.message.toString()
              : 'Could not open the app browser. Restart the app or rerun Setup. '
                    '${Platform.isLinux ? "Ensure the WebKitGTK 4.1 runtime is installed." : ""}';
        });
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _openContact(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  void dispose() {
    unawaited(loadErrors?.cancel());
    final current = browser;
    if (current != null) unawaited(current.close().catchError((_) {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('LCCT Help Desk')),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/lcct-seal.png', height: 96),
              const SizedBox(height: 24),
              const Text(
                'LCCT Help Desk',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'The portal opens in its own LCCT application window, '
                'not your regular browser. Use that window to choose a department.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (busy) const CircularProgressIndicator(),
              if (!busy)
                FilledButton.icon(
                  onPressed: openPortal,
                  icon: const Icon(Icons.window),
                  label: Text(
                    browser == null
                        ? 'Open LCCT app window'
                        : 'Return portal window to home',
                  ),
                ),
              if (problem != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SelectableText(
                    problem!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                'Requires internet. Accounts and messages are managed by '
                'the existing department websites. On shared computers, sign out '
                'of every department before leaving.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
