import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healio/main.dart'; // Corrected import

void main() {
  testWidgets('Helio app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HelioApp());

    // Verify that the app title is present.
    expect(find.text('Helio Health'), findsOneWidget);

    // Verify that we have three navigation items.
    expect(find.byType(BottomNavigationBarItem), findsNWidgets(3));

    // Verify that the Health Info screen is initially displayed.
    expect(find.text('Health Information'), findsOneWidget);
    expect(find.text('View Health Tips'), findsOneWidget);

    // Tap the 'Nearest Facilities' icon.
    await tester.tap(find.byIcon(Icons.local_hospital));
    await tester.pumpAndSettle();

    // Verify that the Nearest Facilities screen is now displayed.
    expect(find.text('Nearest Health Facilities'), findsOneWidget);
    expect(find.text('Find Nearby Facilities'), findsOneWidget);

    // Tap the 'Emergency Services' icon.
    await tester.tap(find.byIcon(Icons.emergency));
    await tester.pumpAndSettle();

    // Verify that the Emergency Services screen is now displayed.
    expect(find.text('Emergency Services'), findsOneWidget);
    expect(find.text('Call Emergency Services'), findsOneWidget);
  });
}
