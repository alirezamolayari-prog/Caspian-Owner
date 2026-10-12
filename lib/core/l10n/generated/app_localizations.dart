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
  /// **'از طرف {sender} · {time}'**
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
  /// **'در حال شمارش'**
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
  /// **'تأیید شد توسط {name} · {time}'**
  String decidedApprovedBy(String name, String time);

  /// No description provided for @decidedRejectedBy.
  ///
  /// In fa, this message translates to:
  /// **'رد شد توسط {name} · {time}'**
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
  /// **'دلیل (اختیاری)'**
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
  /// **'{item} · {qty} {unit}'**
  String historyLine(String item, String qty, String unit);

  /// No description provided for @historyMeta.
  ///
  /// In fa, this message translates to:
  /// **'{date} · حواله {document}'**
  String historyMeta(String date, String document);

  /// No description provided for @chatTitle.
  ///
  /// In fa, this message translates to:
  /// **'گفتگو درباره این درخواست'**
  String get chatTitle;

  /// No description provided for @chatEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز پیامی نیست.'**
  String get chatEmpty;

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

  /// No description provided for @stockSearchHint.
  ///
  /// In fa, this message translates to:
  /// **'نام یا کد کالا'**
  String get stockSearchHint;

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
  /// **'تا پایان شمارش غافلگیرانه، موجودی و گردش این کالا مخفی است.'**
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
  /// **'{date} · سند {document}'**
  String movementMeta(String date, String document);

  /// No description provided for @itemCode.
  ///
  /// In fa, this message translates to:
  /// **'کد {code}'**
  String itemCode(String code);

  /// No description provided for @countPickTitle.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب اقلام برای شمارش'**
  String get countPickTitle;

  /// No description provided for @countPickHelp.
  ///
  /// In fa, this message translates to:
  /// **'اقلامی را که می‌خواهید سرزده شمرده شوند انتخاب کنید.'**
  String get countPickHelp;

  /// No description provided for @countSelected.
  ///
  /// In fa, this message translates to:
  /// **'{count} قلم انتخاب شد'**
  String countSelected(int count);

  /// No description provided for @countContinueCount.
  ///
  /// In fa, this message translates to:
  /// **'ادامه ({count} قلم)'**
  String countContinueCount(int count);

  /// No description provided for @countAlreadyRunning.
  ///
  /// In fa, this message translates to:
  /// **'در حال شمارش'**
  String get countAlreadyRunning;

  /// No description provided for @countConfirmTitle.
  ///
  /// In fa, this message translates to:
  /// **'شروع شمارش غافلگیرانه'**
  String get countConfirmTitle;

  /// No description provided for @countConfirmBody.
  ///
  /// In fa, this message translates to:
  /// **'این اقلام در اپ انبار قفل و موجودی‌شان مخفی می‌شود تا شمارش انجام شود.'**
  String get countConfirmBody;

  /// No description provided for @countConfirmStart.
  ///
  /// In fa, this message translates to:
  /// **'شروع شمارش'**
  String get countConfirmStart;

  /// No description provided for @countDetailTitle.
  ///
  /// In fa, this message translates to:
  /// **'شمارش غافلگیرانه'**
  String get countDetailTitle;

  /// No description provided for @countRunningTitle.
  ///
  /// In fa, this message translates to:
  /// **'شمارش در حال انجام است'**
  String get countRunningTitle;

  /// No description provided for @countRunningBody.
  ///
  /// In fa, this message translates to:
  /// **'این اقلام در انبار قفل‌اند و موجودی‌شان برای همه مخفی است، حتی برای شما. وقتی کارکنان شمردند، نتیجه همین‌جا می‌آید.'**
  String get countRunningBody;

  /// No description provided for @countOrderedBy.
  ///
  /// In fa, this message translates to:
  /// **'دستور: {name} · {time}'**
  String countOrderedBy(String name, String time);

  /// No description provided for @countDoneTitle.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه شمارش'**
  String get countDoneTitle;

  /// No description provided for @countFinishedAt.
  ///
  /// In fa, this message translates to:
  /// **'پایان: {date}'**
  String countFinishedAt(String date);

  /// No description provided for @countSystem.
  ///
  /// In fa, this message translates to:
  /// **'طبق سیستم'**
  String get countSystem;

  /// No description provided for @countCounted.
  ///
  /// In fa, this message translates to:
  /// **'شمرده‌شده'**
  String get countCounted;

  /// No description provided for @countMatch.
  ///
  /// In fa, this message translates to:
  /// **'درست است'**
  String get countMatch;

  /// No description provided for @countShort.
  ///
  /// In fa, this message translates to:
  /// **'{qty} {unit} کمتر'**
  String countShort(String qty, String unit);

  /// No description provided for @countOver.
  ///
  /// In fa, this message translates to:
  /// **'{qty} {unit} بیشتر'**
  String countOver(String qty, String unit);

  /// No description provided for @countEntries.
  ///
  /// In fa, this message translates to:
  /// **'عددهای واردشده'**
  String get countEntries;

  /// No description provided for @countEntry.
  ///
  /// In fa, this message translates to:
  /// **'{qty} · {name} · {time}'**
  String countEntry(String qty, String name, String time);

  /// No description provided for @countNoAutoAdjust.
  ///
  /// In fa, this message translates to:
  /// **'موجودی به‌طور خودکار اصلاح نمی‌شود. برای اصلاح، در اپ انبار سند اصلاح ثبت کنید.'**
  String get countNoAutoAdjust;

  /// No description provided for @countHistoryTitle.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه شمارش‌ها'**
  String get countHistoryTitle;

  /// No description provided for @countHistoryEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز شمارشی انجام نشده است.'**
  String get countHistoryEmpty;

  /// No description provided for @countItemsCount.
  ///
  /// In fa, this message translates to:
  /// **'{count} قلم'**
  String countItemsCount(int count);

  /// No description provided for @countDiscrepancies.
  ///
  /// In fa, this message translates to:
  /// **'{count} مغایرت'**
  String countDiscrepancies(int count);

  /// No description provided for @countStatusRunning.
  ///
  /// In fa, this message translates to:
  /// **'در حال انجام'**
  String get countStatusRunning;

  /// No description provided for @countStatusDone.
  ///
  /// In fa, this message translates to:
  /// **'تمام شد'**
  String get countStatusDone;

  /// No description provided for @countSeeHistory.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه شمارش‌ها'**
  String get countSeeHistory;

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
