import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:esof/pages/sigarraLogin/sigarraLogin_widget.dart'; // Adjust the import path

void main() {
  testWidgets('SigarraLoginWidget UI test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SigarraLoginWidget())); // Build widget

    // Test UI elements existence and initial state
    expect(find.text('Sign In'), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Test the behavior of UI elements
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    // Test if the navigation occurred after successful login
    expect(find.text('QuickFork'), findsOneWidget);
  });
}
