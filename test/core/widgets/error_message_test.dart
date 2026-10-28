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
      'سرور کاسپین جواب نداد. کمی بعد دوباره امتحان کنید.',
    );
    expect(
      errorMessage(const NetworkException.noInternet(), l10n),
      'اینترنت گوشی وصل نیست. وای‌فای یا اینترنت همراه را روشن کنید.',
    );
    expect(
      errorMessage(const UnauthorizedException(), l10n, atLogin: true),
      'شماره موبایل یا رمز عبور اشتباه است.',
    );
    expect(
      errorMessage(
        const ServerException(
          code: 'invalid_credentials',
          messageFa: 'نام کاربری یا رمز عبور اشتباه است',
          statusCode: 401,
        ),
        l10n,
        atLogin: true,
      ),
      'شماره موبایل یا رمز عبور اشتباه است.',
    );
    expect(
      errorMessage(
        const ServerException(code: 'http_429', statusCode: 429),
        l10n,
      ),
      'تعداد تلاش‌ها زیاد شد. کمی بعد دوباره امتحان کنید.',
    );
    expect(
      errorMessage(
        const ValidationException(fieldErrors: {'password': 'رمز ضعیف است'}),
        l10n,
      ),
      'رمز ضعیف است',
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
      'این حساب برای اپ مالکان نیست.',
    );
    // Our own wording, whatever detail the server sent.
    expect(
      errorMessage(
        const ServerException(code: 'mobile_taken', messageFa: 'متن سرور'),
        l10n,
      ),
      'این شماره قبلاً ثبت شده؛ وارد شوید یا از فراموشی رمز استفاده کنید.',
    );
    expect(
      errorMessage(const ServerException(code: 'account_not_found'), l10n),
      'حسابی با این شماره پیدا نشد. اول ثبت‌نام کنید.',
    );
    expect(
      errorMessage(const ServerException(code: 'sms_not_sent'), l10n),
      'پیامک فرستاده نشد. چند دقیقه دیگر دوباره امتحان کنید.',
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
