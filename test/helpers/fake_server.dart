import 'dart:convert';
import 'dart:io' show SocketException;
import 'dart:typed_data';

import 'package:caspian_owner/core/network/api_client.dart';
import 'package:dio/dio.dart';

typedef FakeHandler = ResponseBody Function(RequestOptions request);

/// A pretend Caspian Server for tests: routes by «METHOD /path» (query
/// ignored), records every request, no network. An unknown route behaves
/// like a server that is off (connection error).
class FakeServer implements HttpClientAdapter {
  final routes = <String, FakeHandler>{};
  final requests = <RequestOptions>[];

  static const baseUrl = 'http://192.168.10.58:8000';

  void on(String method, String path, FakeHandler handler) =>
      routes['$method $path'] = handler;

  /// Requests to [path], oldest first.
  List<RequestOptions> calls(String method, String path) => [
    for (final r in requests)
      if (r.method == method && r.uri.path == path) r,
  ];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final handler = routes['${options.method} ${options.uri.path}'];
    if (handler == null) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'no fake route',
      );
    }
    return handler(options);
  }

  @override
  void close({bool force = false}) {}

  /// A JSON answer (UTF-8, Persian text survives).
  static FakeHandler json(Object? body, {int status = 200}) =>
      (_) => ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );

  /// An error answer like FastAPI's.
  static FakeHandler error(int status) =>
      json({'detail': 'error $status'}, status: status);

  /// An account error as owner-auth-api.md describes it: the stable [code]
  /// in `X-Error-Code`, the Persian [detail], and `Retry-After` on 429.
  static FakeHandler fail(
    int status,
    String code, {
    String detail = 'پیام سرور',
    int? retryAfter,
  }) =>
      (_) => ResponseBody.fromString(
        jsonEncode({'detail': detail}),
        status,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
          'x-error-code': [code],
          if (retryAfter != null) 'retry-after': ['$retryAfter'],
        },
      );

  /// The phone has no internet: the server's name can't be looked up.
  static FakeHandler noInternet() =>
      (options) => throw DioException.connectionError(
        requestOptions: options,
        reason: 'lookup',
        error: const SocketException('Failed host lookup: api.example.ir'),
      );

  /// Answers [first] once, then [then] (e.g. a login before and after a
  /// password change).
  static FakeHandler sequence(FakeHandler first, FakeHandler then) {
    var calls = 0;
    return (options) => calls++ == 0 ? first(options) : then(options);
  }

  /// FastAPI's 422 for a bad body: `detail` is a list naming the field.
  static FakeHandler invalidField(String field, String message) => json({
    'detail': [
      {
        'loc': ['body', field],
        'msg': 'Value error, $message',
        'type': 'value_error',
      },
    ],
  }, status: 422);

  ApiClient client({String? token, void Function()? onUnauthorized}) =>
      ApiClient(
        baseUrl: baseUrl,
        token: () => token,
        onUnauthorized: onUnauthorized,
        dio: Dio()..httpClientAdapter = this,
      );
}

/// A `GoodsRequestOut` as Caspian Server sends it.
Map<String, Object?> serverRequest({
  int id = 5,
  String status = 'pending',
  int? decidedById,
  String? decidedByName,
  String? rejectionReason,
  String createdAt = '2026-10-21T08:00:00Z',
  String? updatedAt,
}) => {
  'id': id,
  'requester_name': 'علی رضایی',
  'consumption_location': 'سرویس بهداشتی طبقه ۲',
  'note': 'فوری',
  'status': status,
  'rejection_reason': rejectionReason,
  'created_by_id': 2,
  'decided_by_id': decidedById,
  'decided_by_name': decidedByName,
  'decided_at': decidedById == null ? null : '2026-10-21T09:00:00Z',
  'created_at': createdAt,
  'updated_at': updatedAt ?? createdAt,
  'items': [
    {'id': 11, 'name': 'کیسه زباله', 'quantity': 20.0, 'unit': 'بسته'},
    {'id': 12, 'name': 'مایع دستشویی', 'quantity': 2.5, 'unit': 'لیتر'},
  ],
};

/// A `MessageOut` as Caspian Server sends it.
Map<String, Object?> serverMessage({
  int id = 1,
  int requestId = 5,
  int senderId = 2,
  String senderName = 'انبار پاساژ',
  String senderRole = 'warehouse',
  String text = 'سلام',
  String createdAt = '2026-10-21T08:05:00Z',
}) => {
  'id': id,
  'request_id': requestId,
  'sender_id': senderId,
  'sender_name': senderName,
  'sender_role': senderRole,
  'text': text,
  'created_at': createdAt,
};

/// A real-looking JWT whose payload says `exp` = [expiry] (not signed).
String fakeJwt(DateTime expiry) {
  String part(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${part({'alg': 'HS256'})}.'
      '${part({'sub': '3', 'exp': expiry.millisecondsSinceEpoch ~/ 1000})}.sig';
}
