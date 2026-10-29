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
  String get statusIssued => 'حواله صادر شد';

  @override
  String get statusUnknown => 'نامشخص';

  @override
  String get decidedByYou => 'شما';

  @override
  String get decidedByAnotherOwner => 'یکی از مالکان';

  @override
  String issuedBanner(String number) {
    return 'حواله صادر شد – شماره $number';
  }

  @override
  String get issuedBannerNoNumber => 'حواله صادر شد';

  @override
  String get unknownStatusBanner =>
      'وضعیت این درخواست برای این نسخه از برنامه شناخته‌شده نیست. برنامه را به‌روز کنید.';

  @override
  String get rejectReasonHelper =>
      'دست‌کم ۳ حرف بنویسید. انبار این دلیل را می‌بیند.';

  @override
  String decisionFailed(String number, String reason) {
    return 'تصمیم درخواست $number ثبت نشد: $reason';
  }

  @override
  String get errorWidgetTitle => 'این بخش درست نمایش داده نشد';

  @override
  String get errorWidgetBody => 'مشکل ثبت شد. برگردید و دوباره امتحان کنید.';

  @override
  String get errorWidgetBack => 'بازگشت';

  @override
  String get roleAdmin => 'مدیر سیستم (ادمین)';

  @override
  String get roleWarehouse => 'انبار';

  @override
  String get roleUnassigned => 'نقش تعیین نشده';

  @override
  String get usersActive => 'فعال';

  @override
  String get usersInactive => 'غیرفعال';

  @override
  String get usersApprovalPending => 'منتظر تأیید';

  @override
  String get usersApprovalRejected => 'رد شده';

  @override
  String get usersPendingSection => 'منتظر تأیید مدیر';

  @override
  String get usersAllSection => 'همه کاربران';

  @override
  String get statusPending => 'منتظر';

  @override
  String get statusApproved => 'تأیید شد';

  @override
  String get statusRejected => 'رد شد';

  @override
  String get statusCancelled => 'لغو شد';

  @override
  String get statusReturned => 'برگشت برای اصلاح';

  @override
  String get lowStock => 'کم';

  @override
  String get errorNetwork =>
      'سرور کاسپین جواب نداد. کمی بعد دوباره امتحان کنید.';

  @override
  String get errorOffline =>
      'اینترنت گوشی وصل نیست. وای‌فای یا اینترنت همراه را روشن کنید.';

  @override
  String get errorTooManyRequests =>
      'تعداد تلاش‌ها زیاد شد. کمی بعد دوباره امتحان کنید.';

  @override
  String get errorGeneric => 'مشکلی پیش آمد. دوباره تلاش کنید.';

  @override
  String get errorWrongPassword => 'شماره موبایل یا رمز عبور اشتباه است.';

  @override
  String get errorSessionExpired => 'نشست شما تمام شد. دوباره وارد شوید.';

  @override
  String get errorForbidden => 'شما اجازهٔ انجام این کار را ندارید.';

  @override
  String get errorConflict => 'این درخواست قبلاً تأیید یا رد شده است.';

  @override
  String get errorInvalidData =>
      'اطلاعات واردشده معتبر نیست. دوباره بررسی کنید.';

  @override
  String get errorNotFound => 'این مورد پیدا نشد.';

  @override
  String get errorServer => 'خطای سرور. کمی بعد دوباره تلاش کنید.';

  @override
  String get errorMobileTaken =>
      'این شماره قبلاً ثبت شده؛ وارد شوید یا از فراموشی رمز استفاده کنید.';

  @override
  String get errorAccountNotFound =>
      'حسابی با این شماره پیدا نشد. اول ثبت‌نام کنید.';

  @override
  String get errorSmsNotSent =>
      'پیامک فرستاده نشد. چند دقیقه دیگر دوباره امتحان کنید.';

  @override
  String get errorNotOwner => 'این حساب برای اپ مالکان نیست.';

  @override
  String get errorNotConnected => 'این بخش هنوز به سرور وصل نشده است.';

  @override
  String get notConnectedBody =>
      'این بخش هنوز به سرور کاسپین وصل نشده است و به‌زودی اضافه می‌شود.';

  @override
  String get notConnectedTitle => 'به‌زودی';

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
  String get loginUsernameLabel => 'نام کاربری';

  @override
  String get loginPasswordLabel => 'رمز عبور';

  @override
  String get loginShowPassword => 'نمایش رمز';

  @override
  String get loginHidePassword => 'پنهان کردن رمز';

  @override
  String get loginFieldsRequired => 'شماره موبایل و رمز عبور را وارد کنید.';

  @override
  String get loginVerify => 'ورود';

  @override
  String get loginTestPasswordHint => 'نسخه آزمایشی: رمز ۱۱۱۱۱';

  @override
  String loginServer(String url) {
    return 'سرور: $url';
  }

  @override
  String get loginChangeServer => 'تغییر آدرس سرور';

  @override
  String get loginMobileLabel => 'شماره موبایل';

  @override
  String get loginMobileHint => 'مثل ۰۹۱۲۳۴۵۶۷۸۹';

  @override
  String get loginUseUsername => 'ورود با نام کاربری';

  @override
  String get loginUseMobile => 'ورود با شماره موبایل';

  @override
  String loginWaitButton(String time) {
    return 'ورود ($time)';
  }

  @override
  String get loginForgot => 'رمز را فراموش کرده‌ام';

  @override
  String get loginNoAccount => 'حساب ندارید؟';

  @override
  String get loginRegister => 'ثبت‌نام مالک جدید';

  @override
  String get loginRegisteredNotice =>
      'درخواست ثبت‌نام شما ثبت شد. بعد از تأیید مدیر، با همین شماره و رمز وارد شوید.';

  @override
  String get loginPasswordResetNotice =>
      'رمز تازه ذخیره شد. با رمز تازه وارد شوید.';

  @override
  String get mobileInvalid =>
      'شماره موبایل درست نیست. ۱۱ رقم است و با ۰۹ شروع می‌شود.';

  @override
  String stepOf(String step, String total) {
    return 'مرحله $step از $total';
  }

  @override
  String get sendCode => 'ارسال کد';

  @override
  String get backToLogin => 'بازگشت به صفحه ورود';

  @override
  String get registerTitle => 'ثبت‌نام مالک جدید';

  @override
  String get registerBody =>
      'نام و شماره موبایل خود را بنویسید. یک کد ۶ رقمی برایتان پیامک می‌شود.';

  @override
  String get registerFirstName => 'نام';

  @override
  String get registerLastName => 'نام خانوادگی';

  @override
  String get nameInvalid => 'با حروف فارسی بنویسید (۲ تا ۵۰ حرف).';

  @override
  String get registerHaveAccount => 'قبلاً ثبت‌نام کرده‌اید؟ ورود';

  @override
  String get registerSubmit => 'ثبت‌نام';

  @override
  String get forgotTitle => 'فراموشی رمز عبور';

  @override
  String get forgotBody =>
      'شماره موبایلی را که با آن ثبت‌نام کرده‌اید بنویسید. یک کد ۶ رقمی برایتان پیامک می‌شود.';

  @override
  String get otpTitle => 'کد پیامک‌شده را بنویسید';

  @override
  String otpSentTo(String mobile) {
    return 'کد ۶ رقمی به شماره $mobile پیامک شد.';
  }

  @override
  String get otpLabel => 'کد ۶ رقمی';

  @override
  String get otpAutoFillNote =>
      'اگر گوشی اجازه خواست، «اجازه دادن» را بزنید تا کد خودش نوشته شود.';

  @override
  String get otpChangeMobile => 'تغییر شماره';

  @override
  String get otpVerify => 'تأیید کد';

  @override
  String otpResendIn(String time) {
    return 'ارسال دوباره کد تا $time دیگر';
  }

  @override
  String get otpResend => 'ارسال دوباره کد';

  @override
  String get otpResent => 'کد تازه فرستاده شد.';

  @override
  String get otpTooShort => 'کد ۶ رقم است.';

  @override
  String get passwordCreateTitle => 'رمز عبور بسازید';

  @override
  String get passwordResetTitle => 'رمز عبور تازه بسازید';

  @override
  String get passwordChangeTitle => 'رمز عبور خودتان را بسازید';

  @override
  String get passwordBody =>
      'رمزی بسازید که یادتان بماند و دیگران نتوانند حدس بزنند.';

  @override
  String get passwordChangeBody =>
      'رمزی که مدیر به شما داده موقت است. یک رمز تازه بسازید که فقط خودتان بدانید.';

  @override
  String get passwordNewLabel => 'رمز عبور تازه';

  @override
  String get passwordRepeatLabel => 'تکرار رمز عبور';

  @override
  String get passwordRuleLength => 'دست‌کم ۸ حرف یا عدد';

  @override
  String get passwordRuleDistinct => 'دست‌کم ۴ حرف یا عدد متفاوت';

  @override
  String get passwordRuleOk => 'انجام شد';

  @override
  String get passwordRuleNotYet => 'هنوز نه';

  @override
  String get passwordTooLong => 'رمز خیلی بلند است. کوتاه‌ترش کنید.';

  @override
  String get passwordTooCommon =>
      'این رمز خیلی ساده و رایج است. رمز دیگری بسازید.';

  @override
  String get passwordMismatch => 'دو رمز یکی نیستند.';

  @override
  String get resetSubmit => 'ذخیره رمز تازه';

  @override
  String get changeSubmit => 'ذخیره و ورود';

  @override
  String get flowRestart => 'از اول شروع کنید';

  @override
  String get flowExpiredTitle => 'مهلت تمام شد';

  @override
  String get flowExpired =>
      'مهلت این مرحله تمام شده است. لطفاً از اول شروع کنید.';

  @override
  String get accountRegisteredTitle => 'درخواست شما ثبت شد';

  @override
  String get accountRegisteredBody =>
      'مدیر کاسپین باید حساب شما را تأیید کند. بعد از تأیید، با همین شماره موبایل و رمز وارد شوید.';

  @override
  String get accountPendingTitle => 'حساب شما منتظر تأیید است';

  @override
  String get accountPendingBody =>
      'مدیر کاسپین هنوز حساب شما را تأیید نکرده است. بعد از تأیید دوباره وارد شوید.';

  @override
  String get accountRejectedTitle => 'درخواست ثبت‌نام تأیید نشد';

  @override
  String get accountRejectedBody =>
      'مدیر کاسپین این حساب را تأیید نکرد. برای اطلاعات بیشتر با مدیر تماس بگیرید.';

  @override
  String get accountDisabledTitle => 'حساب شما غیرفعال است';

  @override
  String get accountDisabledBody =>
      'مدیر کاسپین این حساب را غیرفعال کرده است. با مدیر تماس بگیرید.';

  @override
  String get unlockOfferTitle => 'ورود سریع با اثر انگشت؟';

  @override
  String get unlockOfferBody =>
      'از این به بعد برنامه با اثر انگشت (یا قفل گوشی) باز می‌شود و لازم نیست هر بار رمز بزنید. رمز عبور شما عوض نمی‌شود.';

  @override
  String get unlockOfferYes => 'بله، فعال شود';

  @override
  String get unlockOfferNo => 'فعلاً نه';

  @override
  String get unlockOfferNoNote =>
      'اگر نخواهید، یک رمز ۴ رقمی برای باز کردن برنامه می‌سازید.';

  @override
  String get unlockOfferReason =>
      'برای فعال کردن ورود با اثر انگشت، انگشت خود را روی حسگر بگذارید';

  @override
  String get unlockOfferFailed => 'اثر انگشت تأیید نشد. دوباره امتحان کنید.';

  @override
  String get serverTitle => 'آدرس سرور';

  @override
  String get serverHelp =>
      'مثال: http://192.168.10.58:8000 (روی وای‌فای پاساژ) یا یک آدرس https.';

  @override
  String get serverChangeSignsOut =>
      'با تغییر آدرس سرور، از حساب خارج می‌شوید و باید دوباره وارد شوید.';

  @override
  String get serverInvalid => 'آدرس درست نیست. مثال: http://192.168.10.58:8000';

  @override
  String get serverNeedsHttps => 'برای آدرس‌های اینترنتی فقط https مجاز است.';

  @override
  String get serverTest => 'آزمایش اتصال';

  @override
  String get serverTestOk => 'اتصال برقرار است.';

  @override
  String get serverSave => 'ذخیره';

  @override
  String get serverSaved => 'آدرس سرور ذخیره شد.';

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
  String get lockUsePassword => 'ورود با رمز عبور';

  @override
  String get authPromptTitle => 'تأیید هویت';

  @override
  String get authPromptHint => 'با اثر انگشت یا قفل گوشی';

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
  String get signedOutSessionExpired => 'نشست شما تمام شد. دوباره وارد شوید.';

  @override
  String homeGreeting(String name) {
    return 'سلام $name';
  }

  @override
  String get notificationsTooltip => 'اعلان‌ها';

  @override
  String get notificationsTitle => 'اعلان‌ها';

  @override
  String get notificationsEmpty => 'در ۳۰ روز گذشته اعلانی نبوده است.';

  @override
  String get accountTooltip => 'حساب و گزینه‌های بیشتر';

  @override
  String get cancel => 'انصراف';

  @override
  String get logoutConfirmTitle => 'از حساب خارج می‌شوید؟';

  @override
  String get logoutConfirmBody =>
      'اطلاعات ذخیره‌شده روی این گوشی پاک می‌شود. برای ورود دوباره، نام کاربری و رمز عبور لازم است.';

  @override
  String get comingSoon => 'این بخش به‌زودی آماده می‌شود.';

  @override
  String get backToHub => 'همه بخش‌های کاسپین';

  @override
  String hubPendingBadge(String count) {
    return '$count منتظر';
  }

  @override
  String get moduleWarehouse => 'انبار';

  @override
  String get moduleWarehouseSubtitle => 'درخواست‌ها، موجودی و دستیار';

  @override
  String get moduleParking => 'پارکینگ';

  @override
  String get moduleParkingSubtitle => 'ورود و خروج و جای پارک';

  @override
  String get moduleCrm => 'CRM';

  @override
  String get moduleCrmSubtitle => 'مشتریان و پیگیری‌ها';

  @override
  String get moduleServices => 'خدمات کاسپین';

  @override
  String get moduleServicesSubtitle => 'تعمیرات و خدمات مجتمع';

  @override
  String moduleComingSoonTitle(String name) {
    return '$name به‌زودی';
  }

  @override
  String get moduleComingSoonBody =>
      'این بخش هنوز ساخته نشده است. وقتی آماده شود، اینجا بخشی از آن برای شما باز می‌شود: تأییدها، گزارش کلی و گفتگو.';

  @override
  String get homePendingTitle => 'منتظر تأیید شما';

  @override
  String homePendingCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString درخواست';
  }

  @override
  String get homeReviewRequests => 'بررسی درخواست‌ها';

  @override
  String get homeAllReviewed => 'همه درخواست‌ها بررسی شده‌اند';

  @override
  String get homeAllReviewedBody => 'درخواستی منتظر تأیید شما نیست.';

  @override
  String get homeLatestRequests => 'آخرین درخواست‌ها';

  @override
  String get homeNoRequests => 'هنوز درخواستی ثبت نشده است.';

  @override
  String requestLineTitle(String item, String qty, String unit) {
    return '$item – $qty $unit';
  }

  @override
  String requestMoreItems(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'و $countString قلم دیگر';
  }

  @override
  String senderAndTime(String sender, String time) {
    return '$sender – $time';
  }

  @override
  String filterPending(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'منتظر ($countString)';
  }

  @override
  String get filterReviewed => 'بررسی‌شده';

  @override
  String get filterAll => 'همه';

  @override
  String get requestsEmptyPending => 'درخواستی منتظر تأیید شما نیست.';

  @override
  String get requestsEmptyReviewed => 'هنوز درخواستی بررسی نشده است.';

  @override
  String get requestsEmptyAll => 'هنوز درخواستی ثبت نشده است.';

  @override
  String get queuedLabel => 'در صف ارسال';

  @override
  String get managerLabel => 'مدیر انبار';

  @override
  String requestTitle(String number) {
    return 'درخواست $number';
  }

  @override
  String requestFrom(String sender, String time) {
    return 'از طرف $sender – $time';
  }

  @override
  String get placeLabel => 'محل مصرف';

  @override
  String get stockNow => 'موجودی فعلی';

  @override
  String get usedLastMonth => 'مصرف ماه قبل';

  @override
  String get hiddenByCount => 'در حال شمارش در انبار';

  @override
  String qtyWithUnit(String qty, String unit) {
    return '$qty $unit';
  }

  @override
  String get noteLabel => 'یادداشت';

  @override
  String get routineRequestNote =>
      'این درخواست عادی است و مدیر انبار درباره آن تصمیم می‌گیرد.';

  @override
  String decidedApprovedBy(String name, String time) {
    return 'تأیید شد توسط $name – $time';
  }

  @override
  String decidedRejectedBy(String name, String time) {
    return 'رد شد توسط $name – $time';
  }

  @override
  String decisionReason(String reason) {
    return 'دلیل: $reason';
  }

  @override
  String get approve => 'تأیید';

  @override
  String get reject => 'رد کردن';

  @override
  String approveReason(String number) {
    return 'برای تأیید درخواست $number هویت خود را تأیید کنید';
  }

  @override
  String get approvedDone => 'تأیید شد و به انبار خبر داده شد';

  @override
  String get rejectedDone => 'رد شد و به انبار خبر داده شد';

  @override
  String get undo => 'بازگرداندن';

  @override
  String undoApprovePending(String seconds) {
    return 'تأیید درخواست – $seconds ثانیه تا ارسال';
  }

  @override
  String undoRejectPending(String seconds) {
    return 'رد درخواست – $seconds ثانیه تا ارسال';
  }

  @override
  String get decisionQueued =>
      'اینترنت وصل نیست. تصمیم شما در صف ارسال است و خودکار فرستاده می‌شود.';

  @override
  String get conflictTitle => 'این درخواست قبلاً بررسی شده است';

  @override
  String conflictApproved(String name) {
    return 'تأیید شد توسط $name. تصمیم شما ثبت نشد.';
  }

  @override
  String conflictRejected(String name) {
    return 'رد شد توسط $name. تصمیم شما ثبت نشد.';
  }

  @override
  String get ok => 'باشه';

  @override
  String rejectSheetTitle(String number) {
    return 'رد کردن درخواست $number';
  }

  @override
  String get rejectReasonLabel => 'دلیل رد';

  @override
  String get rejectReasonHint => 'مثلاً: مقدار زیاد است';

  @override
  String get locationHistoryTitle => 'مصرف قبلی همین محل';

  @override
  String get locationHistoryEmpty => 'تا حالا چیزی به این محل داده نشده است.';

  @override
  String historyLine(String item, String qty, String unit) {
    return '$item – $qty $unit';
  }

  @override
  String historyMeta(String date, String document) {
    return '$date – حواله $document';
  }

  @override
  String get chatEmpty => 'هنوز پیامی نیست.';

  @override
  String get chatYou => 'شما';

  @override
  String get chatTileTitle => 'گفتگو';

  @override
  String chatTileTitleCount(String count) {
    return 'گفتگو – $count پیام';
  }

  @override
  String chatLastMessage(String name, String text, String time) {
    return '$name: $text – $time';
  }

  @override
  String get chatUnread => 'پیام تازه';

  @override
  String chatScreenTitle(String number) {
    return 'گفتگو – درخواست $number';
  }

  @override
  String get chatJumpToNewest => 'جدیدترین';

  @override
  String get chatLoadingOlder => 'در حال آوردن پیام‌های قدیمی‌تر';

  @override
  String get chatSending => 'در حال فرستادن…';

  @override
  String get returnForEdit => 'ویرایش و برگرداندن';

  @override
  String returnSheetTitle(String number) {
    return 'ویرایش و برگرداندن درخواست $number';
  }

  @override
  String get returnSheetHelp =>
      'مقدار هر قلم را کم کنید یا قلمی را حذف کنید. درخواست با پیشنهاد شما به درخواست‌کننده برمی‌گردد تا اصلاح کند و دوباره بفرستد.';

  @override
  String returnRequested(String qty, String unit) {
    return 'درخواستی: $qty $unit';
  }

  @override
  String returnLess(String item) {
    return 'کمتر – $item';
  }

  @override
  String returnMore(String item) {
    return 'بیشتر – $item';
  }

  @override
  String get returnLineRemove => 'حذف قلم';

  @override
  String get returnLineRemoved => 'این قلم حذف می‌شود.';

  @override
  String get returnLineRestore => 'بازگرداندن قلم';

  @override
  String get returnNoteLabel => 'یادداشت برای درخواست‌کننده (اختیاری)';

  @override
  String get returnNoteHint => 'مثلاً: نصف این مقدار کافی است';

  @override
  String get returnSend => 'ارسال برای اصلاح';

  @override
  String undoReturnPending(String seconds) {
    return 'برگرداندن برای اصلاح – $seconds ثانیه تا ارسال';
  }

  @override
  String get returnedDone => 'برای اصلاح به درخواست‌کننده برگشت داده شد';

  @override
  String returnedBy(String name, String time) {
    return 'برگشت برای اصلاح توسط $name – $time';
  }

  @override
  String returnedLineChange(
    String item,
    String before,
    String after,
    String unit,
  ) {
    return '$item: $before ← $after $unit';
  }

  @override
  String returnedLineRemoved(String item) {
    return '$item: حذف شد';
  }

  @override
  String returnedNote(String note) {
    return 'یادداشت: $note';
  }

  @override
  String conflictReturned(String name) {
    return '$name زودتر این درخواست را برای اصلاح برگرداند. کار شما ثبت نشد.';
  }

  @override
  String get chatInputLabel => 'پیام';

  @override
  String get chatSend => 'فرستادن';

  @override
  String get chatSendFailed => 'فرستاده نشد. برای تلاش دوباره لمس کنید.';

  @override
  String get you => 'شما';

  @override
  String get stockSearchLabel => 'جستجوی کالا';

  @override
  String get stockClearSearch => 'پاک کردن جستجو';

  @override
  String get filterLow => 'کم‌موجود';

  @override
  String get stockEmpty => 'کالایی با این نام پیدا نشد.';

  @override
  String get stockNoLow => 'کالای کم‌موجودی نیست.';

  @override
  String get stockHiddenExplain =>
      'انبار در حال شمارش این کالاست. تا پایان شمارش، موجودی و گردش آن دیده نمی‌شود.';

  @override
  String get movementsTitle => 'ورود و خروج اخیر';

  @override
  String get movementsEmpty => 'گردشی ثبت نشده است.';

  @override
  String get movementIn => 'ورود';

  @override
  String get movementOut => 'خروج';

  @override
  String get movementAdjustDown => 'اصلاح موجودی (کم شد)';

  @override
  String get movementAdjustUp => 'اصلاح موجودی (زیاد شد)';

  @override
  String movementMeta(String date, String document) {
    return '$date – سند $document';
  }

  @override
  String get itemCodeLabel => 'کد';

  @override
  String get assistantSuggestionToday => 'خلاصه امروز';

  @override
  String get assistantSuggestionMonth => 'درخواست‌های این ماه';

  @override
  String get assistantInputLabel => 'سؤال خود را بنویسید';

  @override
  String get assistantHistory => 'گفتگوهای قبلی';

  @override
  String get assistantHistoryEmpty => 'هنوز سؤالی نپرسیده‌اید.';

  @override
  String get assistantThinking => 'در حال آماده کردن پاسخ…';

  @override
  String get assistantFailed => 'پاسخ دریافت نشد؛ دوباره بپرسید';

  @override
  String get assistantEmpty =>
      'درباره درخواست‌ها و موجودی از دستیار کاسپین بپرسید.';

  @override
  String get assistantDemoNote =>
      'نسخه آزمایشی: پاسخ‌ها نمونه‌اند. دستیار واقعی بعد از راه‌اندازی سرور فعال می‌شود.';

  @override
  String get moreReports => 'گزارش‌ها';

  @override
  String get morePurchaseList => 'لیست خرید';

  @override
  String get moreUsers => 'کاربران و دسترسی‌ها';

  @override
  String get moreSettings => 'تنظیمات';

  @override
  String get moreAbout => 'درباره و نسخه';

  @override
  String get comingSoonBadge => 'به‌زودی';

  @override
  String get reportsTitle => 'گزارش‌ها';

  @override
  String get reportByFloor => 'مصرف به تفکیک طبقه';

  @override
  String get reportByLocation => 'مصرف به تفکیک محل';

  @override
  String get periodThisMonth => 'این ماه';

  @override
  String get periodLast30 => '۳۰ روز اخیر';

  @override
  String get periodLast90 => '۹۰ روز اخیر';

  @override
  String reportRange(String from, String to) {
    return 'از $from تا $to';
  }

  @override
  String reportRowTotal(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString قلم';
  }

  @override
  String get reportNoConsumption => 'بدون مصرف';

  @override
  String get reportEmpty => 'در این بازه مصرفی ثبت نشده است.';

  @override
  String get purchaseBody => 'لیست خرید در نسخه‌های بعدی اضافه می‌شود.';

  @override
  String get usersOwner => 'مالک';

  @override
  String get usersYou => 'شما';

  @override
  String get usersNote =>
      'مدیریت کاربران (تأیید، نقش، غیرفعال کردن) از پنل سرور انجام می‌شود.';

  @override
  String get settingsTheme => 'ظاهر';

  @override
  String get themeSystem => 'مطابق گوشی';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

  @override
  String get settingsNotifications => 'اعلان‌ها';

  @override
  String get settingsNotificationsBody => 'خبر درخواست‌های تازه و پیام‌ها';

  @override
  String get backgroundTitle => 'اعلان وقتی برنامه بسته است';

  @override
  String get backgroundBody =>
      'گوشی ممکن است برای صرفه‌جویی در باتری، بررسی درخواست‌های تازه را متوقف کند. موارد زیر را روشن کنید تا اعلان‌ها به‌موقع برسند.';

  @override
  String get backgroundNotifications => 'اجازهٔ نمایش اعلان';

  @override
  String get backgroundBattery => 'بدون محدودیت باتری';

  @override
  String get backgroundAutostart => 'اجرای خودکار (Autostart)';

  @override
  String get backgroundAutostartBody =>
      'در گوشی‌های شیائومی باید دستی روشن شود؛ برنامه وضعیتش را نمی‌بیند.';

  @override
  String get backgroundOn => 'روشن است';

  @override
  String get backgroundOff => 'خاموش است';

  @override
  String get backgroundFix => 'تنظیم';

  @override
  String get settingsFingerprint => 'تأیید با اثر انگشت برای تأیید درخواست';

  @override
  String get settingsFingerprintBody =>
      'قبل از تأیید هر درخواست، یک بار اثر انگشت خواسته می‌شود.';

  @override
  String get settingsSecure => 'جلوگیری از عکس صفحه';

  @override
  String get settingsSecureBody =>
      'در صفحه‌های موجودی و درخواست‌ها، عکس گرفتن از صفحه ممکن نیست.';

  @override
  String get settingsDeviceUnlock => 'باز کردن با اثر انگشت';

  @override
  String get settingsDeviceUnlockBody => 'به‌جای رمز ۴ رقمی برنامه';

  @override
  String get settingsPin => 'رمز برنامه';

  @override
  String get settingsPinBody => 'برای وقتی که اثر انگشت کار نمی‌کند';

  @override
  String get settingsPinSet => 'تعیین یا تغییر رمز';

  @override
  String get settingsPinSaved => 'رمز برنامه ذخیره شد.';

  @override
  String aboutVersion(String version, String build) {
    return 'نسخه $version (ساخت $build)';
  }

  @override
  String aboutMall(String mall) {
    return 'ساخته‌شده برای $mall';
  }

  @override
  String get devUnlocked => 'صفحه توسعه‌دهنده باز شد.';

  @override
  String get devTitle => 'صفحه توسعه‌دهنده';

  @override
  String get devScenario => 'سناریوی داده آزمایشی';

  @override
  String get scenarioNormal => 'عادی';

  @override
  String get scenarioEmpty => 'بدون داده';

  @override
  String get scenarioSlow => 'شبکه کند';

  @override
  String get scenarioServerError => 'خطای سرور';

  @override
  String get scenarioConflict => 'تصمیم هم‌زمان (۴۰۹)';

  @override
  String get scenarioOffline => 'بدون اینترنت';

  @override
  String get devDataSource => 'منبع داده';

  @override
  String devDataSourceValue(String source, String url) {
    return '$source – $url';
  }

  @override
  String get devDebugOnly => 'فقط در نسخه آزمایشی قابل تغییر است.';

  @override
  String get devLogs => 'آخرین خطاها و رویدادها';

  @override
  String get devNoLogs => 'چیزی ثبت نشده است.';

  @override
  String get devExportLogs => 'فرستادن فایل گزارش';

  @override
  String get channelRequests => 'درخواست‌ها';

  @override
  String get channelMessages => 'پیام‌ها';

  @override
  String get updateAvailableTitle => 'نسخه تازه آماده است';

  @override
  String updateVersion(String version) {
    return 'نسخه $version';
  }

  @override
  String get updateLater => 'بعداً';

  @override
  String get updateNow => 'به‌روزرسانی';

  @override
  String get updateRequiredTitle => 'برای ادامه، برنامه را به‌روز کنید';

  @override
  String get updateRequiredBody =>
      'این نسخه دیگر پشتیبانی نمی‌شود. نسخه تازه را نصب کنید؛ اطلاعات شما سر جایش می‌ماند.';

  @override
  String get updateDownloadInstall => 'دانلود و نصب';

  @override
  String updateDownloading(int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return 'در حال دانلود… $percentString٪';
  }

  @override
  String updateSize(String megabytes) {
    return 'حجم: $megabytes مگابایت';
  }

  @override
  String get updatePermissionTitle => 'یک اجازه لازم است';

  @override
  String get updatePermissionBody =>
      'برای نصب به‌روزرسانی، در صفحه بعد گزینه «اجازه از این منبع» را برای مالک کاسپین روشن کنید و برگردید. این کار فقط یک بار لازم است.';

  @override
  String get updateOpenSettings => 'باز کردن تنظیمات';

  @override
  String get updateDownloadFailed =>
      'دانلود کامل نشد. اینترنت را بررسی کنید و دوباره تلاش کنید.';

  @override
  String get updateChecksumFailed =>
      'فایل دانلودشده سالم نبود و پاک شد. دوباره تلاش کنید.';

  @override
  String get aboutCheckUpdate => 'بررسی به‌روزرسانی';

  @override
  String get aboutCheckingUpdate => 'در حال بررسی…';

  @override
  String get aboutUpToDate => 'برنامه به‌روز است.';

  @override
  String get aboutUpdateCheckFailed => 'اطلاعات به‌روزرسانی دریافت نشد.';

  @override
  String get errorTitle => 'اطلاعات دریافت نشد';

  @override
  String get offlineShowingCached =>
      'اتصال برقرار نیست؛ آخرین اطلاعات ذخیره‌شده نمایش داده می‌شود.';
}
