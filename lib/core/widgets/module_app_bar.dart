import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/router/app_shell.dart';
import 'package:caspian_owner/core/router/routes.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The app bar of a module's tab screens: the module's name above the page
/// title, and a button back to the «کاسپین» hub (so it is always clear
/// which part of Caspian the owner is in, and how to leave it).
class ModuleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const new({required this.title, this.actions, super.key});

  /// The page title; a [Text] or a small column.
  final Widget title;
  final List<Widget>? actions;

  static const _height = 72.0;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final module = ModuleScope.maybeOf(context);
    return AppBar(
      toolbarHeight: _height,
      titleSpacing: 0,
      leading: IconButton(
        tooltip: l10n.backToHub,
        icon: const Icon(AppIcons.hub),
        onPressed: () => context.go(Routes.home),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (module != null)
            Text(module.title(context), style: text.labelMedium),
          DefaultTextStyle.merge(
            style: text.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: title,
          ),
        ],
      ),
      actions: [
        ...?actions,
        const SizedBox(width: Space.sm),
      ],
    );
  }
}
