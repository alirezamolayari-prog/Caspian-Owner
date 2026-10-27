import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:dio/dio.dart';

/// Talks to Caspian Server. Adds the login token, decodes JSON, and turns
/// every failure into an [ApiException], so repositories and screens never
/// see dio types:
///
/// | what happened                        | thrown                  |
/// |--------------------------------------|-------------------------|
/// | no connection / timeout              | [NetworkException]      |
/// | 401 on a signed-in request           | [UnauthorizedException] |
/// | `X-Error-Code` before login, any 429 | [ServerException]       |
/// | 401                                  | [UnauthorizedException] |
/// | 403                                  | [ForbiddenException]    |
/// | 404                                  | [NotFoundException]     |
/// | 409                                  | [ConflictException]     |
/// | 422                                  | [ValidationException]   |
/// | anything else                        | [ServerException]       |
///
/// The account endpoints (owner-auth-api.md) name every error in the
/// `X-Error-Code` header with a Persian `detail`; those become a
/// [ServerException] carrying both, so screens can react to the code and
/// show the server's own words.
class ApiClient {
  /// [token] returns the current access token (null when signed out).
  /// [onUnauthorized] runs when a request that carried a token gets `401`:
  /// the session is over, so the app signs out and shows the login screen.
  new({required this.baseUrl, this.token, this.onUnauthorized, Dio? dio})
    : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      // We decode JSON ourselves (always UTF-8, whatever the content type).
      responseType: ResponseType.plain,
    );
  }

  final String baseUrl;
  final String? Function()? token;
  final void Function()? onUnauthorized;
  final Dio _dio;

  /// GET [path]; [bearer] replaces the stored token (used right after login).
  Future<Object?> get(
    String path, {
    Map<String, Object?>? query,
    String? bearer,
  }) => _send('GET', path, query: query, bearer: bearer);

  /// POST [json] as a JSON body, or [form] as form fields (login).
  /// [bearer] replaces the stored token (changing a first password).
  Future<Object?> post(
    String path, {
    Object? json,
    Map<String, String>? form,
    String? bearer,
  }) => _send(
    'POST',
    path,
    body: form ?? json,
    isForm: form != null,
    bearer: bearer,
  );

  Future<Object?> _send(
    String method,
    String path, {
    Map<String, Object?>? query,
    Object? body,
    bool isForm = false,
    String? bearer,
  }) async {
    final accessToken = bearer ?? token?.call();
    try {
      final response = await _dio.request<String>(
        path,
        data: body,
        queryParameters: query,
        options: Options(
          method: method,
          contentType: isForm
              ? Headers.formUrlEncodedContentType
              : Headers.jsonContentType,
          headers: {'Authorization': ?_bearer(accessToken)},
        ),
      );
      final text = response.data;
      if (text == null || text.isEmpty) return null;
      return jsonDecode(text);
    } on DioException catch (e) {
      throw _toApiException(e, hadToken: accessToken != null);
    } on FormatException {
      throw const ServerException(code: 'bad_response');
    }
  }

  /// The JSON object the server should have sent; a broken answer becomes
  /// a [ServerException] (shown as «خطای سرور») instead of a crash.
  static Map<String, Object?> asMap(Object? json) =>
      json is Map<String, Object?>
      ? json
      : throw const ServerException(code: 'bad_response');

  /// Like [asMap], for a JSON list.
  static List<Object?> asList(Object? json) => json is List<Object?>
      ? json
      : throw const ServerException(code: 'bad_response');

  static String? _bearer(String? token) =>
      token == null ? null : 'Bearer $token';

  ApiException _toApiException(DioException e, {required bool hadToken}) {
    final response = e.response;
    if (e.type != DioExceptionType.badResponse || response == null) {
      // Timeouts, refused connections, wrong address, Wi-Fi off, …
      final detail = '${e.type.name}: ${e.message ?? ''}';
      return _looksOffline(e)
          ? NetworkException.noInternet(detail)
          : NetworkException(detail);
    }
    final status = response.statusCode ?? 0;
    if (status == 401 && hadToken) {
      onUnauthorized?.call();
      return const UnauthorizedException();
    }
    final code = response.headers.value('x-error-code');
    final body = _decode(response.data);
    final detail = body is Map<String, Object?> ? body['detail'] : null;
    if ((code != null && (!hadToken || code == passwordChangeRequired)) ||
        status == 429) {
      return ServerException(
        code: code ?? 'http_$status',
        messageFa: detail is String ? detail : null,
        statusCode: status,
        retryAfter: _retryAfter(response.headers.value('retry-after')),
      );
    }
    switch (status) {
      case 401:
        return const UnauthorizedException();
      case 403:
        return const ForbiddenException();
      case 404:
        return const NotFoundException();
      case 409:
        return const ConflictException();
      case 422:
        return ValidationException(fieldErrors: fieldErrors(detail));
      default:
        return ServerException(code: 'http_$status', statusCode: status);
    }
  }

  /// `403` on every call until a first password is changed.
  static const passwordChangeRequired = 'password_change_required';

  /// FastAPI's 422 list → field name → message, e.g.
  /// `{"loc": ["body", "first_name"], "msg": "Value error, …"}`.
  static Map<String, String> fieldErrors(Object? detail) {
    if (detail is! List<Object?>) return const {};
    final errors = <String, String>{};
    for (final item in detail) {
      if (item is! Map<String, Object?>) continue;
      final loc = item['loc'];
      final msg = item['msg'];
      if (loc is! List<Object?> || loc.length < 2 || msg is! String) continue;
      errors.putIfAbsent(
        '${loc[1]}',
        () => msg.replaceFirst(RegExp(r'^Value error,\s*'), ''),
      );
    }
    return errors;
  }

  static Object? _decode(Object? data) {
    if (data is! String || data.isEmpty) return data;
    try {
      return jsonDecode(data);
    } on FormatException {
      return null;
    }
  }

  static Duration? _retryAfter(String? value) {
    final seconds = int.tryParse(value?.trim() ?? '');
    return seconds == null || seconds < 0 ? null : Duration(seconds: seconds);
  }

  /// No network at all: the server's name can't be looked up, or Android
  /// reports the network unreachable. Anything else (timeouts, refused,
  /// TLS) means the server itself didn't answer.
  static bool _looksOffline(DioException e) {
    final error = e.error;
    if (e.type != DioExceptionType.connectionError ||
        error is! SocketException) {
      return false;
    }
    final message = '${error.message} ${error.osError?.message ?? ''}'
        .toLowerCase();
    return message.contains('host lookup') ||
        message.contains('no address associated') ||
        message.contains('network is unreachable');
  }
}
