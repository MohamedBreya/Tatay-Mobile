import 'package:dio/dio.dart';

import '../session/session_events.dart';
import '../storage/token_storage.dart';
import 'session_expired_exception.dart';

/// Adds the bearer token and handles `401 UNAUTHENTICATED`.
///
/// It is a [QueuedInterceptor], so errors are processed one at a time. When three requests
/// fail together, the first one refreshes and the other two see that the token already
/// changed and just retry. Refreshing in parallel would reuse a revoked refresh token,
/// which the backend treats as theft and logs the user out everywhere.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this.storage, required this.refreshDio, required this.retryDio, required this.events});

  final TokenStorage storage;

  /// A bare Dio (no interceptors) used only for `/auth/refresh`.
  final Dio refreshDio;

  /// A bare Dio used to replay the failed request once with the new token.
  final Dio retryDio;
  final SessionEvents events;

  static const _retriedFlag = 'auth_retried';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = storage.accessToken;
    if (token != null && !_isPublicAuthPath(options.path)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final isUnauthenticated = err.response?.statusCode == 401 && _isUnauthenticatedCode(err.response?.data);
    if (!isUnauthenticated || _isPublicAuthPath(request.path) || request.extra[_retriedFlag] == true) {
      return handler.next(err);
    }

    final usedToken = (request.headers['Authorization'] as String?)?.replaceFirst('Bearer ', '');
    final tokenAlreadyRotated = usedToken != null && usedToken != storage.accessToken;
    if (!tokenAlreadyRotated) {
      switch (await _refresh()) {
        case _RefreshOutcome.refreshed:
          break;
        case _RefreshOutcome.offline:
          // Keep the session: the call fails as a network error and can be retried.
          return handler.next(DioException(requestOptions: request, type: DioExceptionType.connectionError));
        case _RefreshOutcome.expired:
          return handler.next(DioException(requestOptions: request, error: const SessionExpiredException()));
      }
    }

    try {
      request.extra[_retriedFlag] = true;
      request.headers['Authorization'] = 'Bearer ${storage.accessToken}';
      // A multipart body is consumed by the first send; replay a fresh copy.
      final body = request.data;
      if (body is FormData) request.data = body.clone();
      handler.resolve(await retryDio.fetch<dynamic>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<_RefreshOutcome> _refresh() async {
    final refreshToken = storage.refreshToken;
    if (refreshToken == null) return _expire();
    try {
      final response = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final body = response.data!;
      await storage.saveTokens(access: body['access_token'] as String, refresh: body['refresh_token'] as String);
      return _RefreshOutcome.refreshed;
    } on DioException catch (e) {
      // Offline during refresh is not a logout.
      if (e.response == null) return _RefreshOutcome.offline;
      return _expire();
    }
  }

  Future<_RefreshOutcome> _expire() async {
    await storage.clear();
    events.notifyExpired();
    return _RefreshOutcome.expired;
  }

  bool _isUnauthenticatedCode(Object? data) =>
      data is! Map || data['code'] == null || data['code'] == 'UNAUTHENTICATED';

  /// `/auth/*` calls carry no token, except logout.
  bool _isPublicAuthPath(String path) => path.contains('/auth/') && !path.contains('/auth/logout');
}

enum _RefreshOutcome { refreshed, offline, expired }
