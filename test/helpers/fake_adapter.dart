import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Scripted HTTP adapter: every request goes to [handler], which returns (status, json body).
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final Future<(int, Object?)> Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final (status, body) = await handler(options);
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
