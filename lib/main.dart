import 'package:caspian_owner/app.dart';
import 'package:caspian_owner/bootstrap.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  final overrides = await bootstrap();
  runApp(
    ProviderScope(
      overrides: overrides,
      // Fail fast instead of silently retrying: errors are shown with
      // «تلاش دوباره», and retries happen when the owner asks.
      retry: (retryCount, error) => null,
      child: const CaspianOwnerApp(),
    ),
  );
}
