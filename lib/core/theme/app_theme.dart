import 'package:eventify/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColor.brandBlue,
      surface: AppColor.lightSurface,
      surfaceContainerHighest: AppColor.lightSurfaceVariant,
      onSurface: AppColor.lightTextPrimary,
      tertiary: AppColor.darkSurfaceVariant,
      error: AppColor.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.lightBackground,
      foregroundColor: AppColor.lightTextPrimary,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
    ), 
    textTheme: _textTheme(AppColor.lightTextPrimary, AppColor.lightTextSecondary),
    dividerColor: AppColor.lightBorder,
    splashFactory: InkSparkle.splashFactory,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColor.lightBorder)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColor.lightBorder)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColor.brandBlue, width: 2)
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColor.error)
      ),
    )
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColor.brandBlue,
      surface: AppColor.darkSurface,
      surfaceContainerHighest: AppColor.darkSurfaceVariant,
      onSurface: AppColor.darkTextPrimary,
      tertiary: AppColor.lightSurfaceVariant,
      error: AppColor.error
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.darkBackground,
      foregroundColor: AppColor.darkTextPrimary,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
    ),
    textTheme: _textTheme(AppColor.darkTextPrimary, AppColor.darkTextSecondary),
    dividerColor: AppColor.darkBorder,
    splashFactory: InkSparkle.splashFactory,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColor.darkBorder)
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColor.darkBorder)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColor.brandBlueDark, width: 2)
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColor.error)
      ),
    )
  );

  static TextTheme _textTheme(Color primaryColor, Color secondaryColor){
    return TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.5,  
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.3
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryColor
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryColor
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor
      ),
    );
  }
}