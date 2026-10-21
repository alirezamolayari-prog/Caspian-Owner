import 'package:caspian_owner/core/config/server_url.dart';
import 'package:caspian_owner/core/l10n/generated/app_localizations.dart';
import 'package:caspian_owner/core/network/api_client.dart';
import 'package:caspian_owner/core/theme/tokens.dart';
import 'package:caspian_owner/core/widgets/error_message.dart';
import 'package:caspian_owner/features/auth/application/auth_controller.dart';
import 'package:caspian_owner/features/settings/application/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Checks that Caspian Server answers at a URL (`GET /health`). Throws an
/// `ApiException` when it doesn't. Tests replace it.
final serverProbeProvider = Provider<Future<void> Function(String url)>(
  (ref) =>
      (url) => ApiClient(baseUrl: url).get('/health'),
);

/// «آدرس سرور»: edit, test («آزمایش اتصال») and save the server address.
/// Saving a different address while signed in signs out (the token belongs
/// to the old server). Returns true when something was saved.
Future<bool> showServerUrlDialog(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => const _ServerUrlDialog(),
    ) ??
    false;

class _ServerUrlDialog extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_ServerUrlDialog> createState() => _ServerUrlDialogState();
}

class _ServerUrlDialogState extends ConsumerState<_ServerUrlDialog> {
  late final _url = TextEditingController(
    text: ref.read(settingsControllerProvider).serverUrl,
  );
  String? _error;
  String? _ok;
  bool _testing = false;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  /// The address as typed, or null with [_error] set.
  String? _checked() {
    final l10n = AppLocalizations.of(context);
    final problem = ServerUrl.problem(_url.text);
    setState(() {
      _ok = null;
      _error = switch (problem) {
        ServerUrlProblem.invalid => l10n.serverInvalid,
        ServerUrlProblem.needsHttps => l10n.serverNeedsHttps,
        null => null,
      };
    });
    return problem == null ? ServerUrl.normalize(_url.text) : null;
  }

  Future<void> _test() async {
    final url = _checked();
    if (url == null) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _testing = true);
    try {
      await ref.read(serverProbeProvider)(url);
      if (mounted) setState(() => _ok = l10n.serverTestOk);
    } on Object catch (e) {
      if (mounted) setState(() => _error = errorMessage(e, l10n));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _save() async {
    final url = _checked();
    if (url == null) return;
    final settings = ref.read(settingsControllerProvider.notifier);
    final changed = url != ref.read(settingsControllerProvider).serverUrl;
    settings.setServerUrl(url);
    if (changed && ref.read(authControllerProvider) is SignedIn) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final signedIn = ref.watch(authControllerProvider) is SignedIn;

    return AlertDialog(
      title: Text(l10n.serverTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _url,
              autofocus: true,
              keyboardType: TextInputType.url,
              textDirection: TextDirection.ltr,
              autocorrect: false,
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: l10n.serverTitle,
                helperText: l10n.serverHelp,
                helperMaxLines: 3,
                errorText: _error,
                errorMaxLines: 3,
              ),
            ),
            if (_ok case final ok?) ...[
              const SizedBox(height: Space.sm),
              Text(ok, style: theme.textTheme.bodyMedium),
            ],
            if (signedIn) ...[
              const SizedBox(height: Space.md),
              Text(l10n.serverChangeSignsOut, style: theme.textTheme.bodySmall),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _testing ? null : _test,
          child: Text(l10n.serverTest),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.serverSave)),
      ],
    );
  }
}
