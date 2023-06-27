import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'steps/seePage.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..reporters = [ProgressReporter(), TestRunSummaryReporter(), JsonReporter(path: './test_report.json')]
    ..stepDefinitions = [GivenPage(), ThenPage(), TapProfileButton()]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..defaultTimeout = const Duration(seconds: 50)
    ..targetAppPath = "test_driver/app.dart";
  return GherkinRunner().execute(config);
}