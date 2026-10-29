import 'dart:convert';

import 'package:caspian_owner/core/brand/brand.dart';
import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:dio/dio.dart';

/// Where to look for `update.json`, in order: the server (when
/// [ApiConfig.baseUrl] is set), then the latest GitHub Release.
// TODO(alireza): once Caspian Server hosts the manifest (faster from Iran
// than GitHub), set ApiConfig.baseUrl and check the path below. Nothing on
// the server serves it yet, so GitHub is used.
List<String> manifestUrls() => [
  if (ApiConfig.baseUrl.isNotEmpty) '${ApiConfig.baseUrl}/v1/app/update',
  'https://github.com/${Brand.releaseRepo}/releases/latest/download/update.json',
];

/// Fetches the first manifest that answers. Fails silently (null): a
/// missing update must never get in the owner's way.
class UpdateChecker {
  new({Dio? dio, List<String>? urls})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 6),
              receiveTimeout: const Duration(seconds: 8),
              // GitHub serves release assets as application/octet-stream,
              // so read text and decode it here.
              responseType: ResponseType.plain,
            ),
          ),
      _urls = urls ?? manifestUrls();

  final Dio _dio;
  final List<String> _urls;

  Future<UpdateManifest?> fetch() async {
    for (final url in _urls) {
      try {
        final response = await _dio.get<String>(url);
        final data = jsonDecode(response.data ?? '');
        if (data is Map<String, Object?>) return UpdateManifest.fromJson(data);
      } on Object {
        // Timeout, 404, filtered network or a bad manifest: try the next.
      }
    }
    return null;
  }
}
