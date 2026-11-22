import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tatay_transport/core/network/api_failure.dart';
import 'package:tatay_transport/core/network/api_failure_mapper.dart';
import 'package:tatay_transport/core/network/auth_interceptor.dart';
import 'package:tatay_transport/core/session/session_events.dart';
import 'package:tatay_transport/core/storage/token_storage.dart';

import '../../helpers/fake_adapter.dart';

const _unauthenticated = {'code': 'UNAUTHENTICATED', 'message': 'x'};

void main() {
  late TokenStorage storage;
  late SessionEvents events;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({'access_token': 'old', 'refresh_token': 'r1'});
    storage = TokenStorage(const FlutterSecureStorage());
    await storage.load();
    events = SessionEvents();
  });

  Dio buildDio(FakeAdapter api, FakeAdapter refresh) {
    final options = BaseOptions(baseUrl: 'http://test/api/v1');
    final dio = Dio(options)..httpClientAdapter = api;
    dio.interceptors.add(
      AuthInterceptor(
        storage: storage,
        refreshDio: Dio(options)..httpClientAdapter = refresh,
        retryDio: Dio(options)..httpClientAdapter = api,
        events: events,
      ),
    );
    return dio;
  }

  test('three parallel 401s trigger exactly one refresh, then all succeed', () async {
    var refreshCalls = 0;
    final api = FakeAdapter((o) async {
      final token = o.headers['Authorization'];
      return token == 'Bearer new' ? (200, {'ok': true}) : (401, _unauthenticated);
    });
    final refresh = FakeAdapter((o) async {
      refreshCalls++;
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return (200, {'access_token': 'new', 'refresh_token': 'r2'});
    });
    final dio = buildDio(api, refresh);

    final results = await Future.wait([dio.get<dynamic>('/a'), dio.get<dynamic>('/b'), dio.get<dynamic>('/c')]);

    expect(results.map((r) => r.statusCode), everyElement(200));
    expect(refreshCalls, 1, reason: 'parallel refreshes would reuse a revoked token and log the user out');
    expect(storage.refreshToken, 'r2');
  });

  test('a rejected refresh clears tokens and signals session expiry', () async {
    final api = FakeAdapter((o) async => (401, _unauthenticated));
    final refresh = FakeAdapter((o) async => (401, _unauthenticated));
    final dio = buildDio(api, refresh);
    var expired = false;
    events.onExpired.listen((_) => expired = true);

    final error = await dio.get<dynamic>('/me').then<Object?>((_) => null, onError: (Object e) => e);

    expect(ApiFailureMapper.map(error!), isA<SessionExpiredFailure>());
    await Future<void>.delayed(Duration.zero);
    expect(expired, isTrue);
    expect(storage.hasSession, isFalse);
  });

  test('being offline during refresh keeps the session and reports a network error', () async {
    final api = FakeAdapter((o) async => (401, _unauthenticated));
    final refresh = FakeAdapter((o) async => throw DioException.connectionError(requestOptions: o, reason: 'offline'));
    final dio = buildDio(api, refresh);

    final error = await dio.get<dynamic>('/me').then<Object?>((_) => null, onError: (Object e) => e);

    expect(ApiFailureMapper.map(error!), isA<NetworkFailure>());
    expect(storage.refreshToken, 'r1');
  });

  test('auth endpoints carry no token and are never refreshed', () async {
    final api = FakeAdapter((o) async => (401, {'code': 'INVALID_CREDENTIALS', 'message': 'x'}));
    final refresh = FakeAdapter((o) async => fail('refresh must not run'));
    final dio = buildDio(api, refresh);

    await dio.post<dynamic>('/auth/login').catchError((_) => Response(requestOptions: RequestOptions()));

    expect(api.requests.single.headers['Authorization'], isNull);
  });
}
