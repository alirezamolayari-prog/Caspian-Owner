import 'dart:convert';

import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:dio/dio.dart';

/// Talks to Caspian Server. Adds the login token, decodes JSON, and turns
/// every failure into an [ApiException], so repositories and screens never
/// see dio types:
///
/// | what happened              | thrown                   |
/// |----------------------------|--------------------------|
/// | no connection / timeout    | [NetworkException]       |
/// | 401                        | [UnauthorizedException]  |
/// | 403                        | [ForbiddenException]     |
/// | 404                        | [NotFoundException]      |
/// | 409                        | [ConflictException]      |
/// | 422                        | [ValidationException]    |
/// | anything else              | [ServerException]        |
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
  Future<Object?> post(
    String path, {
    Object? json,
    Map<String, String>? form,
  }) => _send('POST', path, body: form ?? json, isForm: form != null);

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
    if (e.type != DioExceptionType.badResponse) {
      // Timeouts, refused connections, wrong address, Wi-Fi off, …
      return NetworkException('${e.type.name}: ${e.message ?? ''}');
    }
    final status = e.response?.statusCode ?? 0;
    switch (status) {
      case 401:
        if (hadToken) onUnauthorized?.call();
        return const UnauthorizedException();
      case 403:
        return const ForbiddenException();
      case 404:
        return const NotFoundException();
      case 409:
        return const ConflictException();
      case 422:
        return const ValidationException();
      default:
        return ServerException(code: 'http_$status', statusCode: status);
    }
  }
}
