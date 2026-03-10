import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:solo_leveling_fitness/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SoloLevelingFitnessApp());

    // Verify that the app loads without errors
    expect(find.byType(MaterialApp), findsOneWidget);

    // TODO: Add more specific tests as features are implemented
  });
}
