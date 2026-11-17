// ignore_for_file: deprecated_member_use
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'desktop_portal_stub.dart' if (dart.library.io) 'desktop_portal.dart';

const portalUrl = 'https://lcct-helpdesk.infinityfree.io/?i=1';
const navy = Color(0xff1b3355);
void main() => runApp(const PortalApp());

class PortalApp extends StatelessWidget {
  const PortalApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'LCCT Help Desk',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: navy),
      scaffoldBackgroundColor: const Color(0xfff5f9fd),
    ),
    home:
        !kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS)
        ? const MobilePortal()
        : kIsWeb
        ? const BrowserPortal()
        : const DesktopPortal(),
  );
}

Future<bool> openBrowser(String value) async {
  final uri = Uri.tryParse(value);
  if (uri == null || !['https', 'http', 'mailto', 'tel'].contains(uri.scheme)) {
    return false;
  }
  try {
    return await launchUrl(
      uri,
      mode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
      webOnlyWindowName: '_self',
    );
  } catch (_) {
    return false;
  }
}

class BrowserPortal extends StatefulWidget {
  const BrowserPortal({super.key});
  @override
  State<BrowserPortal> createState() => _BrowserPortalState();
}

class _BrowserPortalState extends State<BrowserPortal> {
  String? error;
  Future<void> open() async {
    final ok = await openBrowser(portalUrl);
    if (mounted) {
      setState(
        () => error = ok
            ? null
            : 'Could not open the browser. Use the address below.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('LCCT Help Desk')),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/lcct-seal.png', height: 96),
              const SizedBox(height: 24),
              const Text(
                'Your LCCT Help Desk',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Open the existing portal to choose a department. '
                'Accounts, sign-in, and services are managed by each website.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: open,
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Open LCCT portal'),
              ),
              const SizedBox(height: 20),
              const SelectableText(portalUrl, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(
                kIsWeb
                    ? 'Continues to the portal in this browser tab. Browser Back returns here.'
                    : 'The portal opens in your default browser. Embedded desktop browsing is not included yet.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueGrey),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class MobilePortal extends StatefulWidget {
  const MobilePortal({super.key});
  @override
  State<MobilePortal> createState() => _MobilePortalState();
}

class _MobilePortalState extends State<MobilePortal> {
  late final WebViewController controller;
  int progress = 0;
  bool canBack = false;
  String? error;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (mounted) setState(() => progress = p);
          },
          onPageStarted: (_) {
            if (mounted) setState(() => error = null);
          },
          onPageFinished: (_) async {
            final back = await controller.canGoBack();
            if (mounted) setState(() => canBack = back);
          },
          onWebResourceError: (e) {
            if (e.isForMainFrame == true && mounted) {
              setState(
                () => error = 'The page could not load. Check your connection or try the browser.',
              );
            }
          },
          onNavigationRequest: (r) async {
            final uri = Uri.tryParse(r.url);
            if (uri == null) return NavigationDecision.prevent;
            // Cross-domain departments remain navigable. Do not collect passwords,
            // inject login scripts, ignore TLS errors, or rewrite department URLs.
            if (uri.scheme == 'https' || r.url == 'about:blank') {
              return NavigationDecision.navigate;
            }
            // Never load insecure HTTP login pages inside the app.
            if (['http', 'mailto', 'tel'].contains(uri.scheme)) {
              await openBrowser(r.url);
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(portalUrl));
  }

  Future<void> back() async {
    if (await controller.canGoBack()) await controller.goBack();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !canBack,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) back();
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('LCCT Help Desk'),
        leading: canBack
            ? IconButton(
                tooltip: 'Back',
                onPressed: back,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        actions: [
          IconButton(
            tooltip: 'Home',
            onPressed: () => controller.loadRequest(Uri.parse(portalUrl)),
            icon: const Icon(Icons.home_outlined),
          ),
          IconButton(
            tooltip: 'Reload',
            onPressed: () => controller.reload(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Open current page in browser',
            onPressed: () async {
              final current = await controller.currentUrl();
              await openBrowser(current ?? portalUrl);
            },
            icon: const Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (progress < 100) LinearProgressIndicator(value: progress / 100),
            if (error != null)
              MaterialBanner(
                content: Text(error!),
                actions: [
                  TextButton(
                    onPressed: () => controller.reload(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            Expanded(child: WebViewWidget(controller: controller)),
          ],
        ),
      ),
    ),
  );
}
