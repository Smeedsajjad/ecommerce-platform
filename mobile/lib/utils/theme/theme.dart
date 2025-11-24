import 'package:ecommerence/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import 'widget_themes/appbar_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/outlined_button_theme.dart';
import 'widget_themes/text_field_theme.dart';
import 'widget_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: AppTextTheme.textTheme,
    appBarTheme: AppAppBarTheme.appBarTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.elevatedButtonTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.outlinedButtonTheme,
    inputDecorationTheme: AppTextFormFieldTheme.inputDecorationTheme,
  );
}
