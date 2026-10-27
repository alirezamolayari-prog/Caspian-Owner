import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/security/app_lock.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  final signedIn = SignedIn(testSession());
  const signedOut = SignedOut();
  const unlocked = LockState(
    locked: false,
    deviceAuthAvailable: true,
    hasPin: false,
  );
  const locked = LockState(
    locked: true,
    deviceAuthAvailable: true,
    hasPin: false,
  );
  const noScreenLock = LockState(
    locked: false,
    deviceAuthAvailable: false,
    hasPin: false,
  );

  String? go(AuthState auth, LockState lock, String location) =>
      appRedirect(auth: auth, lock: lock, location: Uri.parse(location));

  group('signed out', () {
    test('everything leads to login', () {
      expect(go(signedOut, unlocked, '/'), '/login');
      expect(go(signedOut, unlocked, '/requests/r-124'), '/login');
    });

    test('login itself stays', () {
      expect(go(signedOut, unlocked, '/login'), isNull);
    });

    test('register, forgot password and account pages are open', () {
      for (final path in [
        '/register',
        '/forgot-password',
        '/otp',
        '/new-password',
        '/registered',
        '/account/pending',
        '/account/rejected',
        '/change-password',
      ]) {
        expect(go(signedOut, unlocked, path), isNull, reason: path);
      }
    });

    test('the fingerprint offer needs a login', () {
      expect(go(signedOut, unlocked, '/unlock-offer'), '/login');
    });
  });

  group('just logged in with the password', () {
    const offer = LockState(
      locked: false,
      deviceAuthAvailable: true,
      hasPin: false,
      offerPending: true,
    );
    const declined = LockState(
      locked: false,
      deviceAuthAvailable: true,
      hasPin: false,
      useDevice: false,
    );

    test('the fingerprint is offered first', () {
      expect(go(signedIn, offer, '/'), '/unlock-offer');
      expect(go(signedIn, offer, '/unlock-offer'), isNull);
    });

    test('«not now» leads to creating an app PIN', () {
      expect(go(signedIn, declined, '/'), '/pin-setup');
      expect(go(signedIn, declined.copyWith(hasPin: true), '/'), isNull);
    });

    test('the offer page leads home once answered', () {
      expect(go(signedIn, unlocked, '/unlock-offer'), '/');
      expect(go(signedIn, unlocked, '/register'), '/');
    });
  });

  group('phone without a screen lock', () {
    test('must create an app PIN first', () {
      expect(go(signedIn, noScreenLock, '/'), '/pin-setup');
      expect(go(signedIn, noScreenLock, '/pin-setup'), isNull);
    });
  });

  group('locked', () {
    test('goes to the lock screen and remembers the destination', () {
      expect(
        go(signedIn, locked, '/requests/r-124'),
        '/lock?from=%2Frequests%2Fr-124',
      );
    });

    test('lock screen stays', () {
      expect(go(signedIn, locked, '/lock?from=%2Fstock'), isNull);
    });
  });

  group('unlocked', () {
    test('returns from the lock screen to the remembered destination', () {
      expect(
        go(signedIn, unlocked, '/lock?from=%2Frequests%2Fr-124'),
        '/requests/r-124',
      );
      expect(go(signedIn, unlocked, '/lock'), '/');
    });

    test('login and PIN setup lead home once done', () {
      expect(go(signedIn, unlocked, '/login'), '/');
      expect(go(signedIn, unlocked, '/pin-setup'), '/');
    });

    test('normal screens stay', () {
      expect(go(signedIn, unlocked, '/stock'), isNull);
      expect(go(signedIn, unlocked, '/requests/r-124'), isNull);
    });
  });
}
