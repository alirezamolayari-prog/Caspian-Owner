import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Answers dio requests from a map of URL → handler, with no network.
class FakeHttpAdapter implements HttpClientAdapter {
  new(this.routes);

  final Map<String, ResponseBody Function(RequestOptions options)> routes;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final handler = routes[options.uri.toString()];
    if (handler == null) {
      throw DioException.connectionTimeout(
        timeout: const Duration(seconds: 1),
        requestOptions: options,
      );
    }
    return handler(options);
  }

  @override
  void close({bool force = false}) {}

  static ResponseBody json(Object value) => ResponseBody.fromString(
    jsonEncode(value),
    200,
    headers: {
      Headers.contentTypeHeader: ['application/octet-stream'],
    },
  );

  /// Serves [bytes]; honours `Range` unless [ignoreRange].
  static ResponseBody Function(RequestOptions) file(
    List<int> bytes, {
    bool ignoreRange = false,
  }) => (options) {
    final range = options.headers['range'] as String?;
    if (range != null && !ignoreRange) {
      final start = int.parse(RegExp(r'bytes=(\d+)-').firstMatch(range)![1]!);
      return ResponseBody.fromBytes(bytes.sublist(start), 206);
    }
    return ResponseBody.fromBytes(bytes, 200);
  };
}

Dio fakeDio(FakeHttpAdapter adapter) => Dio()..httpClientAdapter = adapter;
