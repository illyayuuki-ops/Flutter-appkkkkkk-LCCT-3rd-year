// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lcct_guidance/main.dart';
import 'package:lcct_guidance/desktop_portal.dart';

void main() {
  test('Desktop navigation permits HTTPS and blocks unsafe schemes', () {
    expect(allowDesktopNavigation(portalUrl), isTrue);
    expect(allowDesktopNavigation('https://department.example/login'), isTrue);
    expect(allowDesktopNavigation('about:blank'), isTrue);
    for (final url in [
      'http://example.com',
      'javascript:alert(1)',
      'file:///etc/passwd',
      'data:text/html,hello',
      'https:',
      'mailto:office@example.com',
      'tel:123',
    ]) {
      expect(allowDesktopNavigation(url), isFalse, reason: url);
    }
  });
  test('Uses the original landing page', () {
    expect(portalUrl, 'https://lcct-helpdesk.infinityfree.io/?i=1');
  });
  testWidgets('Web launcher offers the real portal and no demo roles', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BrowserPortal()));
    expect(find.text('Open LCCT portal'), findsOneWidget);
    expect(find.text(portalUrl), findsOneWidget);
    expect(find.text('Enter Guidance demo'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
