import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The four fixed tabs: خانه · درخواست‌ها · موجودی · دستیار.
/// Each tab keeps its own navigation stack and scroll position.
class AppShell extends StatelessWidget {
  const new({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) => shell.goBranch(
          index,
          // Tapping the current tab again returns to its first screen.
          initialLocation: index == shell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.home),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.requests),
            label: l10n.tabRequests,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.stock),
            label: l10n.tabStock,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.assistant),
            label: l10n.tabAssistant,
          ),
        ],
      ),
    );
  }
}
