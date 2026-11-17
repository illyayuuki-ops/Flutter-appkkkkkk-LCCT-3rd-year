// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lcct_guidance/main.dart';

void main() {
  test('Uses the original landing page', () {
    expect(portalUrl, 'https://lcct-helpdesk.infinityfree.io/?i=1');
  });
  testWidgets('Desktop fallback offers real portal and no demo roles', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BrowserPortal()));
    expect(find.text('Open LCCT portal'), findsOneWidget);
    expect(find.text(portalUrl), findsOneWidget);
    expect(find.text('Enter Guidance demo'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
