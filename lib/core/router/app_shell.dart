import 'dart:async';

import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/modules/app_module.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/update/update_controller.dart';
import 'package:caspian_owner/core/update/update_manifest.dart';
import 'package:caspian_owner/core/utils/persian_digits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The module the current screen belongs to (for its app bar).
class ModuleScope extends InheritedWidget {
  const new({required this.module, required super.child, super.key});

  final AppModule module;

  static AppModule? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ModuleScope>()?.module;

  @override
  bool updateShouldNotify(ModuleScope oldWidget) => module != oldWidget.module;
}

/// A module's own bottom tabs (at most 4), e.g. the warehouse's
/// خانه – درخواست‌ها – موجودی – دستیار. Each tab keeps its own navigation
/// stack and scroll position.
///
/// Android Back on another tab's first screen goes to the module's first
/// tab; on the first tab, back to the hub.
class ModuleShell extends StatelessWidget {
  const new({required this.module, required this.shell, super.key});

  final AppModule module;
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (shell.currentIndex != 0) {
          shell.goBranch(0);
        } else {
          context.go(Routes.home);
        }
      },
      child: ModuleScope(
        module: module,
        child: UpdateOfferHost(
          child: Scaffold(
            body: shell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: (index) {
                // Otherwise a field focused before (Stock search) takes
                // focus back, and opens the keyboard, when its tab is shown
                // again.
                FocusManager.instance.primaryFocus?.unfocus();
                shell.goBranch(
                  index,
                  // Tapping the current tab again returns to its first screen.
                  initialLocation: index == shell.currentIndex,
                );
              },
              destinations: [
                for (final tab in module.tabs)
                  NavigationDestination(
                    icon: Icon(tab.icon),
                    label: tab.label(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// An optional update the owner hasn't answered yet.
final _pendingUpdate = Provider<UpdateManifest?>((ref) {
  final update = ref.watch(updateControllerProvider);
  return update.dismissed ? null : ref.watch(availableUpdateProvider);
});

/// Offers optional updates. It wraps the hub and the module shells, which
/// only exist once the app is usable (signed in, unlocked), so the offer
/// never lands on the lock or login screen.
class UpdateOfferHost extends ConsumerStatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<UpdateOfferHost> createState() => _UpdateOfferHostState();
}

class _UpdateOfferHostState extends ConsumerState<UpdateOfferHost> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(_pendingUpdate, (_, manifest) {
      // Each version is offered at most once per run (the hub and each
      // module shell all host the offer).
      if (manifest == null ||
          !ref.read(updateControllerProvider.notifier).markOffered(manifest)) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_offer(manifest));
      });
    }, fireImmediately: true);
  }

  /// «نسخه تازه آماده است»: the version, its size and what's new.
  /// «به‌روزرسانی» opens «درباره و نسخه», where the owner downloads and
  /// installs it. «رد کردن» (or tapping outside) lets them keep working;
  /// the update stays on the bell.
  Future<void> _offer(UpdateManifest manifest) async {
    final l10n = AppLocalizations.of(context);
    final size = formatNumber(
      (manifest.sizeBytes / (1024 * 1024) * 10).round() / 10,
    );
    final accept = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(AppIcons.update),
        title: Text(l10n.updateAvailableTitle),
        content: SingleChildScrollView(
          child: Text(
            '${l10n.updateVersion(toPersianDigits(manifest.version))}'
            ' – ${l10n.updateSize(size)}\n\n'
            '${manifest.changelogFa}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.updateDismiss),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.updateNow),
          ),
        ],
      ),
    );
    if (!mounted) return;
    final controller = ref.read(updateControllerProvider.notifier);
    if (accept ?? false) {
      unawaited(context.push(Routes.about));
    } else {
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.updateDismissedHint)));
      unawaited(controller.dismiss());
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
