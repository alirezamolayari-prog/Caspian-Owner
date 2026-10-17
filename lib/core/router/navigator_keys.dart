import 'package:flutter/widgets.dart';

/// The app's top navigator. Pages pushed on it cover a module's bottom
/// tabs (request detail, More, Settings…), and dialogs shown from outside
/// the widget tree (update prompt) use it. Modules attach their pushed
/// routes here (`parentNavigatorKey`), so it lives apart from the router.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
