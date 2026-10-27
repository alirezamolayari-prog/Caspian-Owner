import 'dart:io' show SocketException;
import 'dart:typed_data';

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

  test(
    'account errors keep the header code, Persian detail and wait',
    () async {
      server.on(
        'POST',
        '/auth/otp/request',
        FakeServer.fail(
          429,
          'otp_cooldown',
          detail: 'کمی صبر کنید',
          retryAfter: 42,
        ),
      );
      await expectLater(
        server.client().post('/auth/otp/request', json: const {}),
        throwsA(
          isA<ServerException>()
              .having((e) => e.code, 'code', 'otp_cooldown')
              .having((e) => e.messageFa, 'detail', 'کمی صبر کنید')
              .having((e) => e.statusCode, 'status', 429)
              .having((e) => e.retryAfter, 'wait', const Duration(seconds: 42)),
        ),
      );
    },
  );

  test('wrong login is an account error, not an expired session', () async {
    server.on(
      'POST',
      '/auth/login',
      FakeServer.fail(401, 'invalid_credentials'),
    );
    var expired = 0;
    await expectLater(
      server
          .client(onUnauthorized: () => expired++)
          .post('/auth/login', form: const {}),
      throwsA(
        isA<ServerException>().having(
          (e) => e.code,
          'code',
          'invalid_credentials',
        ),
      ),
    );
    expect(expired, 0);
  });

  test('signed-in requests keep the old types even with a header', () async {
    server.on('POST', '/x', FakeServer.fail(409, 'already_decided'));
    await expectLater(
      server.client(token: 't').post('/x'),
      throwsA(isA<ConflictException>()),
    );
  });

  test('password_change_required is reported by its code', () async {
    server.on('GET', '/x', FakeServer.fail(403, 'password_change_required'));
    await expectLater(
      server.client(token: 't').get('/x'),
      throwsA(
        isA<ServerException>().having(
          (e) => e.code,
          'code',
          'password_change_required',
        ),
      ),
    );
  });

  test('a 422 list names the field and drops «Value error,»', () async {
    server.on(
      'POST',
      '/auth/otp/register',
      FakeServer.invalidField('first_name', 'با حروف فارسی بنویسید'),
    );
    await expectLater(
      server.client().post('/auth/otp/register', json: const {}),
      throwsA(
        isA<ValidationException>().having((e) => e.fieldErrors, 'fields', {
          'first_name': 'با حروف فارسی بنویسید',
        }),
      ),
    );
  });

  test('a failed name lookup means no internet; a timeout does not', () async {
    Future<NetworkException> mapped(DioException Function(RequestOptions) e) =>
        ApiClient(
              baseUrl: FakeServer.baseUrl,
              dio: Dio()..httpClientAdapter = _Throwing(e),
            )
            .get('/x')
            .then<NetworkException>(
              (_) => throw StateError('no error'),
              onError: (Object error) => error as NetworkException,
            );

    final offline = await mapped(
      (options) => DioException.connectionError(
        requestOptions: options,
        reason: 'lookup',
        error: const SocketException('Failed host lookup: api.example.ir'),
      ),
    );
    expect(offline.offline, isTrue);

    final timeout = await mapped(
      (options) => DioException.connectionTimeout(
        timeout: const Duration(seconds: 10),
        requestOptions: options,
      ),
    );
    expect(timeout.offline, isFalse);
  });

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

/// Fails every request with the given dio error.
class _Throwing implements HttpClientAdapter {
  new(this.error);

  final DioException Function(RequestOptions options) error;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => throw error(options);

  @override
  void close({bool force = false}) {}
}
