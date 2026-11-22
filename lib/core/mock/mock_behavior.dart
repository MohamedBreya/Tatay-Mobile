import 'dart:math';

import '../config/app_env.dart';
import 'mock_api_error.dart';

/// Shared knobs for every MockDataSource, driven by `--dart-define=MOCK_SCENARIO=`.
///
/// * `normal`: realistic data with a short network delay.
/// * `empty`: lists come back empty.
/// * `error`: reads fail with a network error, so error states can be checked.
/// * `slow`: 3 second delay, to look at loading states.
/// * `instant`: no delay (tests).
class MockBehavior {
  MockBehavior({this.scenario = AppEnv.mockScenario});

  final String scenario;
  final _random = Random();

  bool get isEmpty => scenario == 'empty';
  bool get isError => scenario == 'error';

  /// Await before every mock call.
  Future<void> latency() async {
    if (scenario == 'instant') return;
    final ms = scenario == 'slow' ? 3000 : 300 + _random.nextInt(400);
    await Future<void>.delayed(Duration(milliseconds: ms));
    if (isError) throw MockApiError.network();
  }
}
