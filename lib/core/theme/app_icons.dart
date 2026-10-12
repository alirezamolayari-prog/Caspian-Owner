import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The app's icons, by meaning. One icon family only: Material Symbols
/// Rounded, outlined (unfilled). Directional icons mirror in RTL by default.
abstract final class AppIcons {
  // Request status
  static const IconData pending = Symbols.schedule_rounded;
  static const IconData approved = Symbols.check_circle_rounded;
  static const IconData rejected = Symbols.cancel_rounded;
  static const IconData cancelled = Symbols.block_rounded;

  // Stock
  static const IconData low = Symbols.warning_rounded;

  // Common actions
  static const IconData retry = Symbols.refresh_rounded;
  static const IconData error = Symbols.error_rounded;
}
