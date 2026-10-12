import 'package:caspian_owner/features/requests/application/decision_controller.dart';
import 'package:caspian_owner/features/requests/presentation/widgets/request_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The acceptance flow of M6: log in, approve the newest pending request,
/// and find it under «بررسی‌شده». Shared by the headless test (CI) and the
/// on-device integration test.
Future<void> loginApproveAndFindReviewed(WidgetTester tester) async {
  // Log in.
  await tester.enterText(find.byType(TextField), '09121234567');
  await tester.tap(find.text('دریافت کد'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), '11111');
  await tester.tap(find.text('ورود'));
  await tester.pumpAndSettle();
  expect(find.text('منتظر تأیید شما'), findsOneWidget);

  // Home → Requests (pending filter) → newest request.
  await tester.tap(find.text('بررسی درخواست‌ها'));
  await tester.pumpAndSettle();
  expect(find.text('منتظر (۴)'), findsOneWidget);
  await tester.tap(find.byType(RequestTile).first);
  await tester.pumpAndSettle();
  expect(find.text('درخواست ۱۲۵'), findsOneWidget);

  // Approve, let the undo window pass.
  await tester.tap(find.text('تأیید'));
  await tester.pump();
  await tester.pump(DecisionController.undoWindow);
  await tester.pumpAndSettle();
  expect(find.textContaining('تأیید شد توسط علیرضا'), findsOneWidget);

  // Back to the list: one fewer pending; it's under «بررسی‌شده».
  // Android's system back button.
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
  expect(find.text('منتظر (۳)'), findsOneWidget);
  await tester.tap(find.text('بررسی‌شده'));
  await tester.pumpAndSettle();
  final reviewed = find.ancestor(
    of: find.text('لوله پی‌وی‌سی ۲ اینچ · ۸ شاخه'),
    matching: find.byType(RequestTile),
  );
  expect(reviewed, findsOneWidget);
  expect(
    find.descendant(of: reviewed, matching: find.text('تأیید شد')),
    findsOneWidget,
  );
}
