import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Meaning of a status, which picks its colors.
enum StatusTone { neutral, success, warning, error }

/// Read-only status label: always icon + text, never color alone.
class StatusChip extends StatelessWidget {
  const new({
    required this.label,
    required this.icon,
    this.tone = StatusTone.neutral,
    super.key,
  });

  final String label;
  final IconData icon;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = AppColors.of(context);
    final (Color background, Color foreground) = switch (tone) {
      StatusTone.neutral => (scheme.surfaceContainer, scheme.onSurfaceVariant),
      StatusTone.success => (colors.successContainer, colors.success),
      StatusTone.warning => (colors.warningContainer, colors.warning),
      StatusTone.error => (scheme.errorContainer, scheme.onErrorContainer),
    };
    final textStyle = Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: foreground);

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(Radius.circular(Radii.chip)),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Space.sm,
            Space.xs,
            Space.sm + Space.xs,
            Space.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: Space.xs),
              Flexible(child: Text(label, style: textStyle)),
            ],
          ),
        ),
      ),
    );
  }
}
