import 'package:flutter/material.dart';

@immutable
class PaperPalette extends ThemeExtension<PaperPalette> {
  const PaperPalette({
    required this.paper,
    required this.rule,
    required this.margin,
  });

  final Color paper;
  final Color rule;
  final Color margin;

  @override
  PaperPalette copyWith({Color? paper, Color? rule, Color? margin}) => PaperPalette(
        paper: paper ?? this.paper,
        rule: rule ?? this.rule,
        margin: margin ?? this.margin,
      );

  @override
  PaperPalette lerp(PaperPalette? other, double t) {
    if (other == null) return this;
    return PaperPalette(
      paper: Color.lerp(paper, other.paper, t)!,
      rule: Color.lerp(rule, other.rule, t)!,
      margin: Color.lerp(margin, other.margin, t)!,
    );
  }
}

ThemeData paperTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final paper = dark ? const Color(0xFF262620) : const Color(0xFFFAF6EB);
  final ink = dark ? const Color(0xFFF0EBDD) : const Color(0xFF292D28);
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF4C5C46),
    brightness: brightness,
    surface: paper,
  ).copyWith(onSurface: ink);
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? const Color(0xFF171A16) : const Color(0xFFE5E1D7),
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
  );
  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineSmall: base.textTheme.headlineSmall?.copyWith(fontFamily: 'serif', color: ink),
      titleLarge: base.textTheme.titleLarge?.copyWith(fontFamily: 'serif', color: ink),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: paper,
      foregroundColor: ink,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: paper,
      indicatorColor: scheme.primaryContainer,
    ),
    dividerTheme: DividerThemeData(color: dark ? const Color(0xFF56574D) : const Color(0xFFC9C6B8)),
    extensions: [
      PaperPalette(
        paper: paper,
        rule: dark ? const Color(0xFF42443B) : const Color(0xFFD5D5C7),
        margin: dark ? const Color(0xFF796659) : const Color(0xFFC8A89A),
      ),
    ],
  );
}
