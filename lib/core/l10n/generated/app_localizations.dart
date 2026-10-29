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

  /// No description provided for @statusIssued.
  ///
  /// In fa, this message translates to:
  /// **'حواله صادر شد'**
  String get statusIssued;

  /// No description provided for @statusUnknown.
  ///
  /// In fa, this message translates to:
  /// **'نامشخص'**
  String get statusUnknown;

  /// No description provided for @decidedByYou.
  ///
  /// In fa, this message translates to:
  /// **'شما'**
  String get decidedByYou;

  /// No description provided for @decidedByAnotherOwner.
  ///
  /// In fa, this message translates to:
  /// **'یکی از مالکان'**
  String get decidedByAnotherOwner;

  /// No description provided for @issuedBanner.
  ///
  /// In fa, this message translates to:
  /// **'حواله صادر شد – شماره {number}'**
  String issuedBanner(String number);

  /// No description provided for @issuedBannerNoNumber.
  ///
  /// In fa, this message translates to:
  /// **'حواله صادر شد'**
  String get issuedBannerNoNumber;

  /// No description provided for @unknownStatusBanner.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت این درخواست برای این نسخه از برنامه شناخته‌شده نیست. برنامه را به‌روز کنید.'**
  String get unknownStatusBanner;

  /// No description provided for @rejectReasonHelper.
  ///
  /// In fa, this message translates to:
  /// **'دست‌کم ۳ حرف بنویسید. انبار این دلیل را می‌بیند.'**
  String get rejectReasonHelper;

  /// No description provided for @decisionFailed.
  ///
  /// In fa, this message translates to:
  /// **'تصمیم درخواست {number} ثبت نشد: {reason}'**
  String decisionFailed(String number, String reason);

  /// No description provided for @errorWidgetTitle.
  ///
  /// In fa, this message translates to:
  /// **'این بخش درست نمایش داده نشد'**
  String get errorWidgetTitle;

  /// No description provided for @errorWidgetBody.
  ///
  /// In fa, this message translates to:
  /// **'مشکل ثبت شد. برگردید و دوباره امتحان کنید.'**
  String get errorWidgetBody;

  /// No description provided for @errorWidgetBack.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت'**
  String get errorWidgetBack;

  /// No description provided for @roleAdmin.
  ///
  /// In fa, this message translates to:
  /// **'مدیر سیستم (ادمین)'**
  String get roleAdmin;

  /// No description provided for @roleWarehouse.
  ///
  /// In fa, this message translates to:
  /// **'انبار'**
  String get roleWarehouse;

  /// No description provided for @roleUnassigned.
  ///
  /// In fa, this message translates to:
  /// **'نقش تعیین نشده'**
  String get roleUnassigned;

  /// No description provided for @usersActive.
  ///
  /// In fa, this message translates to:
  /// **'فعال'**
  String get usersActive;

  /// No description provided for @usersInactive.
  ///
  /// In fa, this message translates to:
  /// **'غیرفعال'**
  String get usersInactive;

  /// No description provided for @usersApprovalPending.
  ///
  /// In fa, this message translates to:
  /// **'منتظر تأیید'**
  String get usersApprovalPending;

  /// No description provided for @usersApprovalRejected.
  ///
  /// In fa, this message translates to:
  /// **'رد شده'**
  String get usersApprovalRejected;

  /// No description provided for @usersPendingSection.
  ///
  /// In fa, this message translates to:
  /// **'منتظر تأیید مدیر'**
  String get usersPendingSection;

  /// No description provided for @usersAllSection.
  ///
  /// In fa, this message translates to:
  /// **'همه کاربران'**
  String get usersAllSection;

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

  /// No description provided for @statusReturned.
  ///
  /// In fa, this message translates to:
  /// **'برگشت برای اصلاح'**
  String get statusReturned;

  /// Chip on stock rows that are running low.
  ///
  /// In fa, this message translates to:
  /// **'کم'**
  String get lowStock;

  /// Timeout, refused connection or TLS failure: the phone is online but the server did not answer.
  ///
  /// In fa, this message translates to:
  /// **'سرور کاسپین جواب نداد. کمی بعد دوباره امتحان کنید.'**
  String get errorNetwork;

  /// The server's name could not be looked up: the phone has no internet.
  ///
  /// In fa, this message translates to:
  /// **'اینترنت گوشی وصل نیست. وای‌فای یا اینترنت همراه را روشن کنید.'**
  String get errorOffline;

  /// 429 without a server message.
  ///
  /// In fa, this message translates to:
  /// **'تعداد تلاش‌ها زیاد شد. کمی بعد دوباره امتحان کنید.'**
  String get errorTooManyRequests;

  /// No description provided for @errorGeneric.
  ///
  /// In fa, this message translates to:
  /// **'مشکلی پیش آمد. دوباره تلاش کنید.'**
  String get errorGeneric;

  /// 401 at login.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل یا رمز عبور اشتباه است.'**
  String get errorWrongPassword;

  /// 401 after login: token expired or revoked.
  ///
  /// In fa, this message translates to:
  /// **'نشست شما تمام شد. دوباره وارد شوید.'**
  String get errorSessionExpired;

  /// 403.
  ///
  /// In fa, this message translates to:
  /// **'شما اجازهٔ انجام این کار را ندارید.'**
  String get errorForbidden;

  /// 409: already approved/rejected.
  ///
  /// In fa, this message translates to:
  /// **'این درخواست قبلاً تأیید یا رد شده است.'**
  String get errorConflict;

  /// 422.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات واردشده معتبر نیست. دوباره بررسی کنید.'**
  String get errorInvalidData;

  /// No description provided for @errorNotFound.
  ///
  /// In fa, this message translates to:
  /// **'این مورد پیدا نشد.'**
  String get errorNotFound;

  /// 5xx or a broken answer.
  ///
  /// In fa, this message translates to:
  /// **'خطای سرور. کمی بعد دوباره تلاش کنید.'**
  String get errorServer;

  /// No description provided for @errorMobileTaken.
  ///
  /// In fa, this message translates to:
  /// **'این شماره قبلاً ثبت شده؛ وارد شوید یا از فراموشی رمز استفاده کنید.'**
  String get errorMobileTaken;

  /// No description provided for @errorAccountNotFound.
  ///
  /// In fa, this message translates to:
  /// **'حسابی با این شماره پیدا نشد. اول ثبت‌نام کنید.'**
  String get errorAccountNotFound;

  /// No description provided for @errorSmsNotSent.
  ///
  /// In fa, this message translates to:
  /// **'پیامک فرستاده نشد. چند دقیقه دیگر دوباره امتحان کنید.'**
  String get errorSmsNotSent;

  /// Login with a warehouse account.
  ///
  /// In fa, this message translates to:
  /// **'این حساب برای اپ مالکان نیست.'**
  String get errorNotOwner;

  /// No description provided for @errorNotConnected.
  ///
  /// In fa, this message translates to:
  /// **'این بخش هنوز به سرور وصل نشده است.'**
  String get errorNotConnected;

  /// Stock, assistant, reports, notifications list while the server has no API for them.
  ///
  /// In fa, this message translates to:
  /// **'این بخش هنوز به سرور کاسپین وصل نشده است و به‌زودی اضافه می‌شود.'**
  String get notConnectedBody;

  /// No description provided for @notConnectedTitle.
  ///
  /// In fa, this message translates to:
  /// **'به‌زودی'**
  String get notConnectedTitle;

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

  /// No description provided for @loginUsernameLabel.
  ///
  /// In fa, this message translates to:
  /// **'نام کاربری'**
  String get loginUsernameLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور'**
  String get loginPasswordLabel;

  /// No description provided for @loginShowPassword.
  ///
  /// In fa, this message translates to:
  /// **'نمایش رمز'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In fa, this message translates to:
  /// **'پنهان کردن رمز'**
  String get loginHidePassword;

  /// No description provided for @loginFieldsRequired.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل و رمز عبور را وارد کنید.'**
  String get loginFieldsRequired;

  /// No description provided for @loginVerify.
  ///
  /// In fa, this message translates to:
  /// **'ورود'**
  String get loginVerify;

  /// No description provided for @loginTestPasswordHint.
  ///
  /// In fa, this message translates to:
  /// **'نسخه آزمایشی: رمز ۱۱۱۱۱'**
  String get loginTestPasswordHint;

  /// No description provided for @loginServer.
  ///
  /// In fa, this message translates to:
  /// **'سرور: {url}'**
  String loginServer(String url);

  /// No description provided for @loginChangeServer.
  ///
  /// In fa, this message translates to:
  /// **'تغییر آدرس سرور'**
  String get loginChangeServer;

  /// No description provided for @loginMobileLabel.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل'**
  String get loginMobileLabel;

  /// No description provided for @loginMobileHint.
  ///
  /// In fa, this message translates to:
  /// **'مثل ۰۹۱۲۳۴۵۶۷۸۹'**
  String get loginMobileHint;

  /// For admin accounts that have a username instead of a mobile.
  ///
  /// In fa, this message translates to:
  /// **'ورود با نام کاربری'**
  String get loginUseUsername;

  /// No description provided for @loginUseMobile.
  ///
  /// In fa, this message translates to:
  /// **'ورود با شماره موبایل'**
  String get loginUseMobile;

  /// After too many wrong passwords: the button waits, showing the time left.
  ///
  /// In fa, this message translates to:
  /// **'ورود ({time})'**
  String loginWaitButton(String time);

  /// No description provided for @loginForgot.
  ///
  /// In fa, this message translates to:
  /// **'رمز را فراموش کرده‌ام'**
  String get loginForgot;

  /// No description provided for @loginNoAccount.
  ///
  /// In fa, this message translates to:
  /// **'حساب ندارید؟'**
  String get loginNoAccount;

  /// No description provided for @loginRegister.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌نام مالک جدید'**
  String get loginRegister;

  /// No description provided for @loginRegisteredNotice.
  ///
  /// In fa, this message translates to:
  /// **'درخواست ثبت‌نام شما ثبت شد. بعد از تأیید مدیر، با همین شماره و رمز وارد شوید.'**
  String get loginRegisteredNotice;

  /// No description provided for @loginPasswordResetNotice.
  ///
  /// In fa, this message translates to:
  /// **'رمز تازه ذخیره شد. با رمز تازه وارد شوید.'**
  String get loginPasswordResetNotice;

  /// No description provided for @mobileInvalid.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل درست نیست. ۱۱ رقم است و با ۰۹ شروع می‌شود.'**
  String get mobileInvalid;

  /// Persian digits are passed in.
  ///
  /// In fa, this message translates to:
  /// **'مرحله {step} از {total}'**
  String stepOf(String step, String total);

  /// No description provided for @sendCode.
  ///
  /// In fa, this message translates to:
  /// **'ارسال کد'**
  String get sendCode;

  /// No description provided for @backToLogin.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت به صفحه ورود'**
  String get backToLogin;

  /// No description provided for @registerTitle.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌نام مالک جدید'**
  String get registerTitle;

  /// No description provided for @registerBody.
  ///
  /// In fa, this message translates to:
  /// **'نام و شماره موبایل خود را بنویسید. یک کد ۶ رقمی برایتان پیامک می‌شود.'**
  String get registerBody;

  /// No description provided for @registerFirstName.
  ///
  /// In fa, this message translates to:
  /// **'نام'**
  String get registerFirstName;

  /// No description provided for @registerLastName.
  ///
  /// In fa, this message translates to:
  /// **'نام خانوادگی'**
  String get registerLastName;

  /// No description provided for @nameInvalid.
  ///
  /// In fa, this message translates to:
  /// **'با حروف فارسی بنویسید (۲ تا ۵۰ حرف).'**
  String get nameInvalid;

  /// No description provided for @registerHaveAccount.
  ///
  /// In fa, this message translates to:
  /// **'قبلاً ثبت‌نام کرده‌اید؟ ورود'**
  String get registerHaveAccount;

  /// No description provided for @registerSubmit.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌نام'**
  String get registerSubmit;

  /// No description provided for @forgotTitle.
  ///
  /// In fa, this message translates to:
  /// **'فراموشی رمز عبور'**
  String get forgotTitle;

  /// No description provided for @forgotBody.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایلی را که با آن ثبت‌نام کرده‌اید بنویسید. یک کد ۶ رقمی برایتان پیامک می‌شود.'**
  String get forgotBody;

  /// No description provided for @otpTitle.
  ///
  /// In fa, this message translates to:
  /// **'کد پیامک‌شده را بنویسید'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In fa, this message translates to:
  /// **'کد ۶ رقمی به شماره {mobile} پیامک شد.'**
  String otpSentTo(String mobile);

  /// No description provided for @otpLabel.
  ///
  /// In fa, this message translates to:
  /// **'کد ۶ رقمی'**
  String get otpLabel;

  /// Android's SMS User Consent dialog asks once to read that one SMS.
  ///
  /// In fa, this message translates to:
  /// **'اگر گوشی اجازه خواست، «اجازه دادن» را بزنید تا کد خودش نوشته شود.'**
  String get otpAutoFillNote;

  /// No description provided for @otpChangeMobile.
  ///
  /// In fa, this message translates to:
  /// **'تغییر شماره'**
  String get otpChangeMobile;

  /// No description provided for @otpVerify.
  ///
  /// In fa, this message translates to:
  /// **'تأیید کد'**
  String get otpVerify;

  /// No description provided for @otpResendIn.
  ///
  /// In fa, this message translates to:
  /// **'ارسال دوباره کد تا {time} دیگر'**
  String otpResendIn(String time);

  /// No description provided for @otpResend.
  ///
  /// In fa, this message translates to:
  /// **'ارسال دوباره کد'**
  String get otpResend;

  /// No description provided for @otpResent.
  ///
  /// In fa, this message translates to:
  /// **'کد تازه فرستاده شد.'**
  String get otpResent;

  /// No description provided for @otpTooShort.
  ///
  /// In fa, this message translates to:
  /// **'کد ۶ رقم است.'**
  String get otpTooShort;

  /// No description provided for @passwordCreateTitle.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور بسازید'**
  String get passwordCreateTitle;

  /// No description provided for @passwordResetTitle.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور تازه بسازید'**
  String get passwordResetTitle;

  /// No description provided for @passwordChangeTitle.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور خودتان را بسازید'**
  String get passwordChangeTitle;

  /// No description provided for @passwordBody.
  ///
  /// In fa, this message translates to:
  /// **'رمزی بسازید که یادتان بماند و دیگران نتوانند حدس بزنند.'**
  String get passwordBody;

  /// No description provided for @passwordChangeBody.
  ///
  /// In fa, this message translates to:
  /// **'رمزی که مدیر به شما داده موقت است. یک رمز تازه بسازید که فقط خودتان بدانید.'**
  String get passwordChangeBody;

  /// No description provided for @passwordNewLabel.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور تازه'**
  String get passwordNewLabel;

  /// No description provided for @passwordRepeatLabel.
  ///
  /// In fa, this message translates to:
  /// **'تکرار رمز عبور'**
  String get passwordRepeatLabel;

  /// No description provided for @passwordRuleLength.
  ///
  /// In fa, this message translates to:
  /// **'دست‌کم ۸ حرف یا عدد'**
  String get passwordRuleLength;

  /// No description provided for @passwordRuleDistinct.
  ///
  /// In fa, this message translates to:
  /// **'دست‌کم ۴ حرف یا عدد متفاوت'**
  String get passwordRuleDistinct;

  /// No description provided for @passwordRuleOk.
  ///
  /// In fa, this message translates to:
  /// **'انجام شد'**
  String get passwordRuleOk;

  /// No description provided for @passwordRuleNotYet.
  ///
  /// In fa, this message translates to:
  /// **'هنوز نه'**
  String get passwordRuleNotYet;

  /// No description provided for @passwordTooLong.
  ///
  /// In fa, this message translates to:
  /// **'رمز خیلی بلند است. کوتاه‌ترش کنید.'**
  String get passwordTooLong;

  /// No description provided for @passwordTooCommon.
  ///
  /// In fa, this message translates to:
  /// **'این رمز خیلی ساده و رایج است. رمز دیگری بسازید.'**
  String get passwordTooCommon;

  /// No description provided for @passwordMismatch.
  ///
  /// In fa, this message translates to:
  /// **'دو رمز یکی نیستند.'**
  String get passwordMismatch;

  /// No description provided for @resetSubmit.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره رمز تازه'**
  String get resetSubmit;

  /// No description provided for @changeSubmit.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره و ورود'**
  String get changeSubmit;

  /// No description provided for @flowRestart.
  ///
  /// In fa, this message translates to:
  /// **'از اول شروع کنید'**
  String get flowRestart;

  /// No description provided for @flowExpiredTitle.
  ///
  /// In fa, this message translates to:
  /// **'مهلت تمام شد'**
  String get flowExpiredTitle;

  /// No description provided for @flowExpired.
  ///
  /// In fa, this message translates to:
  /// **'مهلت این مرحله تمام شده است. لطفاً از اول شروع کنید.'**
  String get flowExpired;

  /// No description provided for @accountRegisteredTitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست شما ثبت شد'**
  String get accountRegisteredTitle;

  /// No description provided for @accountRegisteredBody.
  ///
  /// In fa, this message translates to:
  /// **'مدیر کاسپین باید حساب شما را تأیید کند. بعد از تأیید، با همین شماره موبایل و رمز وارد شوید.'**
  String get accountRegisteredBody;

  /// No description provided for @accountPendingTitle.
  ///
  /// In fa, this message translates to:
  /// **'حساب شما منتظر تأیید است'**
  String get accountPendingTitle;

  /// No description provided for @accountPendingBody.
  ///
  /// In fa, this message translates to:
  /// **'مدیر کاسپین هنوز حساب شما را تأیید نکرده است. بعد از تأیید دوباره وارد شوید.'**
  String get accountPendingBody;

  /// No description provided for @accountRejectedTitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست ثبت‌نام تأیید نشد'**
  String get accountRejectedTitle;

  /// No description provided for @accountRejectedBody.
  ///
  /// In fa, this message translates to:
  /// **'مدیر کاسپین این حساب را تأیید نکرد. برای اطلاعات بیشتر با مدیر تماس بگیرید.'**
  String get accountRejectedBody;

  /// No description provided for @accountDisabledTitle.
  ///
  /// In fa, this message translates to:
  /// **'حساب شما غیرفعال است'**
  String get accountDisabledTitle;

  /// No description provided for @accountDisabledBody.
  ///
  /// In fa, this message translates to:
  /// **'مدیر کاسپین این حساب را غیرفعال کرده است. با مدیر تماس بگیرید.'**
  String get accountDisabledBody;

  /// No description provided for @unlockOfferTitle.
  ///
  /// In fa, this message translates to:
  /// **'ورود سریع با اثر انگشت؟'**
  String get unlockOfferTitle;

  /// No description provided for @unlockOfferBody.
  ///
  /// In fa, this message translates to:
  /// **'از این به بعد برنامه با اثر انگشت (یا قفل گوشی) باز می‌شود و لازم نیست هر بار رمز بزنید. رمز عبور شما عوض نمی‌شود.'**
  String get unlockOfferBody;

  /// No description provided for @unlockOfferYes.
  ///
  /// In fa, this message translates to:
  /// **'بله، فعال شود'**
  String get unlockOfferYes;

  /// No description provided for @unlockOfferNo.
  ///
  /// In fa, this message translates to:
  /// **'فعلاً نه'**
  String get unlockOfferNo;

  /// No description provided for @unlockOfferNoNote.
  ///
  /// In fa, this message translates to:
  /// **'اگر نخواهید، یک رمز ۴ رقمی برای باز کردن برنامه می‌سازید.'**
  String get unlockOfferNoNote;

  /// No description provided for @unlockOfferReason.
  ///
  /// In fa, this message translates to:
  /// **'برای فعال کردن ورود با اثر انگشت، انگشت خود را روی حسگر بگذارید'**
  String get unlockOfferReason;

  /// No description provided for @unlockOfferFailed.
  ///
  /// In fa, this message translates to:
  /// **'اثر انگشت تأیید نشد. دوباره امتحان کنید.'**
  String get unlockOfferFailed;

  /// No description provided for @serverTitle.
  ///
  /// In fa, this message translates to:
  /// **'آدرس سرور'**
  String get serverTitle;

  /// No description provided for @serverHelp.
  ///
  /// In fa, this message translates to:
  /// **'مثال: http://192.168.10.58:8000 (روی وای‌فای پاساژ) یا یک آدرس https.'**
  String get serverHelp;

  /// No description provided for @serverChangeSignsOut.
  ///
  /// In fa, this message translates to:
  /// **'با تغییر آدرس سرور، از حساب خارج می‌شوید و باید دوباره وارد شوید.'**
  String get serverChangeSignsOut;

  /// No description provided for @serverInvalid.
  ///
  /// In fa, this message translates to:
  /// **'آدرس درست نیست. مثال: http://192.168.10.58:8000'**
  String get serverInvalid;

  /// No description provided for @serverNeedsHttps.
  ///
  /// In fa, this message translates to:
  /// **'برای آدرس‌های اینترنتی فقط https مجاز است.'**
  String get serverNeedsHttps;

  /// No description provided for @serverTest.
  ///
  /// In fa, this message translates to:
  /// **'آزمایش اتصال'**
  String get serverTest;

  /// No description provided for @serverTestOk.
  ///
  /// In fa, this message translates to:
  /// **'اتصال برقرار است.'**
  String get serverTestOk;

  /// No description provided for @serverSave.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره'**
  String get serverSave;

  /// No description provided for @serverSaved.
  ///
  /// In fa, this message translates to:
  /// **'آدرس سرور ذخیره شد.'**
  String get serverSaved;

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

  /// On the lock screen: log out and log in again with the server password.
  ///
  /// In fa, this message translates to:
  /// **'ورود با رمز عبور'**
  String get lockUsePassword;

  /// No description provided for @authPromptTitle.
  ///
  /// In fa, this message translates to:
  /// **'تأیید هویت'**
  String get authPromptTitle;

  /// No description provided for @authPromptHint.
  ///
  /// In fa, this message translates to:
  /// **'با اثر انگشت یا قفل گوشی'**
  String get authPromptHint;

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

  /// No description provided for @signedOutSessionExpired.
  ///
  /// In fa, this message translates to:
  /// **'نشست شما تمام شد. دوباره وارد شوید.'**
  String get signedOutSessionExpired;

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

  /// No description provided for @notificationsTitle.
  ///
  /// In fa, this message translates to:
  /// **'اعلان‌ها'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In fa, this message translates to:
  /// **'در ۳۰ روز گذشته اعلانی نبوده است.'**
  String get notificationsEmpty;

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
  /// **'اطلاعات ذخیره‌شده روی این گوشی پاک می‌شود. برای ورود دوباره، نام کاربری و رمز عبور لازم است.'**
  String get logoutConfirmBody;

  /// No description provided for @comingSoon.
  ///
  /// In fa, this message translates to:
  /// **'این بخش به‌زودی آماده می‌شود.'**
  String get comingSoon;

  /// No description provided for @backToHub.
  ///
  /// In fa, this message translates to:
  /// **'همه بخش‌های کاسپین'**
  String get backToHub;

  /// No description provided for @hubPendingBadge.
  ///
  /// In fa, this message translates to:
  /// **'{count} منتظر'**
  String hubPendingBadge(String count);

  /// No description provided for @moduleWarehouse.
  ///
  /// In fa, this message translates to:
  /// **'انبار'**
  String get moduleWarehouse;

  /// No description provided for @moduleWarehouseSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست‌ها، موجودی و دستیار'**
  String get moduleWarehouseSubtitle;

  /// No description provided for @moduleParking.
  ///
  /// In fa, this message translates to:
  /// **'پارکینگ'**
  String get moduleParking;

  /// No description provided for @moduleParkingSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'ورود و خروج و جای پارک'**
  String get moduleParkingSubtitle;

  /// No description provided for @moduleCrm.
  ///
  /// In fa, this message translates to:
  /// **'CRM'**
  String get moduleCrm;

  /// No description provided for @moduleCrmSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'مشتریان و پیگیری‌ها'**
  String get moduleCrmSubtitle;

  /// No description provided for @moduleServices.
  ///
  /// In fa, this message translates to:
  /// **'خدمات کاسپین'**
  String get moduleServices;

  /// No description provided for @moduleServicesSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'تعمیرات و خدمات مجتمع'**
  String get moduleServicesSubtitle;

  /// No description provided for @moduleComingSoonTitle.
  ///
  /// In fa, this message translates to:
  /// **'{name} به‌زودی'**
  String moduleComingSoonTitle(String name);

  /// No description provided for @moduleComingSoonBody.
  ///
  /// In fa, this message translates to:
  /// **'این بخش هنوز ساخته نشده است. وقتی آماده شود، اینجا بخشی از آن برای شما باز می‌شود: تأییدها، گزارش کلی و گفتگو.'**
  String get moduleComingSoonBody;

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

  /// No description provided for @requestLineTitle.
  ///
  /// In fa, this message translates to:
  /// **'{item} – {qty} {unit}'**
  String requestLineTitle(String item, String qty, String unit);

  /// No description provided for @requestMoreItems.
  ///
  /// In fa, this message translates to:
  /// **'و {count} قلم دیگر'**
  String requestMoreItems(int count);

  /// No description provided for @senderAndTime.
  ///
  /// In fa, this message translates to:
  /// **'{sender} – {time}'**
  String senderAndTime(String sender, String time);

  /// No description provided for @filterPending.
  ///
  /// In fa, this message translates to:
  /// **'منتظر ({count})'**
  String filterPending(int count);

  /// No description provided for @filterReviewed.
  ///
  /// In fa, this message translates to:
  /// **'بررسی‌شده'**
  String get filterReviewed;

  /// No description provided for @filterAll.
  ///
  /// In fa, this message translates to:
  /// **'همه'**
  String get filterAll;

  /// No description provided for @requestsEmptyPending.
  ///
  /// In fa, this message translates to:
  /// **'درخواستی منتظر تأیید شما نیست.'**
  String get requestsEmptyPending;

  /// No description provided for @requestsEmptyReviewed.
  ///
  /// In fa, this message translates to:
  /// **'هنوز درخواستی بررسی نشده است.'**
  String get requestsEmptyReviewed;

  /// No description provided for @requestsEmptyAll.
  ///
  /// In fa, this message translates to:
  /// **'هنوز درخواستی ثبت نشده است.'**
  String get requestsEmptyAll;

  /// No description provided for @queuedLabel.
  ///
  /// In fa, this message translates to:
  /// **'در صف ارسال'**
  String get queuedLabel;

  /// No description provided for @managerLabel.
  ///
  /// In fa, this message translates to:
  /// **'مدیر انبار'**
  String get managerLabel;

  /// No description provided for @requestTitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست {number}'**
  String requestTitle(String number);

  /// No description provided for @requestFrom.
  ///
  /// In fa, this message translates to:
  /// **'از طرف {sender} – {time}'**
  String requestFrom(String sender, String time);

  /// No description provided for @placeLabel.
  ///
  /// In fa, this message translates to:
  /// **'محل مصرف'**
  String get placeLabel;

  /// No description provided for @stockNow.
  ///
  /// In fa, this message translates to:
  /// **'موجودی فعلی'**
  String get stockNow;

  /// No description provided for @usedLastMonth.
  ///
  /// In fa, this message translates to:
  /// **'مصرف ماه قبل'**
  String get usedLastMonth;

  /// No description provided for @hiddenByCount.
  ///
  /// In fa, this message translates to:
  /// **'در حال شمارش در انبار'**
  String get hiddenByCount;

  /// No description provided for @qtyWithUnit.
  ///
  /// In fa, this message translates to:
  /// **'{qty} {unit}'**
  String qtyWithUnit(String qty, String unit);

  /// No description provided for @noteLabel.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت'**
  String get noteLabel;

  /// No description provided for @routineRequestNote.
  ///
  /// In fa, this message translates to:
  /// **'این درخواست عادی است و مدیر انبار درباره آن تصمیم می‌گیرد.'**
  String get routineRequestNote;

  /// No description provided for @decidedApprovedBy.
  ///
  /// In fa, this message translates to:
  /// **'تأیید شد توسط {name} – {time}'**
  String decidedApprovedBy(String name, String time);

  /// No description provided for @decidedRejectedBy.
  ///
  /// In fa, this message translates to:
  /// **'رد شد توسط {name} – {time}'**
  String decidedRejectedBy(String name, String time);

  /// No description provided for @decisionReason.
  ///
  /// In fa, this message translates to:
  /// **'دلیل: {reason}'**
  String decisionReason(String reason);

  /// No description provided for @approve.
  ///
  /// In fa, this message translates to:
  /// **'تأیید'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In fa, this message translates to:
  /// **'رد کردن'**
  String get reject;

  /// No description provided for @approveReason.
  ///
  /// In fa, this message translates to:
  /// **'برای تأیید درخواست {number} هویت خود را تأیید کنید'**
  String approveReason(String number);

  /// No description provided for @approvedDone.
  ///
  /// In fa, this message translates to:
  /// **'تأیید شد و به انبار خبر داده شد'**
  String get approvedDone;

  /// No description provided for @rejectedDone.
  ///
  /// In fa, this message translates to:
  /// **'رد شد و به انبار خبر داده شد'**
  String get rejectedDone;

  /// No description provided for @undo.
  ///
  /// In fa, this message translates to:
  /// **'بازگرداندن'**
  String get undo;

  /// No description provided for @undoApprovePending.
  ///
  /// In fa, this message translates to:
  /// **'تأیید درخواست – {seconds} ثانیه تا ارسال'**
  String undoApprovePending(String seconds);

  /// No description provided for @undoRejectPending.
  ///
  /// In fa, this message translates to:
  /// **'رد درخواست – {seconds} ثانیه تا ارسال'**
  String undoRejectPending(String seconds);

  /// No description provided for @decisionQueued.
  ///
  /// In fa, this message translates to:
  /// **'اینترنت وصل نیست. تصمیم شما در صف ارسال است و خودکار فرستاده می‌شود.'**
  String get decisionQueued;

  /// No description provided for @conflictTitle.
  ///
  /// In fa, this message translates to:
  /// **'این درخواست قبلاً بررسی شده است'**
  String get conflictTitle;

  /// No description provided for @conflictApproved.
  ///
  /// In fa, this message translates to:
  /// **'تأیید شد توسط {name}. تصمیم شما ثبت نشد.'**
  String conflictApproved(String name);

  /// No description provided for @conflictRejected.
  ///
  /// In fa, this message translates to:
  /// **'رد شد توسط {name}. تصمیم شما ثبت نشد.'**
  String conflictRejected(String name);

  /// No description provided for @ok.
  ///
  /// In fa, this message translates to:
  /// **'باشه'**
  String get ok;

  /// No description provided for @rejectSheetTitle.
  ///
  /// In fa, this message translates to:
  /// **'رد کردن درخواست {number}'**
  String rejectSheetTitle(String number);

  /// No description provided for @rejectReasonLabel.
  ///
  /// In fa, this message translates to:
  /// **'دلیل رد'**
  String get rejectReasonLabel;

  /// No description provided for @rejectReasonHint.
  ///
  /// In fa, this message translates to:
  /// **'مثلاً: مقدار زیاد است'**
  String get rejectReasonHint;

  /// No description provided for @locationHistoryTitle.
  ///
  /// In fa, this message translates to:
  /// **'مصرف قبلی همین محل'**
  String get locationHistoryTitle;

  /// No description provided for @locationHistoryEmpty.
  ///
  /// In fa, this message translates to:
  /// **'تا حالا چیزی به این محل داده نشده است.'**
  String get locationHistoryEmpty;

  /// No description provided for @historyLine.
  ///
  /// In fa, this message translates to:
  /// **'{item} – {qty} {unit}'**
  String historyLine(String item, String qty, String unit);

  /// No description provided for @historyMeta.
  ///
  /// In fa, this message translates to:
  /// **'{date} – حواله {document}'**
  String historyMeta(String date, String document);

  /// No description provided for @chatEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز پیامی نیست.'**
  String get chatEmpty;

  /// No description provided for @chatYou.
  ///
  /// In fa, this message translates to:
  /// **'شما'**
  String get chatYou;

  /// No description provided for @chatTileTitle.
  ///
  /// In fa, this message translates to:
  /// **'گفتگو'**
  String get chatTileTitle;

  /// No description provided for @chatTileTitleCount.
  ///
  /// In fa, this message translates to:
  /// **'گفتگو – {count} پیام'**
  String chatTileTitleCount(String count);

  /// No description provided for @chatLastMessage.
  ///
  /// In fa, this message translates to:
  /// **'{name}: {text} – {time}'**
  String chatLastMessage(String name, String text, String time);

  /// No description provided for @chatUnread.
  ///
  /// In fa, this message translates to:
  /// **'پیام تازه'**
  String get chatUnread;

  /// No description provided for @chatScreenTitle.
  ///
  /// In fa, this message translates to:
  /// **'گفتگو – درخواست {number}'**
  String chatScreenTitle(String number);

  /// No description provided for @chatJumpToNewest.
  ///
  /// In fa, this message translates to:
  /// **'جدیدترین'**
  String get chatJumpToNewest;

  /// No description provided for @chatLoadingOlder.
  ///
  /// In fa, this message translates to:
  /// **'در حال آوردن پیام‌های قدیمی‌تر'**
  String get chatLoadingOlder;

  /// No description provided for @chatSending.
  ///
  /// In fa, this message translates to:
  /// **'در حال فرستادن…'**
  String get chatSending;

  /// No description provided for @returnForEdit.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش و برگرداندن'**
  String get returnForEdit;

  /// No description provided for @returnSheetTitle.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش و برگرداندن درخواست {number}'**
  String returnSheetTitle(String number);

  /// No description provided for @returnSheetHelp.
  ///
  /// In fa, this message translates to:
  /// **'مقدار هر قلم را کم کنید یا قلمی را حذف کنید. درخواست با پیشنهاد شما به درخواست‌کننده برمی‌گردد تا اصلاح کند و دوباره بفرستد.'**
  String get returnSheetHelp;

  /// No description provided for @returnRequested.
  ///
  /// In fa, this message translates to:
  /// **'درخواستی: {qty} {unit}'**
  String returnRequested(String qty, String unit);

  /// No description provided for @returnLess.
  ///
  /// In fa, this message translates to:
  /// **'کمتر – {item}'**
  String returnLess(String item);

  /// No description provided for @returnMore.
  ///
  /// In fa, this message translates to:
  /// **'بیشتر – {item}'**
  String returnMore(String item);

  /// No description provided for @returnLineRemove.
  ///
  /// In fa, this message translates to:
  /// **'حذف قلم'**
  String get returnLineRemove;

  /// No description provided for @returnLineRemoved.
  ///
  /// In fa, this message translates to:
  /// **'این قلم حذف می‌شود.'**
  String get returnLineRemoved;

  /// No description provided for @returnLineRestore.
  ///
  /// In fa, this message translates to:
  /// **'بازگرداندن قلم'**
  String get returnLineRestore;

  /// No description provided for @returnNoteLabel.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت برای درخواست‌کننده (اختیاری)'**
  String get returnNoteLabel;

  /// No description provided for @returnNoteHint.
  ///
  /// In fa, this message translates to:
  /// **'مثلاً: نصف این مقدار کافی است'**
  String get returnNoteHint;

  /// No description provided for @returnSend.
  ///
  /// In fa, this message translates to:
  /// **'ارسال برای اصلاح'**
  String get returnSend;

  /// No description provided for @undoReturnPending.
  ///
  /// In fa, this message translates to:
  /// **'برگرداندن برای اصلاح – {seconds} ثانیه تا ارسال'**
  String undoReturnPending(String seconds);

  /// No description provided for @returnedDone.
  ///
  /// In fa, this message translates to:
  /// **'برای اصلاح به درخواست‌کننده برگشت داده شد'**
  String get returnedDone;

  /// No description provided for @returnedBy.
  ///
  /// In fa, this message translates to:
  /// **'برگشت برای اصلاح توسط {name} – {time}'**
  String returnedBy(String name, String time);

  /// No description provided for @returnedLineChange.
  ///
  /// In fa, this message translates to:
  /// **'{item}: {before} ← {after} {unit}'**
  String returnedLineChange(
    String item,
    String before,
    String after,
    String unit,
  );

  /// No description provided for @returnedLineRemoved.
  ///
  /// In fa, this message translates to:
  /// **'{item}: حذف شد'**
  String returnedLineRemoved(String item);

  /// No description provided for @returnedNote.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت: {note}'**
  String returnedNote(String note);

  /// No description provided for @conflictReturned.
  ///
  /// In fa, this message translates to:
  /// **'{name} زودتر این درخواست را برای اصلاح برگرداند. کار شما ثبت نشد.'**
  String conflictReturned(String name);

  /// No description provided for @chatInputLabel.
  ///
  /// In fa, this message translates to:
  /// **'پیام'**
  String get chatInputLabel;

  /// No description provided for @chatSend.
  ///
  /// In fa, this message translates to:
  /// **'فرستادن'**
  String get chatSend;

  /// No description provided for @chatSendFailed.
  ///
  /// In fa, this message translates to:
  /// **'فرستاده نشد. برای تلاش دوباره لمس کنید.'**
  String get chatSendFailed;

  /// No description provided for @you.
  ///
  /// In fa, this message translates to:
  /// **'شما'**
  String get you;

  /// No description provided for @stockSearchLabel.
  ///
  /// In fa, this message translates to:
  /// **'جستجوی کالا'**
  String get stockSearchLabel;

  /// No description provided for @stockClearSearch.
  ///
  /// In fa, this message translates to:
  /// **'پاک کردن جستجو'**
  String get stockClearSearch;

  /// No description provided for @filterLow.
  ///
  /// In fa, this message translates to:
  /// **'کم‌موجود'**
  String get filterLow;

  /// No description provided for @stockEmpty.
  ///
  /// In fa, this message translates to:
  /// **'کالایی با این نام پیدا نشد.'**
  String get stockEmpty;

  /// No description provided for @stockNoLow.
  ///
  /// In fa, this message translates to:
  /// **'کالای کم‌موجودی نیست.'**
  String get stockNoLow;

  /// No description provided for @stockHiddenExplain.
  ///
  /// In fa, this message translates to:
  /// **'انبار در حال شمارش این کالاست. تا پایان شمارش، موجودی و گردش آن دیده نمی‌شود.'**
  String get stockHiddenExplain;

  /// No description provided for @movementsTitle.
  ///
  /// In fa, this message translates to:
  /// **'ورود و خروج اخیر'**
  String get movementsTitle;

  /// No description provided for @movementsEmpty.
  ///
  /// In fa, this message translates to:
  /// **'گردشی ثبت نشده است.'**
  String get movementsEmpty;

  /// No description provided for @movementIn.
  ///
  /// In fa, this message translates to:
  /// **'ورود'**
  String get movementIn;

  /// No description provided for @movementOut.
  ///
  /// In fa, this message translates to:
  /// **'خروج'**
  String get movementOut;

  /// No description provided for @movementAdjustDown.
  ///
  /// In fa, this message translates to:
  /// **'اصلاح موجودی (کم شد)'**
  String get movementAdjustDown;

  /// No description provided for @movementAdjustUp.
  ///
  /// In fa, this message translates to:
  /// **'اصلاح موجودی (زیاد شد)'**
  String get movementAdjustUp;

  /// No description provided for @movementMeta.
  ///
  /// In fa, this message translates to:
  /// **'{date} – سند {document}'**
  String movementMeta(String date, String document);

  /// No description provided for @itemCodeLabel.
  ///
  /// In fa, this message translates to:
  /// **'کد'**
  String get itemCodeLabel;

  /// No description provided for @assistantSuggestionToday.
  ///
  /// In fa, this message translates to:
  /// **'خلاصه امروز'**
  String get assistantSuggestionToday;

  /// No description provided for @assistantSuggestionMonth.
  ///
  /// In fa, this message translates to:
  /// **'درخواست‌های این ماه'**
  String get assistantSuggestionMonth;

  /// No description provided for @assistantInputLabel.
  ///
  /// In fa, this message translates to:
  /// **'سؤال خود را بنویسید'**
  String get assistantInputLabel;

  /// No description provided for @assistantHistory.
  ///
  /// In fa, this message translates to:
  /// **'گفتگوهای قبلی'**
  String get assistantHistory;

  /// No description provided for @assistantHistoryEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز سؤالی نپرسیده‌اید.'**
  String get assistantHistoryEmpty;

  /// No description provided for @assistantThinking.
  ///
  /// In fa, this message translates to:
  /// **'در حال آماده کردن پاسخ…'**
  String get assistantThinking;

  /// No description provided for @assistantFailed.
  ///
  /// In fa, this message translates to:
  /// **'پاسخ دریافت نشد؛ دوباره بپرسید'**
  String get assistantFailed;

  /// No description provided for @assistantEmpty.
  ///
  /// In fa, this message translates to:
  /// **'درباره درخواست‌ها و موجودی از دستیار کاسپین بپرسید.'**
  String get assistantEmpty;

  /// No description provided for @assistantDemoNote.
  ///
  /// In fa, this message translates to:
  /// **'نسخه آزمایشی: پاسخ‌ها نمونه‌اند. دستیار واقعی بعد از راه‌اندازی سرور فعال می‌شود.'**
  String get assistantDemoNote;

  /// No description provided for @moreReports.
  ///
  /// In fa, this message translates to:
  /// **'گزارش‌ها'**
  String get moreReports;

  /// No description provided for @morePurchaseList.
  ///
  /// In fa, this message translates to:
  /// **'لیست خرید'**
  String get morePurchaseList;

  /// No description provided for @moreUsers.
  ///
  /// In fa, this message translates to:
  /// **'کاربران و دسترسی‌ها'**
  String get moreUsers;

  /// No description provided for @moreSettings.
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات'**
  String get moreSettings;

  /// No description provided for @moreAbout.
  ///
  /// In fa, this message translates to:
  /// **'درباره و نسخه'**
  String get moreAbout;

  /// No description provided for @comingSoonBadge.
  ///
  /// In fa, this message translates to:
  /// **'به‌زودی'**
  String get comingSoonBadge;

  /// No description provided for @reportsTitle.
  ///
  /// In fa, this message translates to:
  /// **'گزارش‌ها'**
  String get reportsTitle;

  /// No description provided for @reportByFloor.
  ///
  /// In fa, this message translates to:
  /// **'مصرف به تفکیک طبقه'**
  String get reportByFloor;

  /// No description provided for @reportByLocation.
  ///
  /// In fa, this message translates to:
  /// **'مصرف به تفکیک محل'**
  String get reportByLocation;

  /// No description provided for @periodThisMonth.
  ///
  /// In fa, this message translates to:
  /// **'این ماه'**
  String get periodThisMonth;

  /// No description provided for @periodLast30.
  ///
  /// In fa, this message translates to:
  /// **'۳۰ روز اخیر'**
  String get periodLast30;

  /// No description provided for @periodLast90.
  ///
  /// In fa, this message translates to:
  /// **'۹۰ روز اخیر'**
  String get periodLast90;

  /// No description provided for @reportRange.
  ///
  /// In fa, this message translates to:
  /// **'از {from} تا {to}'**
  String reportRange(String from, String to);

  /// No description provided for @reportRowTotal.
  ///
  /// In fa, this message translates to:
  /// **'{count} قلم'**
  String reportRowTotal(int count);

  /// No description provided for @reportNoConsumption.
  ///
  /// In fa, this message translates to:
  /// **'بدون مصرف'**
  String get reportNoConsumption;

  /// No description provided for @reportEmpty.
  ///
  /// In fa, this message translates to:
  /// **'در این بازه مصرفی ثبت نشده است.'**
  String get reportEmpty;

  /// No description provided for @purchaseBody.
  ///
  /// In fa, this message translates to:
  /// **'لیست خرید در نسخه‌های بعدی اضافه می‌شود.'**
  String get purchaseBody;

  /// No description provided for @usersOwner.
  ///
  /// In fa, this message translates to:
  /// **'مالک'**
  String get usersOwner;

  /// No description provided for @usersYou.
  ///
  /// In fa, this message translates to:
  /// **'شما'**
  String get usersYou;

  /// No description provided for @usersNote.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت کاربران (تأیید، نقش، غیرفعال کردن) از پنل سرور انجام می‌شود.'**
  String get usersNote;

  /// No description provided for @settingsTheme.
  ///
  /// In fa, this message translates to:
  /// **'ظاهر'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In fa, this message translates to:
  /// **'مطابق گوشی'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In fa, this message translates to:
  /// **'روشن'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fa, this message translates to:
  /// **'تیره'**
  String get themeDark;

  /// No description provided for @settingsNotifications.
  ///
  /// In fa, this message translates to:
  /// **'اعلان‌ها'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsBody.
  ///
  /// In fa, this message translates to:
  /// **'خبر درخواست‌های تازه و پیام‌ها'**
  String get settingsNotificationsBody;

  /// No description provided for @backgroundTitle.
  ///
  /// In fa, this message translates to:
  /// **'اعلان وقتی برنامه بسته است'**
  String get backgroundTitle;

  /// No description provided for @backgroundBody.
  ///
  /// In fa, this message translates to:
  /// **'گوشی ممکن است برای صرفه‌جویی در باتری، بررسی درخواست‌های تازه را متوقف کند. موارد زیر را روشن کنید تا اعلان‌ها به‌موقع برسند.'**
  String get backgroundBody;

  /// No description provided for @backgroundNotifications.
  ///
  /// In fa, this message translates to:
  /// **'اجازهٔ نمایش اعلان'**
  String get backgroundNotifications;

  /// No description provided for @backgroundBattery.
  ///
  /// In fa, this message translates to:
  /// **'بدون محدودیت باتری'**
  String get backgroundBattery;

  /// No description provided for @backgroundAutostart.
  ///
  /// In fa, this message translates to:
  /// **'اجرای خودکار (Autostart)'**
  String get backgroundAutostart;

  /// No description provided for @backgroundAutostartBody.
  ///
  /// In fa, this message translates to:
  /// **'در گوشی‌های شیائومی باید دستی روشن شود؛ برنامه وضعیتش را نمی‌بیند.'**
  String get backgroundAutostartBody;

  /// No description provided for @backgroundOn.
  ///
  /// In fa, this message translates to:
  /// **'روشن است'**
  String get backgroundOn;

  /// No description provided for @backgroundOff.
  ///
  /// In fa, this message translates to:
  /// **'خاموش است'**
  String get backgroundOff;

  /// No description provided for @backgroundFix.
  ///
  /// In fa, this message translates to:
  /// **'تنظیم'**
  String get backgroundFix;

  /// No description provided for @settingsFingerprint.
  ///
  /// In fa, this message translates to:
  /// **'تأیید با اثر انگشت برای تأیید درخواست'**
  String get settingsFingerprint;

  /// No description provided for @settingsFingerprintBody.
  ///
  /// In fa, this message translates to:
  /// **'قبل از تأیید هر درخواست، یک بار اثر انگشت خواسته می‌شود.'**
  String get settingsFingerprintBody;

  /// No description provided for @settingsSecure.
  ///
  /// In fa, this message translates to:
  /// **'جلوگیری از عکس صفحه'**
  String get settingsSecure;

  /// No description provided for @settingsSecureBody.
  ///
  /// In fa, this message translates to:
  /// **'در صفحه‌های موجودی و درخواست‌ها، عکس گرفتن از صفحه ممکن نیست.'**
  String get settingsSecureBody;

  /// No description provided for @settingsDeviceUnlock.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن با اثر انگشت'**
  String get settingsDeviceUnlock;

  /// No description provided for @settingsDeviceUnlockBody.
  ///
  /// In fa, this message translates to:
  /// **'به‌جای رمز ۴ رقمی برنامه'**
  String get settingsDeviceUnlockBody;

  /// No description provided for @settingsPin.
  ///
  /// In fa, this message translates to:
  /// **'رمز برنامه'**
  String get settingsPin;

  /// No description provided for @settingsPinBody.
  ///
  /// In fa, this message translates to:
  /// **'برای وقتی که اثر انگشت کار نمی‌کند'**
  String get settingsPinBody;

  /// No description provided for @settingsPinSet.
  ///
  /// In fa, this message translates to:
  /// **'تعیین یا تغییر رمز'**
  String get settingsPinSet;

  /// No description provided for @settingsPinSaved.
  ///
  /// In fa, this message translates to:
  /// **'رمز برنامه ذخیره شد.'**
  String get settingsPinSaved;

  /// No description provided for @aboutVersion.
  ///
  /// In fa, this message translates to:
  /// **'نسخه {version} (ساخت {build})'**
  String aboutVersion(String version, String build);

  /// No description provided for @aboutMall.
  ///
  /// In fa, this message translates to:
  /// **'ساخته‌شده برای {mall}'**
  String aboutMall(String mall);

  /// No description provided for @devUnlocked.
  ///
  /// In fa, this message translates to:
  /// **'صفحه توسعه‌دهنده باز شد.'**
  String get devUnlocked;

  /// No description provided for @devTitle.
  ///
  /// In fa, this message translates to:
  /// **'صفحه توسعه‌دهنده'**
  String get devTitle;

  /// No description provided for @devScenario.
  ///
  /// In fa, this message translates to:
  /// **'سناریوی داده آزمایشی'**
  String get devScenario;

  /// No description provided for @scenarioNormal.
  ///
  /// In fa, this message translates to:
  /// **'عادی'**
  String get scenarioNormal;

  /// No description provided for @scenarioEmpty.
  ///
  /// In fa, this message translates to:
  /// **'بدون داده'**
  String get scenarioEmpty;

  /// No description provided for @scenarioSlow.
  ///
  /// In fa, this message translates to:
  /// **'شبکه کند'**
  String get scenarioSlow;

  /// No description provided for @scenarioServerError.
  ///
  /// In fa, this message translates to:
  /// **'خطای سرور'**
  String get scenarioServerError;

  /// No description provided for @scenarioConflict.
  ///
  /// In fa, this message translates to:
  /// **'تصمیم هم‌زمان (۴۰۹)'**
  String get scenarioConflict;

  /// No description provided for @scenarioOffline.
  ///
  /// In fa, this message translates to:
  /// **'بدون اینترنت'**
  String get scenarioOffline;

  /// No description provided for @devDataSource.
  ///
  /// In fa, this message translates to:
  /// **'منبع داده'**
  String get devDataSource;

  /// No description provided for @devDataSourceValue.
  ///
  /// In fa, this message translates to:
  /// **'{source} – {url}'**
  String devDataSourceValue(String source, String url);

  /// No description provided for @devDebugOnly.
  ///
  /// In fa, this message translates to:
  /// **'فقط در نسخه آزمایشی قابل تغییر است.'**
  String get devDebugOnly;

  /// No description provided for @devLogs.
  ///
  /// In fa, this message translates to:
  /// **'آخرین خطاها و رویدادها'**
  String get devLogs;

  /// No description provided for @devNoLogs.
  ///
  /// In fa, this message translates to:
  /// **'چیزی ثبت نشده است.'**
  String get devNoLogs;

  /// No description provided for @devExportLogs.
  ///
  /// In fa, this message translates to:
  /// **'فرستادن فایل گزارش'**
  String get devExportLogs;

  /// No description provided for @channelRequests.
  ///
  /// In fa, this message translates to:
  /// **'درخواست‌ها'**
  String get channelRequests;

  /// No description provided for @channelMessages.
  ///
  /// In fa, this message translates to:
  /// **'پیام‌ها'**
  String get channelMessages;

  /// No description provided for @updateAvailableTitle.
  ///
  /// In fa, this message translates to:
  /// **'نسخه تازه آماده است'**
  String get updateAvailableTitle;

  /// No description provided for @updateVersion.
  ///
  /// In fa, this message translates to:
  /// **'نسخه {version}'**
  String updateVersion(String version);

  /// No description provided for @updateLater.
  ///
  /// In fa, this message translates to:
  /// **'بعداً'**
  String get updateLater;

  /// No description provided for @updateNow.
  ///
  /// In fa, this message translates to:
  /// **'به‌روزرسانی'**
  String get updateNow;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In fa, this message translates to:
  /// **'برای ادامه، برنامه را به‌روز کنید'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredBody.
  ///
  /// In fa, this message translates to:
  /// **'این نسخه دیگر پشتیبانی نمی‌شود. نسخه تازه را نصب کنید؛ اطلاعات شما سر جایش می‌ماند.'**
  String get updateRequiredBody;

  /// No description provided for @updateDownloadInstall.
  ///
  /// In fa, this message translates to:
  /// **'دانلود و نصب'**
  String get updateDownloadInstall;

  /// No description provided for @updateDownloading.
  ///
  /// In fa, this message translates to:
  /// **'در حال دانلود… {percent}٪'**
  String updateDownloading(int percent);

  /// No description provided for @updateSize.
  ///
  /// In fa, this message translates to:
  /// **'حجم: {megabytes} مگابایت'**
  String updateSize(String megabytes);

  /// No description provided for @updatePermissionTitle.
  ///
  /// In fa, this message translates to:
  /// **'یک اجازه لازم است'**
  String get updatePermissionTitle;

  /// No description provided for @updatePermissionBody.
  ///
  /// In fa, this message translates to:
  /// **'برای نصب به‌روزرسانی، در صفحه بعد گزینه «اجازه از این منبع» را برای مالک کاسپین روشن کنید و برگردید. این کار فقط یک بار لازم است.'**
  String get updatePermissionBody;

  /// No description provided for @updateOpenSettings.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن تنظیمات'**
  String get updateOpenSettings;

  /// No description provided for @updateDownloadFailed.
  ///
  /// In fa, this message translates to:
  /// **'دانلود کامل نشد. اینترنت را بررسی کنید و دوباره تلاش کنید.'**
  String get updateDownloadFailed;

  /// No description provided for @updateChecksumFailed.
  ///
  /// In fa, this message translates to:
  /// **'فایل دانلودشده سالم نبود و پاک شد. دوباره تلاش کنید.'**
  String get updateChecksumFailed;

  /// No description provided for @aboutCheckUpdate.
  ///
  /// In fa, this message translates to:
  /// **'بررسی به‌روزرسانی'**
  String get aboutCheckUpdate;

  /// No description provided for @aboutCheckingUpdate.
  ///
  /// In fa, this message translates to:
  /// **'در حال بررسی…'**
  String get aboutCheckingUpdate;

  /// No description provided for @aboutUpToDate.
  ///
  /// In fa, this message translates to:
  /// **'برنامه به‌روز است.'**
  String get aboutUpToDate;

  /// No description provided for @aboutUpdateCheckFailed.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات به‌روزرسانی دریافت نشد.'**
  String get aboutUpdateCheckFailed;

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
