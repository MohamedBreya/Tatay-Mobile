/// Build-time switches, set with `--dart-define`.
///
/// * `API_BASE_URL` points the remote data sources at a backend. When unset or empty,
///   every feature uses its MockDataSource.
/// * `PUSH_ENABLED=true` turns on Firebase Cloud Messaging. It needs
///   `android/app/google-services.json` (see README).
/// * `MOCK_SCENARIO` = `normal` | `empty` | `error` | `slow`, to exercise UI states.
abstract final class AppEnv {
  static final bool useMock = apiBaseUrl.trim().isEmpty;

  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static const bool pushEnabled = bool.fromEnvironment('PUSH_ENABLED');

  static const String mockScenario = String.fromEnvironment('MOCK_SCENARIO', defaultValue: 'normal');

  static const String cairoTimeZone = 'Africa/Cairo';
}
