import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric WriteInSearchbar() {
  return when2<String, String, FlutterWorld>(
    'I enter {string} in the {string} input field',
        (value, key, context) async {
      final finder = find.byValueKey(key);
      Duration timeout = Duration(seconds: 2);
      await FlutterDriverUtils.enterText(context.world.driver, finder, value, timeout: timeout);
    },
  );
}
