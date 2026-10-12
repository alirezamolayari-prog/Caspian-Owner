// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'مالک کاسپین';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String lastUpdated(String time) {
    return 'آخرین به‌روزرسانی: $time';
  }

  @override
  String get justNow => 'همین الان';

  @override
  String minutesAgo(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString دقیقه پیش';
  }

  @override
  String hoursAgo(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString ساعت پیش';
  }

  @override
  String get yesterday => 'دیروز';

  @override
  String daysAgo(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString روز پیش';
  }

  @override
  String get statusPending => 'منتظر';

  @override
  String get statusApproved => 'تأیید شد';

  @override
  String get statusRejected => 'رد شد';

  @override
  String get statusCancelled => 'لغو شد';

  @override
  String get lowStock => 'کم';

  @override
  String get errorNetwork => 'اتصال برقرار نشد. اینترنت را بررسی کنید.';

  @override
  String get errorGeneric => 'مشکلی پیش آمد. دوباره تلاش کنید.';

  @override
  String get tabHome => 'خانه';

  @override
  String get tabRequests => 'درخواست‌ها';

  @override
  String get tabStock => 'موجودی';

  @override
  String get tabAssistant => 'دستیار';

  @override
  String get requestsTitle => 'درخواست‌ها';

  @override
  String get stockTitle => 'موجودی انبار';

  @override
  String get assistantTitle => 'دستیار کاسپین';

  @override
  String get moreTitle => 'بیشتر';

  @override
  String get logout => 'خروج';

  @override
  String get loginTitle => 'ورود به مالک کاسپین';

  @override
  String get loginPhoneLabel => 'شماره موبایل';

  @override
  String get loginPhoneHint => '۰۹۱۲۳۴۵۶۷۸۹';

  @override
  String get loginPhoneHelp => 'یک کد با پیامک برایتان فرستاده می‌شود.';

  @override
  String get loginPhoneInvalid =>
      'شماره موبایل باید ۱۱ رقم باشد و با ۰۹ شروع شود.';

  @override
  String get loginSendCode => 'دریافت کد';

  @override
  String get loginCodeLabel => 'کد پیامک‌شده';

  @override
  String loginCodeSent(int length, String phone) {
    final intl.NumberFormat lengthNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String lengthString = lengthNumberFormat.format(length);

    return 'کد $lengthString رقمی به $phone فرستاده شد.';
  }

  @override
  String get loginVerify => 'ورود';

  @override
  String get loginChangePhone => 'تغییر شماره';

  @override
  String get loginResend => 'ارسال دوباره کد';

  @override
  String loginResendIn(int seconds) {
    final intl.NumberFormat secondsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    return 'ارسال دوباره تا $secondsString ثانیه';
  }

  @override
  String get loginTestCodeHint => 'نسخه آزمایشی: کد ۱۱۱۱۱';

  @override
  String get lockTitle => 'برنامه قفل است';

  @override
  String get lockBody => 'برای دیدن اطلاعات، هویت خود را تأیید کنید.';

  @override
  String get lockUnlockDevice => 'باز کردن با اثر انگشت';

  @override
  String get lockReason => 'برای باز کردن مالک کاسپین هویت خود را تأیید کنید';

  @override
  String get lockUsePin => 'ورود با رمز برنامه';

  @override
  String get pinLabel => 'رمز برنامه';

  @override
  String pinWrong(int left) {
    final intl.NumberFormat leftNumberFormat = intl.NumberFormat.decimalPattern(
      localeName,
    );
    final String leftString = leftNumberFormat.format(left);

    return 'رمز درست نیست. $leftString بار دیگر می‌توانید امتحان کنید.';
  }

  @override
  String get pinSetupTitle => 'ساختن رمز برنامه';

  @override
  String get pinSetupBody =>
      'این گوشی قفل اثر انگشت یا رمز ندارد. برای حفاظت از اطلاعات، یک رمز ۴ رقمی برای برنامه بسازید.';

  @override
  String get pinRepeatLabel => 'تکرار رمز';

  @override
  String get pinTooShort => 'رمز باید ۴ رقم باشد.';

  @override
  String get pinMismatch => 'دو رمز یکی نیستند.';

  @override
  String get pinSave => 'ذخیره رمز';

  @override
  String get signedOutTooManyAttempts =>
      'به‌خاطر چند رمز اشتباه، دوباره وارد شوید.';

  @override
  String homeGreeting(String name) {
    return 'سلام $name';
  }

  @override
  String get notificationsTooltip => 'اعلان‌ها';

  @override
  String get accountTooltip => 'حساب و گزینه‌های بیشتر';

  @override
  String get cancel => 'انصراف';

  @override
  String get logoutConfirmTitle => 'از حساب خارج می‌شوید؟';

  @override
  String get logoutConfirmBody =>
      'اطلاعات ذخیره‌شده روی این گوشی پاک می‌شود. برای ورود دوباره، کد پیامکی لازم است.';

  @override
  String get comingSoon => 'این بخش به‌زودی آماده می‌شود.';
}
