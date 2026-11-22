/// Build-time switches, set with `--dart-define`.
///
/// * `USE_MOCK=true` runs every feature on its MockDataSource (no backend needed).
/// * `API_BASE_URL` points the remote data sources at a backend. The default is the
///   local backend as seen from the Android emulator.
/// * `PUSH_ENABLED=true` turns on Firebase Cloud Messaging. It needs
///   `android/app/google-services.json` (see README).
/// * `MOCK_SCENARIO` = `normal` | `empty` | `error` | `slow`, to exercise UI states.
abstract final class AppEnv {
  static const bool useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);

  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8080/api/v1');

  static const bool pushEnabled = bool.fromEnvironment('PUSH_ENABLED');

  static const String mockScenario = String.fromEnvironment('MOCK_SCENARIO', defaultValue: 'normal');

  static const String cairoTimeZone = 'Africa/Cairo';
}
