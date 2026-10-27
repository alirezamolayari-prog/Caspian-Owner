import 'package:caspian_owner/core/config/server_url.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServerUrl', () {
    test('accepts http on the local network and cleans the address', () {
      expect(
        ServerUrl.normalize(' http://192.168.10.58:8000/ '),
        'http://192.168.10.58:8000',
      );
      expect(
        ServerUrl.normalize('http://۱۹۲.۱۶۸.۱.۵:۸۰۰۰'),
        'http://192.168.1.5:8000',
      );
      expect(ServerUrl.problem('http://10.0.0.2:8000'), isNull);
      expect(ServerUrl.problem('http://172.20.1.1'), isNull);
      expect(ServerUrl.problem('http://localhost:8000'), isNull);
    });

    test('public addresses need https', () {
      expect(
        ServerUrl.problem('http://caspian.liara.run'),
        ServerUrlProblem.needsHttps,
      );
      expect(
        ServerUrl.problem('http://8.8.8.8:8000'),
        ServerUrlProblem.needsHttps,
      );
      expect(
        ServerUrl.problem('http://172.32.0.1'),
        ServerUrlProblem.needsHttps,
      );
      expect(ServerUrl.problem('https://caspian.liara.run'), isNull);
    });

    test('rejects things that are not server addresses', () {
      for (final bad in [
        '',
        'caspian',
        'ftp://192.168.1.5',
        'http://',
        'http://192.168.1.5:8000?x=1',
      ]) {
        expect(ServerUrl.problem(bad), ServerUrlProblem.invalid, reason: bad);
        expect(ServerUrl.normalize(bad), isNull, reason: bad);
      }
    });
  });

  group('AppSettings.serverUrl', () {
    test('defaults to Caspian Server on the Iranian host (https)', () {
      expect(const AppSettings().serverUrl, 'https://api.caspianmoblserver.ir');
    });

    test('is saved and read back; a bad saved value falls back', () {
      final saved = const AppSettings().copyWith(
        serverUrl: 'https://caspian.example.ir',
      );
      expect(
        AppSettings.fromJson(saved.toJson()).serverUrl,
        'https://caspian.example.ir',
      );
      expect(
        AppSettings.fromJson({'server_url': 'http://evil.example.com'})
            .serverUrl,
        'https://api.caspianmoblserver.ir',
      );
    });
  });
}
