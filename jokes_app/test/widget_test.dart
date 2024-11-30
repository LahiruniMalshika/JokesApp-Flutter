import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jokes_app/main.dart';

void main() {
  testWidgets('Jokes App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyJokesApp());

    // Verify that the Get Jokes button exists
    expect(find.text('Get Jokes'), findsOneWidget);

    // Tap the 'Get Jokes' button
    await tester.tap(find.text('Get Jokes'));
    await tester.pump();

    // Verify that something happened (like loading indicator)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}