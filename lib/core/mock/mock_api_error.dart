import 'package:dio/dio.dart';

/// Builds the same [DioException]s the real API produces, so repositories map mock and
/// remote failures through one path.
abstract final class MockApiError {
  static DioException server(
    int status,
    String code,
    String message, {
    Map<String, dynamic>? details,
    List<Map<String, String>>? fields,
  }) {
    final options = RequestOptions(path: '/mock');
    return DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response<Map<String, dynamic>>(
        requestOptions: options,
        statusCode: status,
        data: {
          'code': code,
          'message': message,
          'details': ?details,
          'fields': ?fields,
          'request_id': 'mock-${DateTime.now().millisecondsSinceEpoch}',
        },
      ),
    );
  }

  static DioException network() => DioException(
    requestOptions: RequestOptions(path: '/mock'),
    type: DioExceptionType.connectionError,
  );
}
