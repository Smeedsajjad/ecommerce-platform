import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Elevated Button Themes -- */
class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static final elevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.dark,
      side: const BorderSide(color: AppColors.dark),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg)),
    ),
  );

}
