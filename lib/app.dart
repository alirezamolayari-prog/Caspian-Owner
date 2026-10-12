import 'package:flutter/material.dart';

/// Root widget. Theme, localization and routing arrive in M2–M4.
class CaspianOwnerApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: SafeArea(child: SizedBox.expand())),
    );
  }
}
