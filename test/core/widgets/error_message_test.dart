import 'package:caspian_owner/core/l10n/generated/app_localizations_fa.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/core/network/not_connected.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsFa();

  test('each server answer has its own clear Persian message', () {
    expect(
      errorMessage(const NetworkException(), l10n),
      'به سرور وصل نشد. وای‌فای و آدرس سرور را بررسی کنید.',
    );
    expect(
      errorMessage(const UnauthorizedException(), l10n, atLogin: true),
      'نام کاربری یا رمز عبور اشتباه است.',
    );
    expect(
      errorMessage(const UnauthorizedException(), l10n),
      'نشست شما تمام شد. دوباره وارد شوید.',
    );
    expect(
      errorMessage(const ForbiddenException(), l10n),
      'شما اجازهٔ انجام این کار را ندارید.',
    );
    expect(
      errorMessage(const ConflictException(), l10n),
      'این درخواست قبلاً تأیید یا رد شده است.',
    );
    expect(
      errorMessage(const ValidationException(), l10n),
      'اطلاعات واردشده معتبر نیست. دوباره بررسی کنید.',
    );
    expect(
      errorMessage(const ServerException(code: 'http_500'), l10n),
      'خطای سرور. کمی بعد دوباره تلاش کنید.',
    );
    expect(
      errorMessage(const ServerException(code: 'not_owner'), l10n),
      'این حساب مخصوص مالکان نیست. با حساب مالک وارد شوید.',
    );
    expect(
      errorMessage(notConnected, l10n),
      'این بخش هنوز به سرور وصل نشده است.',
    );
  });

  test("the mock's own messages are still shown as sent", () {
    expect(
      errorMessage(
        const ServerException(code: 'internal', messageFa: 'پیام ماک'),
        l10n,
      ),
      'پیام ماک',
    );
  });
}
