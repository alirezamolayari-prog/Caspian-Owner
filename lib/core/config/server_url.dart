import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';

/// Why a typed server address can't be used.
enum ServerUrlProblem {
  /// Not an address at all, or not http/https.
  invalid,

  /// `http://` to a public address: only https is allowed there.
  needsHttps,
}

/// Checks and cleans a server address typed by the owner.
abstract final class ServerUrl {
  /// The cleaned address (no trailing slash, Latin digits), or null when
  /// [problem] reports something.
  static String? normalize(String input) =>
      problem(input) == null ? _clean(input) : null;

  /// Null when [input] is fine.
  static ServerUrlProblem? problem(String input) {
    final uri = Uri.tryParse(_clean(input));
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      return ServerUrlProblem.invalid;
    }
    if (uri.scheme == 'http' &&
        !(ApiConfig.allowLanHttp && isLocalHost(uri.host))) {
      return ServerUrlProblem.needsHttps;
    }
    return null;
  }

  /// Private-network and loopback hosts (where plain http is tolerated
  /// while testing).
  static bool isLocalHost(String host) {
    if (host == 'localhost' || host.endsWith('.local')) return true;
    final parts = host.split('.').map(int.tryParse).toList();
    if (parts.length != 4 || parts.any((p) => p == null || p < 0 || p > 255)) {
      return false;
    }
    final [a!, b!, _, _] = parts;
    return a == 10 ||
        a == 127 ||
        (a == 192 && b == 168) ||
        (a == 172 && b >= 16 && b <= 31);
  }

  static String _clean(String input) {
    var url = toLatinDigits(input.trim());
    while (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }
}
