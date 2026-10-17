import 'package:caspian_owner/core/theme/app_colors.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Background of row [index] in a list: white and light grey in turn
/// (zebra), so the eye keeps its line in long lists. Theme tokens only:
/// the card color and `surfaceContainerLow`, with dark counterparts.
Color zebraColor(BuildContext context, int index) => index.isOdd
    ? Theme.of(context).colorScheme.surfaceContainerLow
    : AppColors.of(context).card;

/// A lazily built list that looks like one bordered card with zebra rows
/// and thin dividers. Long lists scroll smoothly: only visible rows are
/// built.
class CardSliverList extends StatelessWidget {
  const new({required this.itemCount, required this.itemBuilder, super.key});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) => DecoratedSliver(
    // The border is drawn over the rows, so it stays crisp at the corners.
    position: DecorationPosition.foreground,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(Radii.card)),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    sliver: SliverList.builder(
      itemCount: itemCount,
      itemBuilder: (context, i) => CardSegment(
        index: i,
        first: i == 0,
        last: i == itemCount - 1,
        child: itemBuilder(context, i),
      ),
    ),
  );
}

/// One row of a [CardSliverList]: the first row has the card's top corners,
/// the last its bottom corners, rows are divided and striped.
class CardSegment extends StatelessWidget {
  const new({
    required this.index,
    required this.first,
    required this.last,
    required this.child,
    super.key,
  });

  final int index;
  final bool first;
  final bool last;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(Radii.card);
    return Material(
      color: zebraColor(context, index),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: first ? radius : Radius.zero,
          bottom: last ? radius : Radius.zero,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [child, if (!last) const Divider()]),
    );
  }
}

/// A striped row for short lists built all at once (movements, users,
/// reports): the zebra background and a divider below.
class ZebraRow extends StatelessWidget {
  const new({
    required this.index,
    required this.child,
    this.last = false,
    super.key,
  });

  final int index;
  final bool last;
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
    color: zebraColor(context, index),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [child, if (!last) const Divider()],
    ),
  );
}
