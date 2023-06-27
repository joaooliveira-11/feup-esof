import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenPage() {
  return given1<String, FlutterWorld>(
    RegExp(r"I am on the {string} page"),
        (page, context) async {
      final locator = find.byValueKey(page);
      await FlutterDriverUtils.isPresent(context.world.driver, locator);
    },
  );
}

StepDefinitionGeneric TapProfileButton() {
  return given1<String, FlutterWorld>(
    RegExp(r"I tap the {string} navbaricon"),
        (key, context) async {
      final locator = find.byValueKey(key);
      await FlutterDriverUtils.tap(context.world.driver, locator);
    },
  );
}

StepDefinitionGeneric ThenPage() {
  return then1<String, FlutterWorld>(
    RegExp(r"I should be on the {string} page"),
        (page, context) async {
      final locator = find.byValueKey(page);
      await FlutterDriverUtils.isPresent(context.world.driver, locator);
    },
  );
}