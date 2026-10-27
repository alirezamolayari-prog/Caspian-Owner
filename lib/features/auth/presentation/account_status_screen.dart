import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/features/auth/presentation/widgets/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Where an account stands when it can't log in yet (or any more).
enum AccountStatus {
  /// Just registered: waiting for the admin.
  registered,

  /// `account_pending`: the password was right, the admin hasn't approved.
  pending,

  /// `account_rejected`: the admin didn't approve the registration.
  rejected,

  /// `account_disabled`: the admin turned the account off.
  disabled;

  /// From the route (`/account/pending`, …); unknown means pending.
  static AccountStatus parse(String? value) =>
      values.asNameMap()[value] ?? pending;
}

/// A page with one clear sentence about the account and a way back.
class AccountStatusScreen extends StatelessWidget {
  const new({required this.status, super.key});

  final AccountStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, title, body) = switch (status) {
      AccountStatus.registered => (
        AppIcons.approved,
        l10n.accountRegisteredTitle,
        l10n.accountRegisteredBody,
      ),
      AccountStatus.pending => (
        AppIcons.pending,
        l10n.accountPendingTitle,
        l10n.accountPendingBody,
      ),
      AccountStatus.rejected => (
        AppIcons.rejected,
        l10n.accountRejectedTitle,
        l10n.accountRejectedBody,
      ),
      AccountStatus.disabled => (
        AppIcons.cancelled,
        l10n.accountDisabledTitle,
        l10n.accountDisabledBody,
      ),
    };
    return AuthPage(
      icon: icon,
      title: title,
      body: body,
      onBack: () => context.go(Routes.login),
      children: [
        BigButton(
          label: l10n.backToLogin,
          onPressed: () => context.go(Routes.login),
        ),
      ],
    );
  }
}
