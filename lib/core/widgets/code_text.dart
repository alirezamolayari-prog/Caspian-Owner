import 'package:flutter/widgets.dart';

/// An item or document code (`I-1002`) inside Persian text.
///
/// - The app font (Vazirmatn UI **FD**) draws every digit as a Persian
///   digit, and its Latin «I» looks like «۱», so «I-1002» read as «۱-۱۰۰۲».
///   Codes use the phone's Latin system font instead.
/// - The code sits in a left-to-right isolate (U+2066 … U+2069), so the
///   right-to-left paragraph can't reorder «I-1002» into «1002-I».
TextSpan codeSpan(String code, {TextStyle? style}) => TextSpan(
  text: '\u2066$code\u2069',
  style: (style ?? const TextStyle()).copyWith(
    fontFamily: 'Roboto',
    fontFamilyFallback: const ['sans-serif'],
  ),
);

/// «label code», e.g. «کد I-1002».
class LabeledCode extends StatelessWidget {
  const new({required this.label, required this.code, this.style, super.key});

  final String label;
  final String code;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: '$label ',
      children: [codeSpan(code, style: style)],
    ),
    style: style,
  );
}
