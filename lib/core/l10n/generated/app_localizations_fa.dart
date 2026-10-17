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
  String moreRoleAdmin(String owner, String admin) {
    return '$owner – $admin';
  }

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
      'اطلاعات ذخیره‌شده روی این گوشی پاک می‌شود. برای ورود دوباره، کد پیامکی لازم است.';

  @override
  String get comingSoon => 'این بخش به‌زودی آماده می‌شود.';

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
  String get rejectReasonLabel => 'دلیل (اختیاری)';

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
  String get chatTitle => 'گفتگو درباره این درخواست';

  @override
  String get chatEmpty => 'هنوز پیامی نیست.';

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
  String get usersAdmin => 'مدیر سیستم';

  @override
  String get usersOwner => 'مالک';

  @override
  String get usersYou => 'شما';

  @override
  String get usersNote =>
      'افزودن، حذف و تعیین دسترسی کاربران بعد از راه‌اندازی سرور فعال می‌شود.';

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
