import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_env.dart';
import '../session/session_events.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

abstract final class DioFactory {
  static Dio create({required TokenStorage storage, required SessionEvents events}) {
    final options = BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 30),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );
    final dio = Dio(options);
    dio.interceptors.add(
      // The retry Dio must not carry this interceptor: a queued interceptor awaiting a
      // request that goes back through its own queue would deadlock.
      AuthInterceptor(storage: storage, refreshDio: Dio(options), retryDio: Dio(options), events: events),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false, logPrint: (line) => debugPrint('$line')),
      );
    }
    return dio;
  }
}
