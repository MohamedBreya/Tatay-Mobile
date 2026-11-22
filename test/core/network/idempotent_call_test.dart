import 'package:flutter_test/flutter_test.dart';
import 'package:tatay_transport/core/mock/mock_api_error.dart';
import 'package:tatay_transport/core/network/api_error_code.dart';
import 'package:tatay_transport/core/network/api_failure.dart';
import 'package:tatay_transport/core/network/idempotent_call.dart';
import 'package:tatay_transport/core/network/result.dart';

void main() {
  test('retries a dropped connection with the SAME key, then succeeds', () async {
    final keys = <String>[];
    final result = await idempotentCall((key) async {
      keys.add(key);
      if (keys.length < 3) throw MockApiError.network();
      return 'booked';
    }, retryDelay: Duration.zero);

    expect((result as Success<String>).data, 'booked');
    expect(keys, hasLength(3));
    expect(keys.toSet(), hasLength(1), reason: 'one button press = one Idempotency-Key');
  });

  test('REQUEST_IN_PROGRESS is retried with the same key', () async {
    final keys = <String>[];
    final result = await idempotentCall((key) async {
      keys.add(key);
      if (keys.length == 1) throw MockApiError.server(409, 'REQUEST_IN_PROGRESS', '');
      return 1;
    }, retryDelay: Duration.zero);
    expect(result, isA<Success<int>>());
    expect(keys.toSet(), hasLength(1));
  });

  test('business errors are not retried', () async {
    var calls = 0;
    final result = await idempotentCall<int>((key) async {
      calls++;
      throw MockApiError.server(409, 'NOT_ENOUGH_SEATS', '');
    }, retryDelay: Duration.zero);
    expect(calls, 1);
    expect(((result as Failure).failure as ServerFailure).code, ApiErrorCode.notEnoughSeats);
  });

  test('each call (button press) gets a new key', () async {
    final keys = <String>{};
    for (var i = 0; i < 3; i++) {
      await idempotentCall((key) async => keys.add(key));
    }
    expect(keys, hasLength(3));
  });
}
