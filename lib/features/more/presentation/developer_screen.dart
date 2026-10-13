import 'package:caspian_owner/core/config/api_config.dart';
import 'package:caspian_owner/core/di/providers.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/mock/mock_backend.dart';
import 'package:caspian_owner/core/theme/app_icons.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/features/count/application/count_providers.dart';
import 'package:caspian_owner/features/count/domain/surprise_count.dart';
import 'package:caspian_owner/features/home/application/home_controller.dart';
import 'package:caspian_owner/features/requests/application/requests_providers.dart';
import 'package:caspian_owner/features/stock/application/stock_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// Hidden screen (7 taps on the version in About): mock scenarios, a
/// simulated end of a running count, and the on-device log.
class DeveloperScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends ConsumerState<DeveloperScreen> {
  bool get _mock => ApiConfig.dataSource == DataSource.mock;

  void _refreshData() => ref
    ..invalidate(homeControllerProvider)
    ..invalidate(requestsControllerProvider)
    ..invalidate(stockControllerProvider)
    ..invalidate(countsControllerProvider);

  void _completeCount() {
    final l10n = AppLocalizations.of(context);
    final backend = ref.read(mockBackendProvider);
    final running = backend.counts
        .where((c) => c.status == CountStatus.running)
        .firstOrNull;
    final message = running == null
        ? l10n.devNoRunningCount
        : l10n.devCountCompleted;
    if (running != null) {
      // One item short, so the results show a discrepancy.
      backend.completeCount(
        running.id,
        counted: {
          running.items.first.itemCode:
              (backend.stock
                      .firstWhere((s) => s.code == running.items.first.itemCode)
                      .qty ??
                  1) -
              1,
        },
      );
      _refreshData();
      ref.invalidate(countDetailProvider(running.id));
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _exportLogs() async {
    final log = ref.read(appLogProvider);
    if (log == null) return;
    await log.flush();
    await SharePlus.instance.share(
      ShareParams(files: [for (final f in log.files) XFile(f.path)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final info = ref.watch(appInfoProvider);
    final log = ref.watch(appLogProvider);
    final backend = _mock ? ref.watch(mockBackendProvider) : null;

    final scenarios = {
      MockScenario.normal: l10n.scenarioNormal,
      MockScenario.empty: l10n.scenarioEmpty,
      MockScenario.slowNetwork: l10n.scenarioSlow,
      MockScenario.serverError: l10n.scenarioServerError,
      MockScenario.conflict: l10n.scenarioConflict,
      MockScenario.offline: l10n.scenarioOffline,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.devTitle)),
      body: ListView(
        padding: const EdgeInsets.all(Space.page),
        children: [
          Text(l10n.devDataSource, style: theme.textTheme.titleSmall),
          Text(
            l10n.devDataSourceValue(
              ApiConfig.dataSource.name,
              ApiConfig.baseUrl.isEmpty ? '-' : ApiConfig.baseUrl,
            ),
            textDirection: TextDirection.ltr,
          ),
          if (!info.isDebug)
            Text(l10n.devDebugOnly, style: theme.textTheme.bodySmall),
          if (backend != null) ...[
            const SizedBox(height: Space.lg),
            Text(l10n.devScenario, style: theme.textTheme.titleSmall),
            RadioGroup<MockScenario>(
              groupValue: backend.scenario,
              onChanged: (value) {
                if (value == null) return;
                setState(() => backend.scenario = value);
                _refreshData();
              },
              child: Column(
                children: [
                  for (final MapEntry(key: s, value: label)
                      in scenarios.entries)
                    RadioListTile<MockScenario>(value: s, title: Text(label)),
                ],
              ),
            ),
            const SizedBox(height: Space.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.devCompleteCount),
              subtitle: Text(l10n.devCompleteCountBody),
              trailing: FilledButton.tonal(
                onPressed: _completeCount,
                child: Text(l10n.ok),
              ),
            ),
          ],
          const SizedBox(height: Space.lg),
          Row(
            children: [
              Expanded(
                child: Text(l10n.devLogs, style: theme.textTheme.titleSmall),
              ),
              IconButton(
                tooltip: l10n.devExportLogs,
                icon: const Icon(AppIcons.share),
                onPressed: log == null ? null : _exportLogs,
              ),
            ],
          ),
          if (log == null || log.recent.isEmpty)
            Text(l10n.devNoLogs, style: theme.textTheme.bodySmall)
          else
            for (final line in log.recent.reversed.take(100))
              Text(
                line,
                textDirection: TextDirection.ltr,
                style: theme.textTheme.bodySmall,
              ),
        ],
      ),
    );
  }
}
