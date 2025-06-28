import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      canvasColor: const Color(0xFFFFF2EC),
      cardColor: AppConstants.surfaceColor,
      hintColor: AppConstants.hintColor,
      primaryColor: AppConstants.primaryColor,

      colorScheme: const ColorScheme.light(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.secondaryColor,
        surface: AppConstants.surfaceColor,
        onPrimary: Colors.white,
        onSecondary: AppConstants.textColor,
        onSurface: AppConstants.textColor,
        background: AppConstants.backgroundColor,
        onBackground: AppConstants.textColor,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppConstants.backgroundColor,
        foregroundColor: AppConstants.textColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeXLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textColor,
        ),
        iconTheme: const IconThemeData(color: AppConstants.textColor, size: 24),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeXXLarge,
          fontWeight: FontWeight.bold,
          color: AppConstants.textColor,
        ),
        displayMedium: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeXLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textColor,
        ),
        displaySmall: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeLarge,
          fontWeight: FontWeight.w500,
          color: AppConstants.textColor,
        ),
        headlineLarge: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textColor,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeMedium,
          fontWeight: FontWeight.w500,
          color: AppConstants.textColor,
        ),
        headlineSmall: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeSmall,
          fontWeight: FontWeight.w400,
          color: AppConstants.textColor,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeMedium,
          color: AppConstants.textColor,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeSmall,
          color: AppConstants.textColor,
        ),
        labelLarge: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeMedium,
          fontWeight: FontWeight.w500,
          color: AppConstants.textColor,
        ),
        labelMedium: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeSmall,
          color: AppConstants.textColor,
        ),
      ),

      cardTheme: CardTheme(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        color: AppConstants.surfaceColor,
        margin: const EdgeInsets.all(AppConstants.paddingSmall),
      ),

      iconTheme: const IconThemeData(
        color: AppConstants.primaryColor,
        size: 24,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          textStyle: TextStyle(
            fontFamily: AppConstants.persianFont,
            fontSize: AppConstants.textSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: const BorderSide(color: AppConstants.primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          textStyle: TextStyle(
            fontFamily: AppConstants.persianFont,
            fontSize: AppConstants.textSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          textStyle: TextStyle(
            fontFamily: AppConstants.persianFont,
            fontSize: AppConstants.textSizeMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppConstants.hintColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppConstants.hintColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: TextStyle(
          fontFamily: AppConstants.persianFont,
          color: AppConstants.hintColor,
        ),
        hintStyle: TextStyle(
          fontFamily: AppConstants.persianFont,
          color: AppConstants.hintColor,
        ),
        contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppConstants.primaryColor,
        contentTextStyle: TextStyle(
          fontFamily: AppConstants.persianFont,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),

      dialogTheme: DialogTheme(
        backgroundColor: AppConstants.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        titleTextStyle: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textColor,
        ),
        contentTextStyle: TextStyle(
          fontFamily: AppConstants.persianFont,
          fontSize: AppConstants.textSizeMedium,
          color: AppConstants.textColor,
        ),
      ),
    );
  }
}
