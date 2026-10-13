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

  /// No description provided for @assistantSuggestionCount.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه آخرین شمارش'**
  String get assistantSuggestionCount;

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
  /// **'درباره درخواست‌ها، موجودی و شمارش‌ها از دستیار کاسپین بپرسید.'**
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

  /// No description provided for @usersAdmin.
  ///
  /// In fa, this message translates to:
  /// **'مدیر سیستم'**
  String get usersAdmin;

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
  /// **'افزودن، حذف و تعیین دسترسی کاربران بعد از راه‌اندازی سرور فعال می‌شود.'**
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
  /// **'خبر درخواست‌های تازه، نتیجه شمارش و پیام‌ها'**
  String get settingsNotificationsBody;

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
  /// **'در صفحه‌های موجودی، درخواست‌ها و شمارش، عکس گرفتن از صفحه ممکن نیست.'**
  String get settingsSecureBody;

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

  /// No description provided for @devCompleteCount.
  ///
  /// In fa, this message translates to:
  /// **'پایان شمارش در حال انجام'**
  String get devCompleteCount;

  /// No description provided for @devCompleteCountBody.
  ///
  /// In fa, this message translates to:
  /// **'شبیه‌سازی کار انبار: کارکنان شمارش را تمام می‌کنند.'**
  String get devCompleteCountBody;

  /// No description provided for @devNoRunningCount.
  ///
  /// In fa, this message translates to:
  /// **'شمارشی در حال انجام نیست.'**
  String get devNoRunningCount;

  /// No description provided for @devCountCompleted.
  ///
  /// In fa, this message translates to:
  /// **'شمارش تمام شد.'**
  String get devCountCompleted;

  /// No description provided for @devDataSource.
  ///
  /// In fa, this message translates to:
  /// **'منبع داده'**
  String get devDataSource;

  /// No description provided for @devDataSourceValue.
  ///
  /// In fa, this message translates to:
  /// **'{source} · {url}'**
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

  /// No description provided for @channelCounts.
  ///
  /// In fa, this message translates to:
  /// **'شمارش غافلگیرانه'**
  String get channelCounts;

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
