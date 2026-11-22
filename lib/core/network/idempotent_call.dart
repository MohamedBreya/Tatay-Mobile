import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import 'api_error_code.dart';
import 'api_failure_mapper.dart';
import 'api_failure.dart';
import 'result.dart';

/// Runs one user action (one button press) against an **Idempotent** endpoint.
///
/// A single `Idempotency-Key` is generated for the press and reused on every retry, so a
/// flaky village connection can never create the same booking twice. Retries happen on
/// network failures and on `REQUEST_IN_PROGRESS`, as the API guide asks.
Future<Result<T>> idempotentCall<T>(
  Future<T> Function(String idempotencyKey) call, {
  int maxAttempts = 3,
  Duration retryDelay = const Duration(seconds: 1),
}) async {
  final key = const Uuid().v4();
  ApiFailure failure = const UnexpectedFailure();
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return Success(await call(key));
    } catch (error) {
      failure = ApiFailureMapper.map(error);
      if (!_isRetryable(error, failure) || attempt == maxAttempts) break;
      await Future<void>.delayed(retryDelay * attempt);
    }
  }
  return Failure(failure);
}

bool _isRetryable(Object error, ApiFailure failure) => switch (failure) {
  NetworkFailure() => error is DioException,
  ServerFailure(:final code) => code == ApiErrorCode.requestInProgress,
  SessionExpiredFailure() || UnexpectedFailure() => false,
};
