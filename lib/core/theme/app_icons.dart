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
  static const IconData queued = Symbols.schedule_send_rounded;
  static const IconData returned = Symbols.undo_rounded;
  static const IconData issued = Symbols.receipt_long_rounded;
  static const IconData unknown = Symbols.help_rounded;
  static const IconData edit = Symbols.edit_rounded;
  static const IconData add = Symbols.add_rounded;
  static const IconData remove = Symbols.remove_rounded;
  static const IconData delete = Symbols.delete_rounded;
  static const IconData newest = Symbols.keyboard_double_arrow_down_rounded;

  // Request detail
  static const IconData place = Symbols.location_on_rounded;
  static const IconData history = Symbols.history_rounded;
  static const IconData send = Symbols.send_rounded;
  static const IconData chat = Symbols.chat_rounded;
  static const IconData forward = Symbols.chevron_right_rounded;

  // Stock
  static const IconData low = Symbols.warning_rounded;
  static const IconData search = Symbols.search_rounded;
  static const IconData clear = Symbols.close_rounded;
  static const IconData hidden = Symbols.visibility_off_rounded;
  static const IconData incoming = Symbols.south_west_rounded;
  static const IconData outgoing = Symbols.north_east_rounded;
  static const IconData adjust = Symbols.tune_rounded;

  // Common actions
  static const IconData retry = Symbols.refresh_rounded;
  static const IconData error = Symbols.error_rounded;
  static const IconData offline = Symbols.cloud_off_rounded;
  static const IconData allDone = Symbols.task_alt_rounded;
  static const IconData check = Symbols.check_rounded;
  static const IconData count = Symbols.fact_check_rounded;

  // Hub and modules
  static const IconData hub = Symbols.apps_rounded;
  static const IconData warehouse = Symbols.warehouse_rounded;
  static const IconData parking = Symbols.local_parking_rounded;
  static const IconData crm = Symbols.handshake_rounded;
  static const IconData services = Symbols.home_repair_service_rounded;

  // Bottom tabs
  static const IconData home = Symbols.home_rounded;
  static const IconData requests = Symbols.assignment_rounded;
  static const IconData stock = Symbols.inventory_2_rounded;
  static const IconData assistant = Symbols.auto_awesome_rounded;

  // Top bar and account
  static const IconData notifications = Symbols.notifications_rounded;
  static const IconData update = Symbols.system_update_rounded;
  static const IconData account = Symbols.account_circle_rounded;
  static const IconData logout = Symbols.logout_rounded;

  // More
  static const IconData reports = Symbols.bar_chart_rounded;
  static const IconData purchase = Symbols.shopping_cart_rounded;
  static const IconData users = Symbols.group_rounded;
  static const IconData settings = Symbols.settings_rounded;
  static const IconData about = Symbols.info_rounded;
  static const IconData developer = Symbols.code_rounded;
  static const IconData share = Symbols.share_rounded;
  static const IconData admin = Symbols.shield_person_rounded;

  // Security
  static const IconData lock = Symbols.lock_rounded;
  static const IconData fingerprint = Symbols.fingerprint_rounded;
  static const IconData sms = Symbols.sms_rounded;
  static const IconData visibility = Symbols.visibility_rounded;
  static const IconData visibilityOff = Symbols.visibility_off_rounded;
  static const IconData server = Symbols.dns_rounded;
}
