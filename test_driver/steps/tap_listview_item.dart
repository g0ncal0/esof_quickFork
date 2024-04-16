import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric TapListViewItemStep() {
  return given1<String, FlutterWorld>(
      'I tap the {string} item',
          (key, context) async {
        final locator = find.byValueKey(key);
        await FlutterDriverUtils.tap(context.world.driver, locator);
      }
  );
}