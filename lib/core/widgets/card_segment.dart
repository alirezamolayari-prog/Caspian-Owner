import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// One row of a list that looks like a single card: the first row has the
/// card's top corners, the last its bottom corners, rows are divided.
/// Used in lazily built lists, so long lists scroll smoothly.
class CardSegment extends StatelessWidget {
  const new({
    required this.first,
    required this.last,
    required this.child,
    super.key,
  });

  final bool first;
  final bool last;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(Radii.card);
    return Material(
      color: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: first ? radius : Radius.zero,
          bottom: last ? radius : Radius.zero,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          child,
          if (!last) const Divider(indent: Space.md, endIndent: Space.md),
        ],
      ),
    );
  }
}
