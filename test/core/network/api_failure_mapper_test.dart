import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tatay_transport/core/mock/mock_api_error.dart';
import 'package:tatay_transport/core/network/api_error_code.dart';
import 'package:tatay_transport/core/network/api_failure.dart';
import 'package:tatay_transport/core/network/api_failure_mapper.dart';
import 'package:tatay_transport/core/network/session_expired_exception.dart';

void main() {
  test('contract error body becomes a ServerFailure with code, fields and details', () {
    final error = MockApiError.server(
      409,
      'NOT_ENOUGH_SEATS',
      'مفيش كراسي كفاية',
      details: {'available_seats': 1, 'can_join_waitlist': true},
      fields: [
        {'field': 'seats', 'message': 'x'},
      ],
    );
    final failure = ApiFailureMapper.map(error) as ServerFailure;
    expect(failure.code, ApiErrorCode.notEnoughSeats);
    expect(failure.message, 'مفيش كراسي كفاية');
    expect(failure.detailInt('available_seats'), 1);
    expect(failure.detailBool('can_join_waitlist'), isTrue);
    expect(failure.fieldError('seats'), 'x');
  });

  test('unknown codes from a newer backend map to unknown, not a crash', () {
    final failure = ApiFailureMapper.map(MockApiError.server(409, 'SOMETHING_NEW', 'm')) as ServerFailure;
    expect(failure.code, ApiErrorCode.unknown);
  });

  test('no response means NetworkFailure', () {
    expect(ApiFailureMapper.map(MockApiError.network()), isA<NetworkFailure>());
    final timeout = DioException(requestOptions: RequestOptions(), type: DioExceptionType.receiveTimeout);
    expect(ApiFailureMapper.map(timeout), isA<NetworkFailure>());
  });

  test('session expiry is recognised directly and wrapped in a DioException', () {
    expect(ApiFailureMapper.map(const SessionExpiredException()), isA<SessionExpiredFailure>());
    final wrapped = DioException(requestOptions: RequestOptions(), error: const SessionExpiredException());
    expect(ApiFailureMapper.map(wrapped), isA<SessionExpiredFailure>());
  });

  test('5xx without a contract body is unexpected', () {
    final options = RequestOptions();
    final error = DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: options, statusCode: 502, data: '<html>'),
    );
    expect(ApiFailureMapper.map(error), isA<UnexpectedFailure>());
  });
}
