import 'package:flutter/material.dart';
import 'package:flutter_feature_showcase/app.dart';
import 'package:flutter_feature_showcase/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(configureDependencies);

  testWidgets('shows all three feature destinations', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());
    await tester.pumpAndSettle();

    expect(find.text('Authentication'), findsOneWidget);
    expect(find.text('Auth'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
  });

  testWidgets('signs in with the demo account', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Authenticated'), findsOneWidget);
    expect(find.text('demo@example.com'), findsOneWidget);
  });
}
