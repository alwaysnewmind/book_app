import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    dividerColor: AppColors.border,

    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textPrimary),
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
      titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderRadiusMd,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        textStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primaryDark,
    dividerColor: AppColors.borderDark,

    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.textPrimaryDark),
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark),
      titleMedium: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
      labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryDark),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark),
      iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderRadiusMd,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        textStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
