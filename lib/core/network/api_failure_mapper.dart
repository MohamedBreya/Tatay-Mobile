import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_error_code.dart';
import 'api_failure.dart';
import 'session_expired_exception.dart';

/// Turns anything thrown by a data source into an [ApiFailure].
abstract final class ApiFailureMapper {
  static ApiFailure map(Object error) {
    if (error is SessionExpiredException) return const SessionExpiredFailure();
    if (error is DioException) return _fromDio(error);
    debugPrint('Unexpected data error: $error');
    return const UnexpectedFailure();
  }

  static ApiFailure _fromDio(DioException e) {
    if (e.error is SessionExpiredException) {
      return const SessionExpiredFailure();
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.unknown:
        if (e.response == null) return const NetworkFailure();
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        break;
    }
    final response = e.response;
    final data = response?.data;
    if (data is Map && data['code'] is String) {
      final fields = (data['fields'] as List? ?? const [])
          .whereType<Map>()
          .map((f) => FieldError('${f['field']}', '${f['message']}'))
          .toList();
      return ServerFailure(
        code: ApiErrorCode.fromWire(data['code'] as String),
        message: '${data['message'] ?? ''}',
        statusCode: response?.statusCode,
        fields: fields,
        details: Map<String, dynamic>.from(data['details'] as Map? ?? const {}),
        requestId: data['request_id'] as String?,
      );
    }
    return UnexpectedFailure(response?.headers.value('x-request-id'));
  }
}
