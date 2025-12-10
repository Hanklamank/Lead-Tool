// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salesai_pro/main.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('Dashboard smoke test (Desktop)', (WidgetTester tester) async {
    // Set viewport to desktop size
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build our app and trigger a frame.
    // ProviderScope is needed because the app uses Riverpod
    await tester.pumpWidget(
      const ProviderScope(
        child: SalesAIProApp(),
      ),
    );
    await tester.pumpAndSettle(); // Wait for data to load

    // Verify that the dashboard title is present (Desktop Sidebar)
    expect(find.text('SalesAI Pro'), findsOneWidget);

    // Verify that we are on the dashboard (SalesAI Pro title in AppBar or sidebar)
    // Note: The mobile layout has 'SalesAI Pro' in AppBar.
    // The desktop layout has 'SalesAI Pro' in sidebar.
  });
}
