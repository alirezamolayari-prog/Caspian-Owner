import 'package:caspian_owner/core/network/api_client.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';

void main() {
  late FakeServer server;
  setUp(() => server = FakeServer());

  test('sends the token and decodes Persian JSON', () async {
    server.on('GET', '/auth/me', FakeServer.json({'full_name': 'مالک ۱'}));

    final json = await server.client(token: 'abc').get('/auth/me');

    expect(json, {'full_name': 'مالک ۱'});
    expect(server.requests.single.headers['Authorization'], 'Bearer abc');
  });

  test('no token: no Authorization header', () async {
    server.on('GET', '/health', FakeServer.json({'status': 'ok'}));
    await server.client().get('/health');
    expect(server.requests.single.headers['Authorization'], isNull);
  });

  test('login is sent as form fields', () async {
    server.on('POST', '/auth/login', FakeServer.json({'access_token': 't'}));
    await server.client().post(
      '/auth/login',
      form: {'username': 'owner1', 'password': 'owner123'},
    );
    final request = server.requests.single;
    expect(request.contentType, Headers.formUrlEncodedContentType);
    expect(request.data, {'username': 'owner1', 'password': 'owner123'});
  });

  test('server off / unreachable → NetworkException', () async {
    // No route = connection error, like a PC with the server stopped.
    await expectLater(
      server.client().get('/requests'),
      throwsA(isA<NetworkException>()),
    );
  });

  final cases = <int, Matcher>{
    401: isA<UnauthorizedException>(),
    403: isA<ForbiddenException>(),
    404: isA<NotFoundException>(),
    409: isA<ConflictException>(),
    422: isA<ValidationException>(),
    500: isA<ServerException>().having((e) => e.statusCode, 'status', 500),
  };
  for (final MapEntry(key: status, value: matcher) in cases.entries) {
    test('HTTP $status is mapped', () async {
      server.on('GET', '/x', FakeServer.error(status));
      await expectLater(server.client().get('/x'), throwsA(matcher));
    });
  }

  test('401 with a token ends the session; without one it does not', () async {
    server.on('GET', '/x', FakeServer.error(401));
    var expired = 0;

    await expectLater(
      server.client(token: 't', onUnauthorized: () => expired++).get('/x'),
      throwsA(isA<UnauthorizedException>()),
    );
    expect(expired, 1);

    // A wrong password at login is also 401, but there is no session.
    await expectLater(
      server.client(onUnauthorized: () => expired++).get('/x'),
      throwsA(isA<UnauthorizedException>()),
    );
    expect(expired, 1);
  });

  test('a broken answer is a ServerException, not a crash', () async {
    server.on('GET', '/x', (_) => ResponseBody.fromString('<html>', 200));
    await expectLater(
      server.client().get('/x'),
      throwsA(isA<ServerException>()),
    );
    expect(() => ApiClient.asMap([1]), throwsA(isA<ServerException>()));
    expect(() => ApiClient.asList({'a': 1}), throwsA(isA<ServerException>()));
  });
}
