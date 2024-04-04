import 'package:flutter/material.dart';

final kDarkColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 219, 41, 174));

ThemeData _lightTheme() {
  final ThemeData base = ThemeData.light();

  final lightColorScheme =
      ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 219, 41, 174));

  return base.copyWith(
    colorScheme: lightColorScheme,
    outlinedButtonTheme:
        _outlinedButtonTheme(lightColorScheme, Brightness.light),
    elevatedButtonTheme: _elevatedButtonTheme(lightColorScheme),
    cardTheme: _cardTheme(base, lightColorScheme, Brightness.light),
    inputDecorationTheme:
        _inputDecorationTheme(base, lightColorScheme, Brightness.light),
    appBarTheme: _appBarTheme(base, lightColorScheme, Brightness.light),
    searchBarTheme: _searchBarTheme(base, lightColorScheme, Brightness.light),
  );
}

ThemeData _darkTheme() {
  final ThemeData base = ThemeData.dark();

  final darkColorScheme =
      ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 219, 41, 174));

  return base.copyWith(
    colorScheme: darkColorScheme,
    outlinedButtonTheme: _outlinedButtonTheme(darkColorScheme, Brightness.dark),
    elevatedButtonTheme: _elevatedButtonTheme(darkColorScheme),
    cardTheme: _cardTheme(base, darkColorScheme, Brightness.dark),
    inputDecorationTheme:
        _inputDecorationTheme(base, darkColorScheme, Brightness.dark),
    appBarTheme: _appBarTheme(base, darkColorScheme, Brightness.dark),
    searchBarTheme: _searchBarTheme(base, darkColorScheme, Brightness.dark),
  );
}

OutlinedButtonThemeData _outlinedButtonTheme(
    ColorScheme colorScheme, Brightness brightness) {
  Color color;
  if (brightness == Brightness.light) {
    color = colorScheme.primary;
  } else {
    color = colorScheme.primaryContainer;
  }
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(
        color: color,
        width: 2,
      ),
    ),
  );
}

ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),
  );
}

CardTheme _cardTheme(
    ThemeData base, ColorScheme colorScheme, Brightness brightness) {
  Color backgroundColor;
  Color borderColor;
  if (brightness == Brightness.light) {
    backgroundColor = colorScheme.primaryContainer.withOpacity(0.7);
    borderColor = colorScheme.primary.withOpacity(0.2);
  } else {
    backgroundColor = colorScheme.primary.withOpacity(0.3);
    borderColor = colorScheme.primary;
  }
  return base.cardTheme.copyWith(
    elevation: 0,
    color: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: borderColor, width: 2),
    ),
  );
}

InputDecorationTheme _inputDecorationTheme(
    ThemeData base, ColorScheme colorScheme, Brightness brightness) {
  Color backgroundColor;
  Color labelColor;
  Color borderColor;

  if (brightness == Brightness.light) {
    backgroundColor = colorScheme.primaryContainer.withOpacity(0.7);
    labelColor = Colors.grey.shade900;
    borderColor = colorScheme.primary.withOpacity(0.2);
  } else {
    backgroundColor = colorScheme.primary.withOpacity(0.1);
    labelColor = Colors.grey.shade400;
    borderColor = colorScheme.primary;
  }
  return base.inputDecorationTheme.copyWith(
    labelStyle: TextStyle(color: labelColor),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    filled: true,
    fillColor: backgroundColor,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 2.0),
      borderRadius: BorderRadius.circular(24),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
}

AppBarTheme _appBarTheme(
    ThemeData base, ColorScheme colorScheme, Brightness brightness) {
  Color iconColor;

  if (brightness == Brightness.light) {
    iconColor = Colors.grey.shade900;
  } else {
    iconColor = Colors.grey.shade100;
  }
  return base.appBarTheme.copyWith(
    iconTheme: const IconThemeData().copyWith(color: iconColor),
    backgroundColor: base.scaffoldBackgroundColor,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: base.textTheme.titleLarge!
        .copyWith(fontWeight: FontWeight.w600, fontSize: 26),
  );
}

SearchBarThemeData _searchBarTheme(
    ThemeData base, ColorScheme colorScheme, Brightness brightness) {
  Color backgroundColor;
  Color textColor;
  if (brightness == Brightness.light) {
    backgroundColor = Colors.grey.shade300;
    textColor = Colors.grey.shade900;
  } else {
    backgroundColor = Colors.grey.shade800;
    textColor = Colors.grey.shade100;
  }
  return base.searchBarTheme.copyWith(
    elevation: const MaterialStatePropertyAll(0),
    backgroundColor: MaterialStateProperty.all(backgroundColor),
    textStyle: MaterialStatePropertyAll(
        base.textTheme.bodyLarge!.copyWith(color: textColor)),
  );
}

final lightTheme = _lightTheme();

final darkTheme = _darkTheme();
