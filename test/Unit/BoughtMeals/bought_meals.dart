import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:esof/pages/bought_meals/bought_meals_model.dart';
import 'package:esof/pages/bought_meals/bought_meals_widget.dart';

void main() {
  group('getMealName tests', () {
    test('returns right name for a given index', () {
      expect(getMealName(0), 'Monday Lunch');
      expect(getMealName(1), 'Monday Dinner');
      expect(getMealName(2), 'Tuesday Lunch');
      expect(getMealName(3), 'Tuesday Dinner');
      expect(getMealName(4), 'Wednesday Lunch');
      expect(getMealName(5), 'Wednesday Dinner');
      expect(getMealName(6), 'Thursday Lunch');
      expect(getMealName(7), 'Thursday Dinner');
      expect(getMealName(8), 'Friday Lunch');
      expect(getMealName(9), 'Friday Dinner');
      expect(getMealName(10), 'Saturday Lunch');
      expect(getMealName(11), 'Saturday Dinner');
    });
  });

  group('NextTicketButton tests', () {
    testWidgets('displays Next Meal Ticket button if user have next meal available', (WidgetTester tester) async {
      final model = BoughtMealsModel();
      model.alreadyScanned = List<bool>.filled(12, false);
      model.ticketsInfo = List<String>.filled(12, 'info');

      await tester.pumpWidget(MaterialApp(home: NextTicketButton(model: model)));

      expect(find.text('Next Meal Ticket'), findsOneWidget);
      expect(find.text('Monday Lunch'), findsNothing);
    });

    testWidgets("displays error message if user don't have next meal available", (WidgetTester tester) async {
      final model = BoughtMealsModel();
      model.alreadyScanned = List<bool>.filled(12, true);
      model.ticketsInfo = List<String>.filled(12, 'info');

      await tester.pumpWidget(MaterialApp(home: NextTicketButton(model: model)));

      expect(find.text("You don't have a ticket for the next meal"), findsOneWidget);
    });
  });

  group('TicketButton tests', () {
    testWidgets('displays bought unscanned meals', (WidgetTester tester) async {
      final model = BoughtMealsModel();
      model.alreadyScanned = List<bool>.filled(12, false);
      model.ticketsInfo = List<String>.filled(12, 'info');

      await tester.pumpWidget(
        MaterialApp(
          home: TicketButton(model: model, idx: 0,),
        ),
      );

      expect(find.text('Monday Lunch'), findsOneWidget);
    });
  });

}
