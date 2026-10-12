import 'package:caspian_owner/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts and shows a scaffold', (tester) async {
    await tester.pumpWidget(const CaspianOwnerApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
