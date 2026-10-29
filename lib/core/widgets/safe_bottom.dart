import 'package:flutter/widgets.dart';

/// Android 15 draws apps under the gesture / navigation bar. A scroll view
/// with its own padding doesn't add that space itself, so the last item can
/// sit under the bar: add it. Zero above a bottom bar (Scaffold already
/// removed it there).
extension SafeBottom on EdgeInsets {
  EdgeInsets withSafeBottom(BuildContext context) =>
      copyWith(bottom: bottom + MediaQuery.paddingOf(context).bottom);
}
