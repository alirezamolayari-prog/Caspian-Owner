import 'dart:async';

import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// An optional update the owner hasn't answered yet.
final _pendingUpdate = Provider<UpdateManifest?>((ref) {
  final update = ref.watch(updateControllerProvider);
  return update.decision is OptionalUpdate && !update.dismissed
      ? update.manifest
      : null;
});

/// The four fixed tabs: خانه – درخواست‌ها – موجودی – دستیار.
/// Each tab keeps its own navigation stack and scroll position.
///
/// It also offers optional updates: the shell only exists once the app is
/// usable (signed in, unlocked), so the offer never lands on the lock or
/// login screen.
class AppShell extends ConsumerStatefulWidget {
  const new({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  /// Each version is offered at most once per run.
  static int? _offeredBuild;

  @override
  void initState() {
    super.initState();
    ref.listenManual(_pendingUpdate, (_, manifest) {
      if (manifest == null || manifest.build == _offeredBuild) return;
      _offeredBuild = manifest.build;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_offer(manifest));
      });
    }, fireImmediately: true);
  }

  Future<void> _offer(UpdateManifest manifest) async {
    final l10n = AppLocalizations.of(context);
    final accept = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.updateAvailableTitle),
        content: SingleChildScrollView(
          child: Text(
            '${l10n.updateVersion(toPersianDigits(manifest.version))}\n\n'
            '${manifest.changelogFa}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.updateLater),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.updateNow),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (accept ?? false) {
      unawaited(context.push(Routes.update));
    } else {
      ref.read(updateControllerProvider.notifier).later();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shell = widget.shell;
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
