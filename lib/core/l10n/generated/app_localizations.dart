import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fa')];

  /// App name in the task switcher. Keep equal to Brand.appNameFa.
  ///
  /// In fa, this message translates to:
  /// **'مالک کاسپین'**
  String get appTitle;

  /// Button on every error state.
  ///
  /// In fa, this message translates to:
  /// **'تلاش دوباره'**
  String get retry;

  /// Shown above cached data. time is a relative time such as «۱۰ دقیقه پیش».
  ///
  /// In fa, this message translates to:
  /// **'آخرین به‌روزرسانی: {time}'**
  String lastUpdated(String time);

  /// Relative time under one minute.
  ///
  /// In fa, this message translates to:
  /// **'همین الان'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In fa, this message translates to:
  /// **'{count} دقیقه پیش'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In fa, this message translates to:
  /// **'{count} ساعت پیش'**
  String hoursAgo(int count);

  /// Relative time for the previous calendar day.
  ///
  /// In fa, this message translates to:
  /// **'دیروز'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In fa, this message translates to:
  /// **'{count} روز پیش'**
  String daysAgo(int count);

  /// Status chip: waiting for a decision.
  ///
  /// In fa, this message translates to:
  /// **'منتظر'**
  String get statusPending;

  /// Status chip: approved.
  ///
  /// In fa, this message translates to:
  /// **'تأیید شد'**
  String get statusApproved;

  /// Status chip: rejected.
  ///
  /// In fa, this message translates to:
  /// **'رد شد'**
  String get statusRejected;

  /// Status chip: cancelled.
  ///
  /// In fa, this message translates to:
  /// **'لغو شد'**
  String get statusCancelled;

  /// Chip on stock rows that are running low.
  ///
  /// In fa, this message translates to:
  /// **'کم'**
  String get lowStock;

  /// No description provided for @errorNetwork.
  ///
  /// In fa, this message translates to:
  /// **'اتصال برقرار نشد. اینترنت را بررسی کنید.'**
  String get errorNetwork;

  /// No description provided for @errorGeneric.
  ///
  /// In fa, this message translates to:
  /// **'مشکلی پیش آمد. دوباره تلاش کنید.'**
  String get errorGeneric;

  /// No description provided for @tabHome.
  ///
  /// In fa, this message translates to:
  /// **'خانه'**
  String get tabHome;

  /// No description provided for @tabRequests.
  ///
  /// In fa, this message translates to:
  /// **'درخواست‌ها'**
  String get tabRequests;

  /// No description provided for @tabStock.
  ///
  /// In fa, this message translates to:
  /// **'موجودی'**
  String get tabStock;

  /// No description provided for @tabAssistant.
  ///
  /// In fa, this message translates to:
  /// **'دستیار'**
  String get tabAssistant;

  /// No description provided for @requestsTitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست‌ها'**
  String get requestsTitle;

  /// No description provided for @stockTitle.
  ///
  /// In fa, this message translates to:
  /// **'موجودی انبار'**
  String get stockTitle;

  /// No description provided for @assistantTitle.
  ///
  /// In fa, this message translates to:
  /// **'دستیار کاسپین'**
  String get assistantTitle;

  /// No description provided for @moreTitle.
  ///
  /// In fa, this message translates to:
  /// **'بیشتر'**
  String get moreTitle;

  /// No description provided for @logout.
  ///
  /// In fa, this message translates to:
  /// **'خروج'**
  String get logout;

  /// No description provided for @loginTitle.
  ///
  /// In fa, this message translates to:
  /// **'ورود به مالک کاسپین'**
  String get loginTitle;

  /// No description provided for @loginPhoneLabel.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل'**
  String get loginPhoneLabel;

  /// No description provided for @loginPhoneHint.
  ///
  /// In fa, this message translates to:
  /// **'۰۹۱۲۳۴۵۶۷۸۹'**
  String get loginPhoneHint;

  /// No description provided for @loginPhoneHelp.
  ///
  /// In fa, this message translates to:
  /// **'یک کد با پیامک برایتان فرستاده می‌شود.'**
  String get loginPhoneHelp;

  /// No description provided for @loginPhoneInvalid.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل باید ۱۱ رقم باشد و با ۰۹ شروع شود.'**
  String get loginPhoneInvalid;

  /// No description provided for @loginSendCode.
  ///
  /// In fa, this message translates to:
  /// **'دریافت کد'**
  String get loginSendCode;

  /// No description provided for @loginCodeLabel.
  ///
  /// In fa, this message translates to:
  /// **'کد پیامک‌شده'**
  String get loginCodeLabel;

  /// No description provided for @loginCodeSent.
  ///
  /// In fa, this message translates to:
  /// **'کد {length} رقمی به {phone} فرستاده شد.'**
  String loginCodeSent(int length, String phone);

  /// No description provided for @loginVerify.
  ///
  /// In fa, this message translates to:
  /// **'ورود'**
  String get loginVerify;

  /// No description provided for @loginChangePhone.
  ///
  /// In fa, this message translates to:
  /// **'تغییر شماره'**
  String get loginChangePhone;

  /// No description provided for @loginResend.
  ///
  /// In fa, this message translates to:
  /// **'ارسال دوباره کد'**
  String get loginResend;

  /// No description provided for @loginResendIn.
  ///
  /// In fa, this message translates to:
  /// **'ارسال دوباره تا {seconds} ثانیه'**
  String loginResendIn(int seconds);

  /// No description provided for @loginTestCodeHint.
  ///
  /// In fa, this message translates to:
  /// **'نسخه آزمایشی: کد ۱۱۱۱۱'**
  String get loginTestCodeHint;

  /// No description provided for @lockTitle.
  ///
  /// In fa, this message translates to:
  /// **'برنامه قفل است'**
  String get lockTitle;

  /// No description provided for @lockBody.
  ///
  /// In fa, this message translates to:
  /// **'برای دیدن اطلاعات، هویت خود را تأیید کنید.'**
  String get lockBody;

  /// No description provided for @lockUnlockDevice.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن با اثر انگشت'**
  String get lockUnlockDevice;

  /// No description provided for @lockReason.
  ///
  /// In fa, this message translates to:
  /// **'برای باز کردن مالک کاسپین هویت خود را تأیید کنید'**
  String get lockReason;

  /// No description provided for @lockUsePin.
  ///
  /// In fa, this message translates to:
  /// **'ورود با رمز برنامه'**
  String get lockUsePin;

  /// No description provided for @pinLabel.
  ///
  /// In fa, this message translates to:
  /// **'رمز برنامه'**
  String get pinLabel;

  /// No description provided for @pinWrong.
  ///
  /// In fa, this message translates to:
  /// **'رمز درست نیست. {left} بار دیگر می‌توانید امتحان کنید.'**
  String pinWrong(int left);

  /// No description provided for @pinSetupTitle.
  ///
  /// In fa, this message translates to:
  /// **'ساختن رمز برنامه'**
  String get pinSetupTitle;

  /// No description provided for @pinSetupBody.
  ///
  /// In fa, this message translates to:
  /// **'این گوشی قفل اثر انگشت یا رمز ندارد. برای حفاظت از اطلاعات، یک رمز ۴ رقمی برای برنامه بسازید.'**
  String get pinSetupBody;

  /// No description provided for @pinRepeatLabel.
  ///
  /// In fa, this message translates to:
  /// **'تکرار رمز'**
  String get pinRepeatLabel;

  /// No description provided for @pinTooShort.
  ///
  /// In fa, this message translates to:
  /// **'رمز باید ۴ رقم باشد.'**
  String get pinTooShort;

  /// No description provided for @pinMismatch.
  ///
  /// In fa, this message translates to:
  /// **'دو رمز یکی نیستند.'**
  String get pinMismatch;

  /// No description provided for @pinSave.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره رمز'**
  String get pinSave;

  /// No description provided for @signedOutTooManyAttempts.
  ///
  /// In fa, this message translates to:
  /// **'به‌خاطر چند رمز اشتباه، دوباره وارد شوید.'**
  String get signedOutTooManyAttempts;

  /// No description provided for @homeGreeting.
  ///
  /// In fa, this message translates to:
  /// **'سلام {name}'**
  String homeGreeting(String name);

  /// No description provided for @notificationsTooltip.
  ///
  /// In fa, this message translates to:
  /// **'اعلان‌ها'**
  String get notificationsTooltip;

  /// No description provided for @accountTooltip.
  ///
  /// In fa, this message translates to:
  /// **'حساب و گزینه‌های بیشتر'**
  String get accountTooltip;

  /// No description provided for @cancel.
  ///
  /// In fa, this message translates to:
  /// **'انصراف'**
  String get cancel;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In fa, this message translates to:
  /// **'از حساب خارج می‌شوید؟'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات ذخیره‌شده روی این گوشی پاک می‌شود. برای ورود دوباره، کد پیامکی لازم است.'**
  String get logoutConfirmBody;

  /// No description provided for @comingSoon.
  ///
  /// In fa, this message translates to:
  /// **'این بخش به‌زودی آماده می‌شود.'**
  String get comingSoon;

  /// No description provided for @homePendingTitle.
  ///
  /// In fa, this message translates to:
  /// **'منتظر تأیید شما'**
  String get homePendingTitle;

  /// No description provided for @homePendingCount.
  ///
  /// In fa, this message translates to:
  /// **'{count} درخواست'**
  String homePendingCount(int count);

  /// No description provided for @homeReviewRequests.
  ///
  /// In fa, this message translates to:
  /// **'بررسی درخواست‌ها'**
  String get homeReviewRequests;

  /// No description provided for @homeAllReviewed.
  ///
  /// In fa, this message translates to:
  /// **'همه درخواست‌ها بررسی شده‌اند'**
  String get homeAllReviewed;

  /// No description provided for @homeAllReviewedBody.
  ///
  /// In fa, this message translates to:
  /// **'درخواستی منتظر تأیید شما نیست.'**
  String get homeAllReviewedBody;

  /// No description provided for @homeLatestRequests.
  ///
  /// In fa, this message translates to:
  /// **'آخرین درخواست‌ها'**
  String get homeLatestRequests;

  /// No description provided for @homeNoRequests.
  ///
  /// In fa, this message translates to:
  /// **'هنوز درخواستی ثبت نشده است.'**
  String get homeNoRequests;

  /// No description provided for @countCardTitle.
  ///
  /// In fa, this message translates to:
  /// **'شمارش غافلگیرانه'**
  String get countCardTitle;

  /// No description provided for @countLastTime.
  ///
  /// In fa, this message translates to:
  /// **'آخرین بار: {date}'**
  String countLastTime(String date);

  /// No description provided for @countNever.
  ///
  /// In fa, this message translates to:
  /// **'هنوز شمارشی انجام نشده است.'**
  String get countNever;

  /// No description provided for @countRunningNow.
  ///
  /// In fa, this message translates to:
  /// **'یک شمارش در حال انجام است'**
  String get countRunningNow;

  /// No description provided for @countStart.
  ///
  /// In fa, this message translates to:
  /// **'شروع'**
  String get countStart;

  /// No description provided for @requestLineTitle.
  ///
  /// In fa, this message translates to:
  /// **'{item} · {qty} {unit}'**
  String requestLineTitle(String item, String qty, String unit);

  /// No description provided for @requestMoreItems.
  ///
  /// In fa, this message translates to:
  /// **'و {count} قلم دیگر'**
  String requestMoreItems(int count);

  /// No description provided for @senderAndTime.
  ///
  /// In fa, this message translates to:
  /// **'{sender} · {time}'**
  String senderAndTime(String sender, String time);

  /// No description provided for @errorTitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات دریافت نشد'**
  String get errorTitle;

  /// No description provided for @offlineShowingCached.
  ///
  /// In fa, this message translates to:
  /// **'اتصال برقرار نیست؛ آخرین اطلاعات ذخیره‌شده نمایش داده می‌شود.'**
  String get offlineShowingCached;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
