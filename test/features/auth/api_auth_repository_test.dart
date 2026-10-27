import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/features/auth/data/api_auth_repository.dart';
import 'package:caspian_owner/features/auth/domain/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_server.dart';

void main() {
  late FakeServer server;
  late ApiAuthRepository repository;
  final expiry = DateTime.utc(2026, 10, 28, 9);

  setUp(() {
    server = FakeServer();
    repository = ApiAuthRepository(server.client());
  });

  void loginAnswers({required String role}) {
    server
      ..on(
        'POST',
        '/auth/login',
        FakeServer.json({
          'access_token': fakeJwt(expiry),
          'token_type': 'bearer',
          'role': role,
          'full_name': 'مالک ۱',
        }),
      )
      ..on(
        'GET',
        '/auth/me',
        FakeServer.json({
          'id': 3,
          'username': 'owner1',
          'full_name': 'مالک ۱',
          'role': role,
        }),
      );
  }

  test('an owner logs in: token kept, name and id from /auth/me', () async {
    loginAnswers(role: 'owner');

    final session = await repository.login(
      username: ' owner1 ',
      password: 'owner123',
    );

    expect(session.owner.id, '3');
    expect(session.owner.nameFa, 'مالک ۱');
    expect(session.owner.isAdmin, isFalse);
    expect(session.expiresAt, expiry);
    expect(server.requests.first.data, {
      'username': 'owner1',
      'password': 'owner123',
    });
    // /auth/me was asked with the brand-new token.
    expect(
      server.calls('GET', '/auth/me').single.headers['Authorization'],
      'Bearer ${session.accessToken}',
    );
  });

  test('admin accounts may use the app', () async {
    loginAnswers(role: 'admin');
    final session = await repository.login(username: 'admin', password: 'x');
    expect(session.owner.isAdmin, isTrue);
  });

  test('the warehouse account is refused with not_owner', () async {
    loginAnswers(role: 'warehouse');
    await expectLater(
      repository.login(username: 'warehouse', password: 'x'),
      throwsA(
        isA<ServerException>().having((e) => e.code, 'code', 'not_owner'),
      ),
    );
    expect(server.calls('GET', '/auth/me'), isEmpty);
  });

  test('wrong password → UnauthorizedException', () async {
    server.on('POST', '/auth/login', FakeServer.error(401));
    await expectLater(
      repository.login(username: 'owner1', password: 'bad'),
      throwsA(isA<UnauthorizedException>()),
    );
  });

  test('a first password must be changed before /auth/me', () async {
    server.on(
      'POST',
      '/auth/login',
      FakeServer.json({
        'access_token': 'first',
        'token_type': 'bearer',
        'role': 'owner',
        'full_name': 'مالک ۱',
        'must_change_password': true,
      }),
    );
    await expectLater(
      repository.login(username: '09123456789', password: 'x'),
      throwsA(
        isA<MustChangePasswordException>().having(
          (e) => e.accessToken,
          'token',
          'first',
        ),
      ),
    );
    expect(server.calls('GET', '/auth/me'), isEmpty);
  });

  for (final code in [
    'account_pending',
    'account_rejected',
    'account_disabled',
  ]) {
    test('$code is reported by its code', () async {
      server.on('POST', '/auth/login', FakeServer.fail(403, code));
      await expectLater(
        repository.login(username: '09123456789', password: 'x'),
        throwsA(isA<ServerException>().having((e) => e.code, 'code', code)),
      );
    });
  }

  test('token expiry: read from the JWT, null when unreadable', () {
    expect(ApiAuthRepository.tokenExpiry(fakeJwt(expiry)), expiry);
    expect(ApiAuthRepository.tokenExpiry('not-a-jwt'), isNull);
    expect(ApiAuthRepository.tokenExpiry('a.@@@.c'), isNull);
  });
}
