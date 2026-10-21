import 'package:caspian_owner/core/domain/app_config.dart';
import 'package:caspian_owner/core/domain/config_repository.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/core/network/api_exception.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_message.dart';
import 'package:caspian_owner/features/assistant/domain/assistant_repository.dart';
import 'package:caspian_owner/features/reports/domain/consumption_report.dart';
import 'package:caspian_owner/features/reports/domain/reports_repository.dart';
import 'package:caspian_owner/features/stock/domain/stock.dart';
import 'package:caspian_owner/features/stock/domain/stock_repository.dart';

/// Caspian Server v1 has only login, requests, decisions, chat and
/// `/changes`. Parts of the app without a server API yet use these: they
/// fail with a clear Persian message instead of showing sample data. The
/// screens themselves show «به‌زودی» (see `NotConnectedBody`).
const notConnected = ServerException(code: 'not_connected');

class NotConnectedStockRepository implements StockRepository {
  const new();

  @override
  Future<List<StockItem>> list({String? query, bool lowOnly = false}) =>
      Future.error(notConnected);

  @override
  Future<List<StockMovement>> movements(String itemCode) =>
      Future.error(notConnected);
}

class NotConnectedAssistantRepository implements AssistantRepository {
  const new();

  @override
  Future<List<AssistantMessage>> history() => Future.error(notConnected);

  @override
  Future<AssistantMessage> ask(String text) => Future.error(notConnected);
}

class NotConnectedReportsRepository implements ReportsRepository {
  const new();

  @override
  Future<ConsumptionReport> consumption({
    required ReportGrouping groupBy,
    required DateTime from,
    required DateTime to,
  }) => Future.error(notConnected);
}

/// No `/config` or `/locations` on the server yet: a fixed configuration
/// (warehouse module on, reports off) and no location list (places are free
/// text in v1).
class LocalConfigRepository implements ConfigRepository {
  const new();

  @override
  Future<AppConfig> config() async => const AppConfig(
    featureFlags: [],
    modules: ['warehouse'],
    upcomingModules: ['parking', 'crm', 'services'],
    minSupportedBuild: 0,
  );

  @override
  Future<LocationsSnapshot> locations() async => const LocationsSnapshot(
    version: 'server-v1',
    floors: Floors.all,
    locations: [],
  );
}
